//
//  BAZ_AlertWarningMain.swift
//  SDKVUtilsCorresponsal
//
//  Created by Phinder on 29/04/22.
//

import UIKit

open class BAZ_AlertWarningMain{
    public static func createModule(title: String?, delegate: BAZ_AlertWarningViewDelegate?) -> BAZ_AlertWarningView {
        let viewController = BAZ_AlertWarningView()
        
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = delegate
        viewController.alertTitle = title
        
        return viewController
    }
}
