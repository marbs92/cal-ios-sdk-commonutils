//
//  BAZ_FirebaseLogManager.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 01/09/22.
//

import Foundation
import SDKCUtilsCorresponsal


open class BAZ_FirebaseLogManager {
    private static let collectionlogApp = "logApp"
    
    
    private static func getJSONStringFromModel<T: Codable>(_ model: T?) -> String {
        guard let nonNilModel = model,
              let jsonData = try? JSONEncoder().encode(nonNilModel),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return ""
        }
        
        return jsonString
    }
    
    private static func getJSONStringFromData(_ data: Data?) -> String {
        guard let nonNilData = data,
              let jsonString = String(data: nonNilData, encoding: .utf8) else {
            return ""
        }
        
        return jsonString
    }
    
    
    public static func registerFailureServiceLog<Request: Codable>(endpoint: String,
                                                                   accessID: String,
                                                                   requestEncrypted: Request?,
                                                                   requestDecrypted: Request?,
                                                                   responseError: NetworkError?) {
        self.registerLog(endpoint: endpoint,
                         accessID: accessID,
                         requestEncrypted: self.getJSONStringFromModel(requestEncrypted),
                         requestDecrypted: self.getJSONStringFromModel(requestDecrypted),
                         responseDecrypted: self.getJSONStringFromData(responseError?.genericError().dataResponse))
    }
    
    public static func registerFailureServiceLog<Request: Codable>(endpoint: String,
                                                                   accessID: String,
                                                                   requestDecrypted: Request?,
                                                                   responseError: NetworkError?) {
        self.registerLog(endpoint: endpoint,
                         accessID: accessID,
                         requestDecrypted: self.getJSONStringFromModel(requestDecrypted),
                         responseDecrypted: self.getJSONStringFromData(responseError?.genericError().dataResponse))
    }
    
    public static func registerFailureServiceLog(endpoint: String,
                                                 accessID: String,
                                                 responseError: NetworkError?) {
        self.registerLog(endpoint: endpoint,
                         accessID: accessID,
                         responseDecrypted: self.getJSONStringFromData(responseError?.genericError().dataResponse))
    }
    
    
    public static func registerServiceLog<Request: Codable, Response: Codable>(endpoint: String,
                                                                               accessID: String,
                                                                               requestEncrypted: Request?,
                                                                               requestDecrypted: Request?,
                                                                               responseEncrypted: Response?,
                                                                               responseDecrypted: Response?) {
        self.registerLog(endpoint: endpoint,
                         accessID: accessID,
                         requestEncrypted: self.getJSONStringFromModel(requestEncrypted),
                         requestDecrypted: self.getJSONStringFromModel(requestDecrypted),
                         responseEncrypted: self.getJSONStringFromModel(responseEncrypted),
                         responseDecrypted: self.getJSONStringFromModel(responseDecrypted))
    }
    
    public static func registerServiceLog<Request: Codable, Response: Codable>(endpoint: String,
                                                                               accessID: String,
                                                                               requestDecrypted: Request?,
                                                                               responseEncrypted: Response?,
                                                                               responseDecrypted: Response?) {
        self.registerLog(endpoint: endpoint,
                         accessID: accessID,
                         requestDecrypted: self.getJSONStringFromModel(requestDecrypted),
                         responseEncrypted: self.getJSONStringFromModel(responseEncrypted),
                         responseDecrypted: self.getJSONStringFromModel(responseDecrypted))
    }
    
    public static func registerServiceLog<Request: Codable>(endpoint: String,
                                                            accessID: String,
                                                            requestEncrypted: Request?,
                                                            requestDecrypted: Request?) {
        self.registerLog(endpoint: endpoint,
                         accessID: accessID,
                         requestEncrypted: self.getJSONStringFromModel(requestEncrypted),
                         requestDecrypted: self.getJSONStringFromModel(requestDecrypted))
    }
    
    
    public static func registerServiceLog<Response: Codable>(endpoint: String,
                                                             accessID: String,
                                                             responseEncrypted: Response?,
                                                             responseDecrypted: Response?) {
        self.registerLog(endpoint: endpoint,
                         accessID: accessID,
                         responseEncrypted: self.getJSONStringFromModel(responseEncrypted),
                         responseDecrypted: self.getJSONStringFromModel(responseDecrypted))
    }
    
    
    public static func registerServiceLog(endpoint: String,
                                          accessID: String) {
        self.registerLog(endpoint: endpoint,
                         accessID: accessID)
    }
    
    
    private static func registerLog(endpoint: String,
                                    accessID: String,
                                    requestEncrypted: String? = nil,
                                    requestDecrypted: String? = nil,
                                    responseEncrypted: String? = nil,
                                    responseDecrypted: String? = nil) {
        if SettingServiceManagerDefinition.shared.firebasePrinterApp {
            let dictionary = ["endpoint": endpoint,
                              "key": accessID,
                              "bodyRequestCript": requestEncrypted ?? "",
                              "bodyRequestClear": requestDecrypted ?? "",
                              "bodyResponseCript": responseEncrypted ?? "",
                              "bodyResponseClear": responseDecrypted ?? ""]
            
            BAZ_FirebaseManager.shared.registerDocument(collection: self.collectionlogApp,
                                                        document: nil,
                                                        data: dictionary)
        }
    }
}
