//
//  BAZ_RejectionTicketAlertProtocols.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 09/02/22.
//

import Foundation

protocol BAZ_RejectionTicketAlertViewProtocol: AnyObject {
    func notifyRejectionTicket(ticketData: BAZ_RejectionTicketResponse)
    
    func notifyError(msg: String)
}

protocol BAZ_RejectionTicketAlertInteractorProtocol: AnyObject {
    func getRejectionTicket(ticketID: Int)
}

protocol BAZ_RejectionTicketAlertPresenterProtocol: AnyObject {
    func requestRejectionTicket(ticketID: Int)
    func responseRejectionTicket(ticketData: BAZ_RejectionTicketResponse)
    
    func responseError(msg: String)
}
