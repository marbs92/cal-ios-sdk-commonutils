//
//  BAZ_TicketRouter.swift
//  cal-ios-sdk-deposit
//
//  Created Jorge Cruz on 03/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

/// BAZ_Ticket Module Router (aka: Wireframe)
public class BAZ_TicketRouter{
    public var navigation: UINavigationController?
    
    public init(){}
}

extension BAZ_TicketRouter: BAZ_TicketRouterProtocol {
    public func navigateToShareTicketToSMS(amount: Double, ticketImage: UIImage, ticketID: String, message: String,flujoArchivo: Int){
        let vc = BAZ_SendSMSMain.createModule(amount: amount, ticketImage: ticketImage, ticketID: ticketID, customMessage: message,flujoArchivo: flujoArchivo)
        vc.modalPresentationStyle = .fullScreen
        self.navigation?.present(vc, animated: true)
    }
}
