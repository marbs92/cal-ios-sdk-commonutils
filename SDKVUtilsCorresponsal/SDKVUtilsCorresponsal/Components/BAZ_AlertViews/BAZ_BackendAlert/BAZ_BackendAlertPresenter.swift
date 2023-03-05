//
//  BAZ_BackendAlertPresenter.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 24/11/21.
//

import Foundation

class BAZ_BackendAlertPresenter{
    
    public weak var view    :   BAZ_BackendAlertViewProtocol?
    public var interactor   :   BAZ_BackendAlertInteractorProtocol?
}

extension BAZ_BackendAlertPresenter: BAZ_BackendAlertPresenterProtocol{
    
    func requestTicketStatus() {
        view?.showLoading()
        interactor?.fetchTicketStatus()
    }
    
    func responseTicketStatus(response: BAZ_TicketStatusResponse?) {
        view?.dissmissLoading()
        view?.displayTicketStatus(ticket: response)
    }
    
    func responseFailuerTicketStatus(msg: String) {
        view?.dissmissLoading()
        view?.displayFailureMessage(message: msg)
    }
}
