//
//  BAZ_TicketPresenter.swift
//  cal-ios-sdk-deposit
//
//  Created Jorge Cruz on 03/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

/// BAZ_Ticket Module Presenter
public class BAZ_TicketPresenter {
    
    public weak var _view: BAZ_TicketViewProtocol?
    public var interactor: BAZ_TicketInteractorProtocol?
    public var router: BAZ_TicketRouterProtocol?
    
    public init(){}
}

// MARK: - extending BAZ_TicketPresenter to implement it's protocol
extension BAZ_TicketPresenter: BAZ_TicketPresenterProtocol {
    
    public func requestTicketInfo() {
        _view?.showLoading()
        interactor?.fetchTicketInfo()
    }
    
    public func responseFailuerTicketinfo(msg: String) {
        _view?.dissmissLoading()
        _view?.displayFailureMessage(message: msg)
    }
    
    public func responseTicketInfo(response: BAZ_TicketResponse?) {
        _view?.dissmissLoading()
        _view?.displayTicketInfo(ticketInfo: response)
    }
    
    public func requestShareTicketToSMS(amount: Double, ticketImage: UIImage, ticketID: String, message: String,flujoArchivo: Int){
        self.router?.navigateToShareTicketToSMS(amount: amount, ticketImage: ticketImage, ticketID: ticketID, message: message,flujoArchivo: flujoArchivo)
    }
}
