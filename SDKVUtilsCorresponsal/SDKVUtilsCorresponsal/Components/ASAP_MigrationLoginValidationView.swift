//
//  ASAP_MigrationLoginValidationView.swift
//  GSSAAceptaPago
//
//  Created by phinder on 02/11/22.
//

import Foundation
import UIKit

class ASAP_MigrationLoginValidationView: UIViewController {
    var presenter: ASAP_MigrationLoginValidationPresenterProtocol?
    private var ui: ASAP_MigrationLoginValidationViewUI?
    
    override func loadView() {
        ui = ASAP_MigrationLoginValidationViewUI(
            navigation: self.navigationController!,
            delegate: self
        )
        view = ui
    }
}

extension ASAP_MigrationLoginValidationView: ASAP_MigrationLoginValidationViewProtocol {
    
}

extension ASAP_MigrationLoginValidationView: ASAP_MigrationLoginValidationViewUIDelegate {
    
}
