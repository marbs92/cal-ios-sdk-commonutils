//
//  BAZ_AuthenticateNIPCreationMain.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 05/10/22.
//

import Foundation
import UIKit


internal class BAZ_AuthenticateNIPCreationMain{
    internal static func createModule() -> UIViewController {
        let viewController: BAZ_AuthenticateNIPCreationView? = BAZ_AuthenticateNIPCreationView()
        if let view = viewController {
            view.modalPresentationStyle = .overFullScreen

            return view
        }
        return UIViewController()
    }
}
