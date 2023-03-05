//
//  BAZ_SendSMSServices.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Fernando Sánchez Palma on 24/02/22.
//

import Foundation
import SDKCUtilsCorresponsal

public class BAZ_SendSMSServices {
    
    public static let shared    =   BAZ_SendSMSServices()
    
    public func setConfig() {
        SettingServiceManager.shared.base = BAZ_SendSMSWebServicesConfigWS.base.value
        SettingServiceManager.shared.host = BAZ_SendSMSWebServicesConfigWS.host.value
        SettingServiceManager.shared.token = BAZ_SendSMSWebServicesConfigWS.token.value
        SettingServiceManager.shared.valToken = BAZ_SendSMSWebServicesConfigWS.valToken.value
    }
}

public enum BAZ_SendSMSServicesEnvironment {
    case development
    case qa
    case release
}
