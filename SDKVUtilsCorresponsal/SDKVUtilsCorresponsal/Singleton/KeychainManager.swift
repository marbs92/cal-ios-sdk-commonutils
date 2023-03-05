//
//  KeychainManager.swift
//  aceptapago-ios-sdk-utils
//
//  Created by David on 02/07/21.
//

import Foundation

open class KeychainManager {
    
    public static let shared = KeychainManager()
    private var container: KeychainSwift = KeychainSwift()

    public func storeValue(value: Data, forKey: String){
        container.set(value, forKey: forKey)
    }
    public func getDataValue(forKey: String) -> Data? {
        return container.getData(forKey)
    }
    
    public func storeValue(value: String, forKey: String) {
        container.set(value, forKey: forKey)
    }
    
    public func getValue(forKey: String) -> String? {
        return container.get(forKey)
    }
    
    public func storeBoolValue(value: Bool, forKey: String) {
        container.set(value, forKey: forKey)
    }
    
    public func getBoolValue(forKey: String) -> Bool?{
        return container.getBool(forKey)
    }
    
    public func removeValue(forKey: String) {
        container.delete(forKey)
    }
    
    public func removeAllValues(fromCloseSesion: Bool = false) {
        var currentFlags : Data?
        var currentLastFlags : String?
        var currentClient : String?
        var currentAuth: String?
        var currentName: String?
        var currentNIP: String?
        
        if fromCloseSesion == false {
            currentFlags = getDataValue(forKey: FlagsAk.funtionalities.rawValue)
            currentLastFlags = getValue(forKey: FlagsAk.lastDateQuery.rawValue)
            currentClient = getValue(forKey: UserAkKeystore.validatedPhone.rawValue)
            currentAuth = getValue(forKey: UserAkKeystore.validatedAuth.rawValue)
            currentName = getValue(forKey: UserAkKeystore.name.rawValue)
            currentNIP = getValue(forKey: FlagsAk.validatedNIP.rawValue)
        }
        
        container.clear()
        
        if let flags = currentFlags { storeValue(value: flags, forKey: FlagsAk.funtionalities.rawValue) }
        
        if let lastFlags = currentLastFlags { storeValue(value: lastFlags, forKey: FlagsAk.lastDateQuery.rawValue) }
        
        if let client = currentClient { storeValue(value: client, forKey: UserAkKeystore.validatedPhone.rawValue) }
        
        if let auth = currentAuth { storeValue(value: auth, forKey: UserAkKeystore.validatedAuth.rawValue) }
        
        if let name = currentName { storeValue(value: name, forKey: UserAkKeystore.name.rawValue) }
        
        if let nip = currentNIP { storeValue(value: nip, forKey: FlagsAk.validatedNIP.rawValue) }
    }
    
}

public enum FlagsAk: String{
    case funtionalities = "flagsFunctionalities"
    case lastDateQuery = "lastDateQuery"
    case validatedNIP = "userValidatedNIP"
}

public enum URLBase: String{
    case Aceptapago = "URLBaseAceptapago"
    case Corresponsal = "URLBaseCorresponsal"
}

public enum LoginBy: String{
    case AceptaPago = "AceptaPago"
    case Corresponsal = "Corresponsal"
}

public enum UserCPKeystore: String{
    case idComisionista = "userIdComisionistaCP"
    case id         =   "userIdCP"
    case name       =   "userNameCP"
    case email      =   "userEmailCP"
    case sesion     =   "userSesionCP"
    
    case lastName           =   "userLastNameCP"
    case secondLastName     =   "userSecondLastNameCP"
    case phone              =   "userPhoneCP"
    case idUserOperator     =   "idUserOperatorCP"
    case requiredTraining   =   "userTraining"
    
    case profileId          =   "commerceCategoryIdCP"
    case profile            =   "commerceProfileCP"
    case description        =   "userDescription"
    case idStatusDevice     =   "idStatusDevice"
    case idCommerce         =   "idCommerce"
    
    case nipChangeRequired = "nipChangeRequiredCP"
    case credentialChangeRequired  = "credentialChangeRequired"
    case nipTemporal = "nipTemporal"
    case credentialChange = "credentialChange"
}

public enum CommerceCPKeystore: String {
    case id         =   "commerceIdCP"
    case name       =   "commerceNameCP"
}
   
public enum UserAkKeystore: String {
    
    case validatedPhone = "userValidatedPhone"
    case validatedAuth = "userValidatedAuth"
    
    case id         =   "userIdAK"
    case name       =   "userNameAK"
    case email      =   "userEmailAK"
    case sesion     =   "userSesionAK"
    case idDevice   =   "userIdDeviceAK"
    
    //nuevos atributos
    case lastName           =   "userLastNameAK"
    case secondLastName     =   "userSecondLastNameAK"
    case phone              =   "userPhoneAK"
    case rfc                =   "userRfcAK"
    case profileId          =   "userProfileIdAK"
    case profile            =   "userProfileAK"
    case statusId           =   "userStatusIdAK"
}

public enum CommerceAKKeystore: String {
    case id         =   "commerceIdAK"
    case name       =   "commerceNameAK"
    case email      =   "commerceEmailAK"
    case qr         =   "commerceQRAK"

    case latitude   =   "commerceLatitudeAK"
    case longitude  =   "commerceLongitudeAK"
    
    case state      =   "commerceStateAK"
    case intNumber   =  "commerceIntNumberAK"
    case suburb     =   "commerceSuburbAK"
    case street     =   "commerceStreetAK"
    case extNumber  =   "commerceExtNumberAK"
    case zipCode    =   "commerceZipCodeAK"
    case city       =   "commerceCityAK"
    case address    =   "commerceAddressAK"

    
    //nuevos atributos
    case affiliateCode           =   "commerceAffiliateCodeAK"
    case categoryId              =   "commerceCategoryIdAK"
    case category                =   "commerceCategoryAK"
    case profileId               =   "commerceProfileIdAK"
    case profile                 =   "commerceProfileAK"
    case amexAffiliateCode       =   "commerceAmexAffiliateCodeAK"
    case minimumPerTransaction   =   "commerceMinimumPerTransactionAK"
    case maximumPerTransaction   =   "commerceMaximumPerTransactionAK"
    case maximumPerDay           =   "commerceMaximumPerDayAK"
    case maximumPerMonth         =   "commerceMaximumPerMonthAK"
    case statusId                =   "commerceStatusIdAK"
    case maximumPerCashback      =   "commerceMaximumPerCashbackAK"
    case minimumPerCashback      =   "commerceMinimumPerCashbackAK"
    case userSerti               =   "commerceUserSertiAK"
    case passSerti               =   "commercePassSertAK"
}

public enum MSIStore: String {
    case numberMSI = "saleNumberMSI"
    case availableMSI = "saleAvailableMSI"
}

public enum CashbackStore : String{
    case amountCashback = "amountCashback"
    case availableCashback = "saleAvailableCashback"
}


public enum TraningApear : String {
    case isTrainingOpen = "isTrainingOpen"
}
