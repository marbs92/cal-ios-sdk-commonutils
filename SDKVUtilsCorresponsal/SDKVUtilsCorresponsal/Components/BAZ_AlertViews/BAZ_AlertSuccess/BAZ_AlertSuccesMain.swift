//
//  succesiView.swift
//  Registro
//
//  Created by Phinder 2022 on 19/07/22.
//

import UIKit

open class BAZ_AlertSuccessMain{
    public static func createModule(title: String?, delegate: BAZ_AlertSuccessViewDelegate?) -> BAZ_AlertSuccessView {
        let viewController = BAZ_AlertSuccessView()
        
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = delegate
        viewController.alertTitle = title
        
        return viewController
    }
}
