//
//  BAZ_NIPAuthenticationMain.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 05/10/22.
//

import Foundation
import UIKit


public class BAZ_NIPAuthenticationMain{
    public static func createModule(delegate: BAZ_NIPAuthenticationDelegate) -> UIViewController {
        let viewController: BAZ_NIPAuthenticationView? = BAZ_NIPAuthenticationView()
        if let view = viewController {
            view.delegate = delegate
            view.modalPresentationStyle = .overFullScreen
            
            return view
        }
        return UIViewController()
    }
}
