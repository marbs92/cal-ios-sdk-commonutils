//
//  BAZ_FirebaseManager.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 20/12/21.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import FirebaseStorage
import Firebase
import SDKCUtilsCorresponsal
import FirebaseDynamicLinks

public enum EnviromentFirebase: String
{
    case Release        = "Release"
    case Prod           = "Prod"
    case Qa             = "Qa"
    case Development    = "Development"
    
    init(intValue: Int) {
        switch intValue {
        case 0: self = EnviromentFirebase.Development
        case 1: self = EnviromentFirebase.Qa
        case 2: self = EnviromentFirebase.Prod
        case 3: self = EnviromentFirebase.Release
        default: self = EnviromentFirebase.Development
        }
    }
    
}

public protocol AceptaPagoFirebaseDelegate: AnyObject {
    func forceLogOutFromFirebase(from: BAZ_FirebaseManager)
    func doesHaveToShowAlert(showAlert: Bool, from: BAZ_FirebaseManager)
}

open class BAZ_FirebaseManager {
    public static let shared = BAZ_FirebaseManager()
    public weak var delegate : AceptaPagoFirebaseDelegate?
    private var temporalListener: ListenerRegistration?
    private let coleccionAceptaPagoUsers  = "usuarios"
    private let collectionFuntionalities = "funcionalidadesIOS"
    private var firestoreLogObserverStarted = false
    
    public var firestore : Firestore?
}

public struct BAZ_FirebaseFuntionalities: Codable{
    public var onboardingOnline: Bool?
    public var promociones: [baz_promociones]?
    public var promocionesOnline: Bool?
    
    public struct baz_promociones: Codable{
        public var flujo: baz_flujo?
        public var habilitado: Bool?
        public var orden: Int?
        
        public struct baz_flujo :Codable{
            public var id: Int?
            public var descripcion: String?
        }
    }
    
    public init(){
        self.onboardingOnline = false
        self.promociones = [baz_promociones]()
        self.promocionesOnline = false
    }
}

//Manage other app behavior
extension BAZ_FirebaseManager {
    public func initFirestore() {
        if self.firestore == nil {
            self.configureFirestore()
            self.initFirestoreLogListener()
        }
    }
    
    private func initFirestoreLogListener() {
        guard self.firestore != nil else { return }
        
        guard SettingServiceManagerDefinition.shared.firebasePrinterApp else { return }
        
        guard !self.firestoreLogObserverStarted else { return }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerRegisterFirebaseLog),
                                               name:  Notification.Name("NotificationIdentifierListeningFirestoreLog"),
                                               object: nil)
        
        self.firestoreLogObserverStarted = true
    }
    
    public func initSessionStateListener()
    {
        self.initSessionState()
    }
    
    private func configureFirestore() {
        if let app = FirebaseApp.app() {
            let db = Firestore.firestore(app: app)
            db.settings.isPersistenceEnabled = true
            self.firestore = db
        }
    }
    
    public func getFirestoreInstance() -> Firestore?
    {
        if self.firestore == nil {
            initFirestore()
        }
        return self.firestore
    }
}


//MARK : - LogOut session when user LogIn from another device
extension BAZ_FirebaseManager {
    
    private func getCurrentSession()->String?{
        return KeychainManager.shared.getValue(forKey: UserAkKeystore.id.rawValue)
    }
    
    private func initSessionState(){
        self.setSessionsState(state: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.changeSession()
        }
    }
    
    public func fetchFuntionalities(functionalities:@escaping([String: Any])->Void){
        if let database = self.firestore{
            database.clearPersistence { _ in }
            self.temporalListener =  database.collection(self.collectionFuntionalities)
                .document(SettingServiceManagerDefinition.shared.firebaseFuntionalities)
                .addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot,
                          documentSnapshot?.exists == true,
                          let data = document.data(),
                          data.isEmpty == false else {
                        functionalities([:])
                        self.temporalListener?.remove()
                        return
                    }
                    functionalities(data)
                    self.temporalListener?.remove()
                }
        }else{
            functionalities([:])
            self.temporalListener?.remove()
        }
    }
    
    func changeSession(){
        let currentidDispostivo = UIDevice.current.getDeviceByPlatform()
        if let database = self.firestore{
            if let userId = getCurrentSession(){
                database.collection(self.coleccionAceptaPagoUsers).document(userId)
                    .addSnapshotListener { documentSnapshot, error in
                        guard let document = documentSnapshot else {
                            printDebug("Error fetching document: \(error!)")
                            return
                        }
                        guard let data = document.data() else {
                            printDebug("Document data was empty.")
                            return
                        }
                        if !data.isEmpty{
                            if let documentidDispostivo = data["dispositivo"] as? String, documentidDispostivo != currentidDispostivo{
                                    self.delegate?.doesHaveToShowAlert(showAlert: true, from: self)
                            }
                        }
                    }
            }
        }
    }
    public func setSessionsState(state: Bool){
        let currentidDispostivo = UIDevice.current.getDeviceByPlatform()
        if let database = self.firestore{
            if let userId = getCurrentSession(){
                 database.collection(self.coleccionAceptaPagoUsers).document(userId).setData(["dispositivo": currentidDispostivo])
            }
        }
    }
    
    public func uploadMedia(img: UIImage,
                            phoneNumber: String,
                            ticketID: String,
                            success: @escaping (_ response: String?) -> (),
                            failure: @escaping (_ error: Error?) -> ()) {
        let phone = phoneNumber
        let idTicket = ticketID
        let path = phone + "/" + idTicket
        
        let storage = Storage.storage().reference()
        guard  let imageData = img.jpegData(compressionQuality: 0) else {
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storage.child(path).putData(imageData, metadata: metaData) { (_, error) in
            if let _ = error {
                failure(error)
                return
            }
            storage.child(path).downloadURL { url, error in
                guard let nonNilFullURL = url else{
                    failure(error)
                    return
                }
                
                self.shortenURL(url: nonNilFullURL) { shortenedURL in
                    success(shortenedURL)
                } failure: { _ in
                    success(nonNilFullURL.absoluteString)
                }
            }
            printDebug("Image sent")
        }
    }
    
    private func shortenURL(url: URL,
                            success: @escaping (_ shortenedURL: String) -> (),
                            failure: @escaping (_ error: Error?) -> ()){
        let linkBuilder = DynamicLinkComponents(link: url, domainURIPrefix: "https://baceptapago.com/eticket")
        linkBuilder?.options = DynamicLinkComponentsOptions()
        linkBuilder?.options?.pathLength = .short
        linkBuilder?.shorten(completion: { url, warnings, error in
            guard let nonNilStringShortURL = url?.absoluteString else {
                failure(error)
                return
            }
            success(nonNilStringShortURL)
        })
    }
    
    public func registerDocument(collection: String,
                                 document: String?,
                                 data: [String: String]) {
        if let database = self.firestore{
            guard let nonNilDocument = document else {
                database.collection(collection).document().setData(data)
                return
            }
            database.collection(collection).document(nonNilDocument).setData(data)
        }
    }
    
    
    @objc private func observerRegisterFirebaseLog(_ notification: Notification) {
        guard SettingServiceManagerDefinition.shared.firebasePrinterApp else { return }
        
        guard let dictionary = notification.userInfo as? [String: String] else { return }
        
        self.registerDocument(collection: "logApp",
                              document: nil,
                              data: dictionary)
    }
}
