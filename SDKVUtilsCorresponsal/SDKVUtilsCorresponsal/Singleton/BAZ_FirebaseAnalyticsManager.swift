//
//  BAZ_FirebaseAnalyticsManager.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 14/12/21.
//

import UIKit
import FirebaseAnalytics

public struct BAZ_FirebaseAnalyticModel: Codable{
    public var auth: String = (KeychainManager.shared.getValue(forKey: UserAkKeystore.id.rawValue) != nil && KeychainManager.shared.getValue(forKey: UserAkKeystore.id.rawValue) != "") ?  KeychainManager.shared.getValue(forKey: UserAkKeystore.id.rawValue) ?? "" : KeychainManager.shared.getValue(forKey: UserCPKeystore.id.rawValue) ?? ""
    public var operacion: String?
    public var tiempo_de_respuesta: String?
    public var consumo: String?
    
    public enum nameCodingKeys: String, CodingKey {
        case auth        =   "Auth"
        case operación   =   "Operacion"
        case tiempo_de_respuesta     =   "Tiempo_de_respuesta"
        case consumo     =   "Consumo"
    }
    
    public init(operacion: String,
         tiempo_de_respuesta: String,
         consumo: String
    ){
        self.operacion = operacion
        self.tiempo_de_respuesta = tiempo_de_respuesta
        self.consumo = consumo
    }
    
    
}
open class BAZ_FirebaseAnalyticsManager: NSObject {
    
    public static let shared = BAZ_FirebaseAnalyticsManager()
    
    public func onSaveTraking(trakingModel: BAZ_FirebaseAnalyticModel){
        do{
            let data = try? JSONEncoder().encode(trakingModel)
            guard let data = data, let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                return
            }
            Analytics.logEvent("ServicesManager", parameters: dictionary)
        }catch{
            
        }
        
    }
}
