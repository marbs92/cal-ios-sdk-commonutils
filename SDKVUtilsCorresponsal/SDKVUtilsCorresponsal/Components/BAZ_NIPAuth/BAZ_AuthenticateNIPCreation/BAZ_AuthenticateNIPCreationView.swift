//
//  BAZ_AuthenticateNIPCreationView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 05/10/22.
//

import Foundation
import UIKit


internal class BAZ_AuthenticateNIPCreationView: UIViewController {
    private var ui: BAZ_AuthenticateNIPCreationViewUI?
    
    override func loadView() {
        self.ui = BAZ_AuthenticateNIPCreationViewUI(delegate: self)
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
}


extension BAZ_AuthenticateNIPCreationView: BAZ_AuthenticateNIPCreationViewUIDelegate {
    func notifyExit() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    func notifyValidateCredential(credential: String) {
        self.showLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismissLoading()
            
            guard let currentCredential = KeychainManager.shared.getValue(forKey: UserAkKeystore.validatedAuth.rawValue),
                  currentCredential == credential else {
                self.ui?.notifyWrongCredential()
                return
            }
            
            let viewController = BAZ_NIPCreationMain.createModule(delegate: self,
                                                                  isExitEnabled: true)

            if let nav = self.navigationController {
                nav.pushViewController(viewController, animated: true)
            } else {
                self.present(viewController, animated: true)
            }
            
            self.ui?.resetCredentialField()
        }
    }
}


extension BAZ_AuthenticateNIPCreationView: BAZ_NIPCreationDelegate {
    func notifyCompleted() {
        self.notifyExit()
    }
}
