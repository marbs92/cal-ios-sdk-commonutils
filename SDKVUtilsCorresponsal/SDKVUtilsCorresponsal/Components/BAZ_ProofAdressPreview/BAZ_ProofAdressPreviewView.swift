//
//  OBD_ProofAdressObdPreviewView.swift
//  SDKVOnbordingBAZ
//
//  Created by Phinder on 29/12/22.
//

import UIKit

public protocol BAZ_ProofAdressPreviewDelegate: AnyObject {
    func notifyContinueFlow()
}

class BAZ_ProofAdressPreviewView: UIViewController {
    public var proofAdressImage: UIImage?
    public weak var delegate: BAZ_ProofAdressPreviewDelegate?
    
    private var ui: BAZ_ProofAdressPreviewViewUI?
    
    override func loadView() {
        self.ui = BAZ_ProofAdressPreviewViewUI(navigation: self.navigationController,
                                                   delegate: self)
        self.view = self.ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ui?.proofOfAddressPreview.image = self.proofAdressImage
    }
}

extension BAZ_ProofAdressPreviewView:  BAZ_ProofAdressPreviewViewUIDelegate {    
    func notifyContinue() {
        delegate?.notifyContinueFlow()
    }
    
    func notifyTakePhoto() {
        self.dismiss(animated: true)
    }
}
