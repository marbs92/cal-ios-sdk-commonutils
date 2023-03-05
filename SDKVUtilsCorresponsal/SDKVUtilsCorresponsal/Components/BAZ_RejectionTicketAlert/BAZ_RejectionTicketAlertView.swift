//
//  BAZ_RejectionTicketAlertView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 09/02/22.
//

import Foundation
import UIKit

@objc public protocol BAZ_RejectionTicketAlertProtocol {
    @objc optional func backActionRejectionTicket()
    @objc optional func backActionWithTagRejectionTicket(tag: Int)
}

class BAZ_RejectionTicketAlertView: UIViewController {
    var presenter: BAZ_RejectionTicketAlertPresenterProtocol?
    private var ui: BAZ_RejectionTicketAlertViewUI?
    
    internal var delegate: BAZ_RejectionTicketAlertProtocol?
    internal var alertTitle: String?
    internal var ticketID: Int?
    internal var customMessage: [String]?
    internal var viewTag: Int = 0
    internal var flujoArchivo: Int?
    
    private var rejectionTicketResponse: BAZ_RejectionTicketResponse?
    
    override func loadView() {
        ui = BAZ_RejectionTicketAlertViewUI(
            delegate: self,
            alertTitle: self.alertTitle ?? "",
            customMessage: self.customMessage
        )
        view = ui
        view.tag = self.viewTag
    }
    
    override func viewDidLoad() {
        if let ticketID = self.ticketID {
            DispatchQueue.main.async {
                self.showLoader()
                self.presenter?.requestRejectionTicket(ticketID: ticketID)
            }
        }
    }
    
    private func showLoader(){
        DispatchQueue.main.async {
            BAZ_UILoaderESAN.show(parent: self.view)
        }
    }
    
    private func dismissLoader(){
        DispatchQueue.main.async {
            BAZ_UILoaderESAN.remove(parent: self.view)
        }
    }
}

extension BAZ_RejectionTicketAlertView: BAZ_RejectionTicketAlertViewProtocol {
    func notifyRejectionTicket(ticketData: BAZ_RejectionTicketResponse) {
        self.dismissLoader()
        self.ui?.setRejectionTicketMessage(msg: ticketData.estatus?.components(separatedBy: ",") ?? [])
        self.rejectionTicketResponse = ticketData
    }
    
    func notifyError(msg: String) {
        self.dismissLoader()
        self.ui?.setBackErrorMessage(msg: msg.components(separatedBy: ","))
    }
}

extension BAZ_RejectionTicketAlertView: BAZ_RejectionTicketAlertViewUIDelegate {
    func notifyShareRejectionTicket() {
        if let rejectionTicketInfo = self.rejectionTicketResponse, let ticketID = self.ticketID {
            let physicalRejectionTicket = BAZ_RejectionTicketView(data: rejectionTicketInfo).asImage()
            let message = "Transacción no realizada \(rejectionTicketInfo.operacion?.fechaHora ?? "")"
            let vc = BAZ_SendSMSMain.createModule(amount: 0.0,
                                                  ticketImage: physicalRejectionTicket,
                                                  ticketID: String(ticketID),
                                                  ticketType: .Rejection,
                                                  customMessage: message,
                                                  flujoArchivo: flujoArchivo)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    func notifyExit() {
        self.ticketID = nil
        self.rejectionTicketResponse = nil
        dismiss(animated: true, completion: {
            self.delegate?.backActionRejectionTicket?()
            self.delegate?.backActionWithTagRejectionTicket?(tag: self.view.tag)
        })
    }
}

