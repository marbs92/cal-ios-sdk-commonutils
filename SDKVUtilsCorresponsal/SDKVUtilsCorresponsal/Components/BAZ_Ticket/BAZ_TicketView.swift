//
//  BAZ_TicketView.swift
//  cal-ios-sdk-deposit
//
//  Created Jorge Cruz on 03/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

/// BAZ_Ticket Module View
class BAZ_TicketView: UIViewController {
    
    public var operationType                :   BAZ_OptionsMenuType?
    public var operationResponse            :   BAZ_TicketEntity!
    public var numberOfBacks                :   Int = 1
    public var requirePrintOnInitialModule  :   Bool?
    public var hiddenBackButton             :   Bool?
    public var flujoArchivo                 :   Int?
    
    private var ticketInfo  :   BAZ_TicketResponse?
    private var ui          :   BAZ_TicketViewUI?
    public var presenter    :   BAZ_TicketPresenterProtocol?
    
    private var amount: Double = 0.0
    private var message: String = ""
    
    override func loadView() {
        ui = BAZ_TicketViewUI(
            navigation: self.navigationController!,
            delegate: self,
            operationType: operationType,
            operationResponse: operationResponse,
            hiddenBackButton: hiddenBackButton ?? true)
        view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        presenter?.requestTicketInfo()
    }
    
    private func showAlert(whitMessage msg: String){
        let alertView = BAZ_BackendAlertView()
        alertView.delegate = self
        alertView.modalPresentationStyle = .fullScreen
        alertView.withTitleNav = operationType?.rawValue ?? ""
        alertView.withErroMessage = msg.components(separatedBy: ",")
        present(alertView, animated: true, completion: nil)
    }
}

extension BAZ_TicketView: BAZ_BackendAlertViewDelegate{
    func realoadAction() {
        presenter?.requestTicketInfo()
    }
}

// MARK: - extending BAZ_TicketView to implement it's protocol
extension BAZ_TicketView: BAZ_TicketViewProtocol {
    
    func showLoading() {
        BAZ_UILoaderESAN.show(parent: self.view)
    }
    
    func dissmissLoading() {
        BAZ_UILoaderESAN.remove(parent: self.view)
    }
    
    func displayFailureMessage(message: String) {
        showAlert(whitMessage: message)
    }
    
    func displayTicketInfo(ticketInfo: BAZ_TicketResponse?) {
        self.ticketInfo = ticketInfo
        flujoArchivo = Int(ticketInfo?.flujoArchivo ?? "0")
        let ticket = BAZ_TicketEntity(
            module: ticketInfo?.descripcionReferencia ?? "",
            moduleDescription: ticketInfo?.numeroReferencia ?? "",
            importe: ticketInfo?.monto?.priceUnDecorative() ?? "0.00",
            comision: ticketInfo?.comision?.priceUnDecorative() ?? "0.00",
            ivaComision: ticketInfo?.iva?.priceUnDecorative() ?? "0.00",
            total: ticketInfo?.montoTotal?.priceUnDecorative() ?? "0.00",
            folio: ticketInfo?.id ?? "##",
            authorizationFolio: ticketInfo?.folioBanco ?? "##",
            folioAdmin: ticketInfo?.folioAdministrador ?? "##",
            idTransaccion: ticketInfo?.comercio?.operacion?.id ?? ""
        )
        
        ui?.buildInformation(entityBaz: ticket)
        
        self.amount = Double(ticketInfo?.montoTotal?.priceUnDecorative() ?? "0.0") ?? 0.0
    }
    
    private func requireRefreshCurrentCapital(){
        if operationType != .OperationHistory{
            NotificationCenter.default.post(name: NSNotification.Name("NotificationIdentifierListeningRefreshCurrentCapital"), object: nil)
        }
    }
}

// MARK: - extending BAZ_TicketView to implement the custom ui view delegate
extension BAZ_TicketView: BAZ_TicketViewUIDelegate {
    func notifyShareTicketToSMS() {
        
        let ticketView = BAZ_GenericTicketView(
            data: ticketInfo!,
            type: operationType!,
            isACopy: false,
            isElectronicTicket: true)
        
        var title : String {
            get{
                if ticketInfo?.comercio?.operacion?.descripcionTipo != nil{
                    switch ticketInfo?.comercio?.operacion?.descripcionTipo {
                    case "PAGO DE CRÉDITO PERSONAL Y CONSUMO":
                        return "Pago Credimax"
                    case "PAGO TARJETA DE CRÉDITO":
                        return "Pago TDC"
                    case "CONSULTA DE MOVIMIENTOS":
                        return "Consulta Mov"
                    case "DEPÓSITO EN EFECTIVO":
                        if operationType == .DepositCuenta {
                            return "Depósito CTA"
                        } else if  operationType == .DepositTarjeta {
                            return "Depósito TDD"
                        } else {
                            return "Depósito TDD / CTA"
                        }
                    default:
                        return ticketInfo?.comercio?.operacion?.descripcionTipo?.capitalized ?? ""
                    }
                }else{
                    return ""
                }
            }
        }
        
        if self.amount != 5.0 {
            self.message = "\(title) \(self.amount.formatAsMoney()) Exitoso \(ticketInfo?.fechaHora ?? "")" + "\n" + " Folio \(ticketInfo?.folioAdministrador ?? "")"
        } else {
            self.message = "\(ticketInfo?.comercio?.operacion?.descripcionTipo?.capitalized ?? "") Exitoso \(ticketInfo?.fechaHora ?? "")" + "\n" + " Folio \(ticketInfo?.folioAdministrador ?? "")"
        }
            
        if let ticketID = self.ticketInfo?.id{
            self.presenter?.requestShareTicketToSMS(amount: self.amount, ticketImage: ticketView.asImage(), ticketID: ticketID, message: self.message,flujoArchivo: self.flujoArchivo ?? 0)
            notifyFinishTicket()
        }
    }
    
    func notifyFinishTicket() {
        requireRefreshCurrentCapital()
        self.navigationController?.popToRootViewController(animated: true)
    }
}
