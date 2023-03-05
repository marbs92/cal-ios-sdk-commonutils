//
//  BAZ_BackendAlertProtocol.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 24/11/21.
//

import Foundation

//MARK: View -
protocol BAZ_BackendAlertViewProtocol: AnyObject{
    func showLoading()
    func dissmissLoading()
    
    func displayFailureMessage(message:String)
    func displayTicketStatus(ticket: BAZ_TicketStatusResponse?)
}

//MARK: Presenter -
public protocol BAZ_BackendAlertPresenterProtocol: AnyObject{
    func requestTicketStatus()
    func responseTicketStatus(response: BAZ_TicketStatusResponse?)
    
    func responseFailuerTicketStatus(msg: String)
}

//MARK: Interactor -
protocol BAZ_BackendAlertInteractorProtocol: AnyObject{
    func fetchTicketStatus()
}
