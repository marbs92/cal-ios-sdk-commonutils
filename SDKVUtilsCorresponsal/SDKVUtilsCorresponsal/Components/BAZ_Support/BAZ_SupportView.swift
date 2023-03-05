//
//  BAZ_SupportView.swift
//  aceptapago-ios-sdk-login
//
//  Created by Luis Fernando Sánchez Palma on 27/10/22.
//

import UIKit

class BAZ_SupportView: UIViewController {
    
    private var ui: BAZ_SupportViewUI?
    
    override func loadView() {
        ui = BAZ_SupportViewUI(navigation: self.navigationController!)
        view = ui
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
