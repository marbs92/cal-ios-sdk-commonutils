//
//  BAZ_NIPAuthenticationView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 05/10/22.
//

import Foundation
import UIKit


public protocol BAZ_NIPAuthenticationDelegate {
    func nipAuthentication(_ state: Bool)
}


internal class BAZ_NIPAuthenticationView: UIViewController {
    private var ui: BAZ_NIPAuthenticationViewUI?
    internal var delegate: BAZ_NIPAuthenticationDelegate?
    
    
    override func loadView() {
        self.ui = BAZ_NIPAuthenticationViewUI(delegate: self)
        self.view = self.ui
    }
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            UILoader.show(parent: self.view)
        }
    }
    
    func dismissLoading() {
        DispatchQueue.main.async {
            UILoader.remove(parent: self.view)
        }
    }
    
    private func closeModule(_ authenticated: Bool) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
        
        self.delegate?.nipAuthentication(authenticated)
    }
}


extension BAZ_NIPAuthenticationView: BAZ_NIPAuthenticationViewUIDelegate {
    func notifyExit() {
        self.closeModule(false)
    }
    
    func notifyValidateNIP(nip: String) {
        self.showLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismissLoading()
            
            guard let currentNIP = KeychainManager.shared.getValue(forKey: FlagsAk.validatedNIP.rawValue),
                  currentNIP == nip else {
                self.ui?.notifyWrongCredential()
                return
            }

            self.closeModule(true)
        }
    }
    
    func notifyForgotNIP() {
        let viewController = BAZ_AuthenticateNIPCreationMain.createModule()
        
        if let nav = self.navigationController {
            nav.pushViewController(viewController, animated: true)
        } else {
            self.present(viewController, animated: true)
        }
    }
}
