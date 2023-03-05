//
//  BAZ_SupportMain.swift
//  aceptapago-ios-sdk-login
//
//  Created by Luis Fernando Sánchez Palma on 27/10/22.
//

import UIKit

open class BAZ_SupportMain {
    public static func createModule(navigation: UINavigationController?) -> UIViewController {
        let viewController: BAZ_SupportView? = BAZ_SupportView()
        if let view = viewController {
            return view
        }
        return UIViewController()
    }
}
