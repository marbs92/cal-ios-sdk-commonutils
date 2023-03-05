//
//  BAZ_RejectionTicketAlertMain.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 09/02/22.
//

import Foundation
import UIKit

open class BAZ_RejectionTicketAlertMain{
    public static func createModule(delegate: BAZ_RejectionTicketAlertProtocol?,
                                    alertTitle: String,
                                    ticketID: Int,
                                    customMessage: [String]? = nil,
                                    tag: Int = 0,
                                    flujoArchivo: Int?) -> UIViewController {
        let viewController: BAZ_RejectionTicketAlertView? = BAZ_RejectionTicketAlertView()
        if let view = viewController {
            let presenter = BAZ_RejectionTicketAlertPresenter()
            let interactor = BAZ_RejectionTicketAlertInteractor()
            
            view.presenter = presenter
            view.delegate = delegate
            view.alertTitle = alertTitle
            view.ticketID = ticketID
            view.customMessage = customMessage
            view.viewTag = tag
            view.flujoArchivo = flujoArchivo
            
            view.modalPresentationStyle = .fullScreen
            
            presenter.view = view
            presenter.interactor = interactor
            
            interactor.presenter = presenter
            
            return view
        }
        return UIViewController()
    }
}
