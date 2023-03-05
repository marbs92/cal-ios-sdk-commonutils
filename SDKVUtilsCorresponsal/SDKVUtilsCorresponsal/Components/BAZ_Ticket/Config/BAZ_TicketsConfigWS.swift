//
//  BAZ_TicketsConfigWS.swift
//  baz-ios-akpago-utils
//
//  Created by Gustavo Tellez on 12/08/21.
//

import UIKit
import SDKCUtilsCorresponsal

public enum BAZ_TicketsConfigWS{
    
    // Base Url and path
    case base
    case host
    case token
    case valToken
    
    // Path for Tickets
    case tickets
    
    var value: String {
        switch self {
        case .base:
            return "/pagos/corresponsalias"
            
        case .host:
            return SettingServiceManagerDefinition.shared.hostCorresponsal
            
        case .token:
            return "/oauth2/v1/token"
            
        case .valToken:
            return SettingServiceManagerDefinition.shared.tokenCorresponsal
            
        case .tickets:
            return "/gestion-comprobantes/v1"
        }
    }
}
