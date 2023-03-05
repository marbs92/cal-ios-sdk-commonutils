//
//  BAZ_RejectionTicketServicesConfigWS.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 09/02/22.
//

import Foundation
import SDKCUtilsCorresponsal

public enum BAZ_RejectionTicketServicesConfigWS{
    // Base Url and path
    case base
    case host
    case token
    case valToken
    
    // Path for Tickets
    case ticketStatus
    
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
        case .ticketStatus:
            return "/gestion-comprobantes/v1"
        }
    }
}
