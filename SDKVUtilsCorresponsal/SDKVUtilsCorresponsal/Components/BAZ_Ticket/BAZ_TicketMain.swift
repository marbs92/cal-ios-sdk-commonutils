//
//  BAZ_TicketMain.swift
//  cal-ios-sdk-deposit
//
//  Created by Jorge Cruz on 09/06/21.
//

import UIKit

open class BAZ_TicketMain: NSObject {
    public static func createModule(
        navigation  : UINavigationController,
        operationType: BAZ_OptionsMenuType?,
        operationResponse: BAZ_TicketEntity,
        numberOfBacks: Int,
        requirePrintOnInitialModule: Bool = true,
        hiddenBackButton: Bool = true) -> UIViewController{
        
        BAZ_Tickets.shared.setConfig()
        BAZ_Tickets.shared.entity?.idTicket = operationResponse.folio
        
        let viewController  :   BAZ_TicketView?   =  BAZ_TicketView()
        
        if let view = viewController {
            let presenter   =   BAZ_TicketPresenter()
            let router      =   BAZ_TicketRouter()
            let interactor  =   BAZ_TicketInteractor()
            
            view.operationResponse              =   operationResponse
            view.operationType                  =   operationType
            view.presenter                      =   presenter
            view.numberOfBacks                  =   numberOfBacks
            view.requirePrintOnInitialModule    =   requirePrintOnInitialModule
            view.hiddenBackButton               =   hiddenBackButton
            
            presenter._view         =   view
            presenter.interactor    =   interactor
            presenter.router        =   router
            
            router.navigation       =   navigation
            interactor._presenter   =   presenter
            
            return view
        }
        return UIViewController()
    }
}
