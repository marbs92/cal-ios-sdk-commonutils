//
//  BAZ_RejectionTicketServices.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 09/02/22.
//

import Foundation
import SDKCUtilsCorresponsal

public class BAZ_RejectionTicketServices {
    
    public static let shared    =   BAZ_RejectionTicketServices()
    
    public func setConfig() {
        SettingServiceManager.shared.base = BAZ_RejectionTicketServicesConfigWS.base.value
        SettingServiceManager.shared.host = BAZ_RejectionTicketServicesConfigWS.host.value
        SettingServiceManager.shared.token = BAZ_RejectionTicketServicesConfigWS.token.value
        SettingServiceManager.shared.valToken = BAZ_RejectionTicketServicesConfigWS.valToken.value
    }
}
