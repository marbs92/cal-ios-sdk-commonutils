//
//  BAZ_TicketStatus.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 24/11/21.
//

import Foundation
import SDKCUtilsCorresponsal

public class BAZ_TicketStatus{
    
    public static let shared    =   BAZ_TicketStatus()
    public var entity           :   BAZ_TicketStatusEntity? = BAZ_TicketStatusEntity()
    
    public func setConfig() {
        SettingServiceManager.shared.base = BAZ_TicketStatusConfigWS.base.value
        SettingServiceManager.shared.host = BAZ_TicketStatusConfigWS.host.value
        SettingServiceManager.shared.token = BAZ_TicketStatusConfigWS.token.value
        SettingServiceManager.shared.valToken = BAZ_TicketStatusConfigWS.valToken.value
    }
}


public class BAZ_TicketStatusEntity {
    public var idTicket : String?
}
