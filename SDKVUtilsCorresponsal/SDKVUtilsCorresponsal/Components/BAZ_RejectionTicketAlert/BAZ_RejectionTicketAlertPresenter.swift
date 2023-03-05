//
//  BAZ_RejectionTicketAlertPresenter.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 09/02/22.
//

import Foundation

class BAZ_RejectionTicketAlertPresenter {
    var interactor: BAZ_RejectionTicketAlertInteractorProtocol?
    weak var view: BAZ_RejectionTicketAlertViewProtocol?
}



extension BAZ_RejectionTicketAlertPresenter: BAZ_RejectionTicketAlertPresenterProtocol {
    func requestRejectionTicket(ticketID: Int) {
        self.interactor?.getRejectionTicket(ticketID: ticketID)
    }
    
    func responseRejectionTicket(ticketData: BAZ_RejectionTicketResponse) {
        self.view?.notifyRejectionTicket(ticketData: ticketData)
    }
    
    func responseError(msg: String) {
        self.view?.notifyError(msg: msg)
    }
}
