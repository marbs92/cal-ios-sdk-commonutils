//
//  BAZ_SendSMSPresenter.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 14/12/21.
//

import UIKit
class BAZ_SendSMSPresenter {
    var interactor: BAZ_SendSMSInteractorProtocol?
    weak var view: BAZ_SendSMSViewProtocol?
}

extension BAZ_SendSMSPresenter: BAZ_SendSMSPresenterProtocol {
    func responseError(msg: String) {
        self.view?.notifyError(msg: msg)
    }
    
    func requestSMS(phoneNumber: Int, amount: Double, ticketImage: UIImage, ticketID: String, ticketType: SMSTicketType, customMessage: String?,flujoArchivo: Int?) {
        self.interactor?.postSMS(phoneNumber: phoneNumber, amount: amount, ticketImage: ticketImage, ticketID: ticketID, ticketType: ticketType, customMessage: customMessage,flujoArchivo: flujoArchivo)
    }
    
    func responseSuccess(msg: String){
        self.view?.notifySuccess(msg: msg)
    }
}
