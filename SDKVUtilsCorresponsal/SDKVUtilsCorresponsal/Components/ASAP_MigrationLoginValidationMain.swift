//
//  ASAP_MigrationLoginValidationMain.swift
//  GSSAAceptaPago
//
//  Created by phinder on 02/11/22.
//

import Foundation
import UIKit

open class ASAP_MigrationLoginValidationMain{
    public static func createModule(navigation: UINavigationController) -> UIViewController {
        let viewController: ASAP_MigrationLoginValidationView? = ASAP_MigrationLoginValidationView()
        if let view = viewController {
            let presenter = ASAP_MigrationLoginValidationPresenter()
            let router = ASAP_MigrationLoginValidationRouter()
            let interactor = ASAP_MigrationLoginValidationInteractor()
            
            view.presenter = presenter
            
            presenter.view = view
            presenter.interactor = interactor
            presenter.router = router
            
            router.navigation = navigation
            
            interactor.presenter = presenter
            return view
        }
        return UIViewController()
    }
}
