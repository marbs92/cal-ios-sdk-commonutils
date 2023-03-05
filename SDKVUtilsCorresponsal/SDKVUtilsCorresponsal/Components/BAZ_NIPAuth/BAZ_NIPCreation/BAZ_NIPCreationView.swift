//
//  BAZ_NIPCreationView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 05/10/22.
//

import Foundation
import UIKit


public protocol BAZ_NIPCreationDelegate {
    func notifyCompleted()
}


internal class BAZ_NIPCreationView: UIViewController {
    private var ui: BAZ_NIPCreationViewUI?
    internal var isExitEnabled: Bool = true
    internal var delegate: BAZ_NIPCreationDelegate?
    
    override func loadView() {
        self.ui = BAZ_NIPCreationViewUI(delegate: self,
                                        isExitEnabled: self.isExitEnabled)
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


extension BAZ_NIPCreationView: BAZ_NIPCreationViewUIDelegate {
    func notifyExit() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    func notifyCreateNIP(nip: String) {
        self.showLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismissLoading()
            KeychainManager.shared.storeValue(value: nip, forKey: FlagsAk.validatedNIP.rawValue)
            
            self.notifyExit()
            
            self.delegate?.notifyCompleted()
        }
    }
}
