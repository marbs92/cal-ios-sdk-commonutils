//
//  Tickets.swift
//  baz-ios-akpago-utils
//
//  Created by Gustavo Tellez on 12/08/21.
//

import UIKit
import SDKCUtilsCorresponsal

public class BAZ_Tickets{
    
    public static let shared = BAZ_Tickets()
    public var entity: BAZ_TicketsEntity? = BAZ_TicketsEntity()
    
    public func setConfig() {
        SettingServiceManager.shared.base = BAZ_TicketsConfigWS.base.value
        SettingServiceManager.shared.host = BAZ_TicketsConfigWS.host.value
        SettingServiceManager.shared.token = BAZ_TicketsConfigWS.token.value
        SettingServiceManager.shared.valToken = BAZ_TicketsConfigWS.valToken.value
    }
}

public class BAZ_TicketsEntity {
    public var idTicket : String?
}
