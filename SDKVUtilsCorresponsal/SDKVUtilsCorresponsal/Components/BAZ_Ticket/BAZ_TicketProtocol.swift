//
//  BAZ_TicketContracts.swift
//  cal-ios-sdk-deposit
//
//  Created Jorge Cruz on 03/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

//MARK: View -
public protocol BAZ_TicketViewProtocol: AnyObject{
    func showLoading()
    func dissmissLoading()
    
    func displayFailureMessage(message:String)
    func displayTicketInfo(ticketInfo: BAZ_TicketResponse?)
}

//MARK: Presenter -
public protocol BAZ_TicketPresenterProtocol: AnyObject{
    func requestTicketInfo()
    func responseTicketInfo(response: BAZ_TicketResponse?)
    
    func responseFailuerTicketinfo(msg: String)
    func requestShareTicketToSMS(amount: Double, ticketImage: UIImage, ticketID: String, message: String,flujoArchivo: Int)
}

//MARK: Interactor -
public protocol BAZ_TicketInteractorProtocol: AnyObject{
    func fetchTicketInfo()
}

//MARK: Router -
public protocol BAZ_TicketRouterProtocol: AnyObject{
    func navigateToShareTicketToSMS(amount: Double, ticketImage: UIImage, ticketID: String, message: String,flujoArchivo: Int)

}
