//
//  BAZ_SendSMSMain.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 14/12/21.
//

import Foundation
import UIKit

open class BAZ_SendSMSMain{
    public static func createModule(amount: Double,
                                    ticketImage: UIImage,
                                    ticketID: String,
                                    ticketType: SMSTicketType = .Transaction,
                                    customMessage: String? = nil,
                                    flujoArchivo: Int?) -> UIViewController {
        let viewController: BAZ_SendSMSView? = BAZ_SendSMSView()
        if let view = viewController {
            let presenter = BAZ_SendSMSPresenter()
            let interactor = BAZ_SendSMSInteractor()
            
            view.presenter = presenter
            view.amount = amount
            view.ticketImage = ticketImage
            view.ticketID = ticketID
            view.ticketType = ticketType
            view.customMessage = customMessage
            view.flujoArchivo = flujoArchivo
            
            presenter.view = view
            presenter.interactor = interactor
            
            interactor.presenter = presenter
            return view
        }
        return UIViewController()
    }
    
    
}
