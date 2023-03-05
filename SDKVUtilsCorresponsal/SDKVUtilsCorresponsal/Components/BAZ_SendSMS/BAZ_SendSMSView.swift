//
//  BAZ_SendSMSView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 14/12/21.
//

import Foundation
import UIKit

public enum SMSTicketType {
    case Transaction
    case Rejection
}

class BAZ_SendSMSView: UIViewController {
    var presenter: BAZ_SendSMSPresenterProtocol?
    private var ui: BAZ_SendSMSViewUI?
    private var number: Int?
    private var alertView: BAZ_UpdatedAlertView?
    private var errorAlertView: BAZ_BackendAlertView?
    public var operationType                :   BAZ_OptionsMenuType?
    internal var amount: Double = 0
    internal var ticketImage: UIImage?
    internal var ticketID: String = ""
    internal var ticketType: SMSTicketType = .Transaction
    internal var customMessage: String? = nil
    internal var flujoArchivo: Int?
    
    override func loadView() {
        ui = BAZ_SendSMSViewUI(
            delegate: self
        )
        view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.ui?.deleteKeyboardObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.ui?.setKeyboardObservers()
    }
    
    private func requireRefreshCurrentCapital(){
        if operationType != .OperationHistory{
            NotificationCenter.default.post(name: NSNotification.Name("NotificationIdentifierListeningRefreshCurrentCapital"), object: nil)
        }
    }
    
}

extension BAZ_SendSMSView: BAZ_SendSMSViewProtocol {
    func notifySuccess(msg: String){
        DispatchQueue.main.async {
            BAZ_UILoaderESAN.remove(parent: self.view)
            self.number = nil
            self.ticketID = ""
            self.ticketImage = nil
            self.customMessage = nil
            
            self.alertView = BAZ_UpdatedAlertView(parent: self,
                                             delegate: self,
                                             title: "Envío de SMS",
                                             message: "Exitoso",
                                             showOptionalButton: false,
                                             optionalButtonTitleText: "")
        }
    }
    
    func notifyError(msg: String) {
        DispatchQueue.main.async {
            BAZ_UILoaderESAN.remove(parent: self.view)
            self.errorAlertView = BAZ_BackendAlertView()
            self.errorAlertView?.delegate = self
            self.errorAlertView?.modalPresentationStyle = .fullScreen
            self.errorAlertView?.withTitleNav = "Envío de SMS"
            self.errorAlertView?.withErroMessage = msg.components(separatedBy: ",")
            if let alert = self.errorAlertView{
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension BAZ_SendSMSView: BAZ_SendSMSViewUIDelegate {
    func notifyReturn(){
        self.dismiss(animated: true)
    }
    
    func notifySendSMS(phoneNumer: Int){
        self.number = phoneNumer
        
        if let phoneNumber = self.number, String(phoneNumber).count == 10, let image = self.ticketImage, !self.ticketID.isEmpty{
            DispatchQueue.main.async {
                BAZ_UILoaderESAN.show(parent: self.view)
            }
            self.presenter?.requestSMS(phoneNumber: phoneNumber, amount: self.amount, ticketImage: image, ticketID: self.ticketID, ticketType: self.ticketType, customMessage: self.customMessage,flujoArchivo: flujoArchivo)
        }else {
            self.number = -1
        }
    }
}

extension BAZ_SendSMSView: BAZ_BackendAlertViewDelegate{
    func realoadAction() {
        if let phoneNumber = self.number, String(phoneNumber).count == 10, let image = self.ticketImage, !self.ticketID.isEmpty{
            DispatchQueue.main.async {
                BAZ_UILoaderESAN.show(parent: self.view)
            }
            self.presenter?.requestSMS(phoneNumber: phoneNumber, amount: self.amount, ticketImage: image,  ticketID: self.ticketID, ticketType: self.ticketType, customMessage: self.customMessage,flujoArchivo: flujoArchivo)
        }else {
            self.dismiss(animated: true)
        }
    }
    
    func backAction(){
        errorAlertView?.dismiss(animated: true)
    }
}

extension BAZ_SendSMSView: BAZ_UpdatedAlertViewProtocol {
    func notifyAccept() {
        self.dismiss(animated: true)
    }
}
