//
//  BAZ_ProofAdressPreviewMain.swift
//  SDKVOnbordingBAZ
//
//  Created by Phinder on 29/12/22.
//

import UIKit

open class BAZ_ProofAdressPreviewMain{

    public static func createModule(proofAdressImage: UIImage?,
                                    navigation: UINavigationController?,
                                    delegate: BAZ_ProofAdressPreviewDelegate?) -> UIViewController {
        
        let viewController: BAZ_ProofAdressPreviewView? = BAZ_ProofAdressPreviewView()
        if let view = viewController {
            view.proofAdressImage = proofAdressImage
            view.delegate = delegate
            
            return view
        }
        return UIViewController()
    }
}
