//
//  BAZ_BackendAlertMain.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 24/11/21.
//

import UIKit

open class BAZ_BackendAlertMain{
    
    public static func createModule(delegate: BAZ_BackendAlertViewDelegate?,
                                    title: String,
                                    errorMsg: [String],
                                    hideRetryButton: Bool? = nil,
                                    idTicket: String? = nil,
                                    rejectionTicket: BAZ_TicketStatusResponse? = nil,
                                    backButtonTitle: String = "Finalizar") -> UIViewController{
        
        BAZ_TicketStatus.shared.setConfig()
        BAZ_TicketStatus.shared.entity?.idTicket = idTicket
        
        let viewController : BAZ_BackendAlertView? = BAZ_BackendAlertView()
        
        if let view = viewController{
            let presenter   =   BAZ_BackendAlertPresenter()
            let interactor  =   BAZ_BackendAlertInteractor()
            
            view.delegate           =   delegate
            view.withTitleNav       =   title
            view.withErroMessage    =   errorMsg
            view.idTicket           =   idTicket
            view.rejectionTicket    =   rejectionTicket
            view.hideRetryButton    =   hideRetryButton
            view.backButtonTitle    =   backButtonTitle
            view.presenter          =   presenter
            
            presenter.view          =   view
            presenter.interactor    =   interactor
            
            interactor.presenter    =   presenter
            
            return view
        }
        
        return UIViewController()
    }
}
