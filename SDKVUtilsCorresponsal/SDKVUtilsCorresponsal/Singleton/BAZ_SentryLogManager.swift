//
//  BAZ_SentryLogManager.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 28/09/22.
//

import Foundation
import Sentry
import SDKCUtilsCorresponsal


open class BAZ_SentryLogManager {
    public static func registerLog(domain: String = "Fallo servicio de backend",
                                   user: String,
                                   error: NetworkError?,
                                   endpoint: String,
                                   userInfo: [String: Any]? = nil) {
        self.registerLog(domain: domain,
                         statusCode: BAZ_NetworkError.getErrorData(error: error).responseCode,
                         user: user,
                         error: BAZ_NetworkError.getErrorData(error: error).message,
                         endpoint: endpoint,
                         userInfo: userInfo)
    }
    
    public static func registerLog(domain: String = "Fallo servicio de backend",
                                   statusCode: String?,
                                   user: String,
                                   error: String?,
                                   endpoint: String,
                                   userInfo: [String: Any]? = nil) {
        var auxDictionary: [String: Any] = ["usuario": user,
                                            "error": error ?? "",
                                            "endpoint": endpoint]
        
        if let nonNilUserInfo = userInfo {
            for (auxKey, auxValue) in nonNilUserInfo {
                auxDictionary.updateValue(auxValue, forKey: auxKey)
            }
        }
        
        let errorSentry = NSError(domain: domain,
                                  code: Int(statusCode ?? "0") ?? 0,
                                  userInfo: auxDictionary)
        
        SentrySDK.capture(error: errorSentry)
    }
}
