//
//  BAZ_RejectionTicketAlertInteractor.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 09/02/22.
//

import Foundation
import SDKCUtilsCorresponsal

class BAZ_RejectionTicketAlertInteractor{
    var presenter: BAZ_RejectionTicketAlertPresenterProtocol?
    private let rejectionTicketService = BAZ_RejectionTicketWebService()
}

extension BAZ_RejectionTicketAlertInteractor: BAZ_RejectionTicketAlertInteractorProtocol {
    func getRejectionTicket(ticketID: Int) {
        BAZ_RejectionTicketServices.shared.setConfig()
        self.rejectionTicketService.request(ticketID: ticketID) { (response, error) in
            DispatchQueue.main.async {
                guard let nonNilResponse = response?.resultado?.decrypt() else {
                    self.presenter?.responseError(msg: BAZ_NetworkError.getErrorData(error: error).message)
                    return
                }
                self.presenter?.responseRejectionTicket(ticketData: nonNilResponse)
            }
        }
    }
}
