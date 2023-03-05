//
//  BAZ_SendSMSProtocols.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 14/12/21.
//

import UIKit
protocol BAZ_SendSMSViewProtocol: AnyObject {
    func notifySuccess(msg: String)
    func notifyError(msg: String)
}

protocol BAZ_SendSMSInteractorProtocol: AnyObject {
    func postSMS(phoneNumber: Int, amount: Double, ticketImage: UIImage, ticketID: String, ticketType: SMSTicketType, customMessage: String?,flujoArchivo: Int?)
}

protocol BAZ_SendSMSPresenterProtocol: AnyObject {
    func requestSMS(phoneNumber: Int, amount: Double, ticketImage: UIImage, ticketID: String, ticketType: SMSTicketType, customMessage: String?,flujoArchivo: Int?)
    func responseSuccess(msg: String)
    func responseError(msg: String)
}
