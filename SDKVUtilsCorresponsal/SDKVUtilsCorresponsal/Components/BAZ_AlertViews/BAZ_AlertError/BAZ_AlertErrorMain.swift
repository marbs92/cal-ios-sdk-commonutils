//
//  BAZ_AlertErrorMain.swift
//  SDKVUtilsCorresponsal
//
//  Created by Phinder on 29/04/22.
//


import UIKit

open class BAZ_AlertErrorMain {
    public static func createModule(title: String?, delegate: BAZ_AlertErrorViewDelegate?) -> BAZ_AlertErrorView {
        let viewController = BAZ_AlertErrorView()
        
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = delegate
        viewController.alertTitle = title
        
        return viewController
    }
}

