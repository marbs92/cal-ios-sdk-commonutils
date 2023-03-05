//
//  BAZ_NIPCreationMain.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 05/10/22.
//

import Foundation
import UIKit


public class BAZ_NIPCreationMain{
    public static func createModule(delegate: BAZ_NIPCreationDelegate? = nil, isExitEnabled: Bool) -> UIViewController {
        let viewController: BAZ_NIPCreationView? = BAZ_NIPCreationView()
        if let view = viewController {
            view.isExitEnabled = isExitEnabled
            view.delegate = delegate
            view.modalPresentationStyle = .overFullScreen
        
            return view
        }
        return UIViewController()
    }
}
