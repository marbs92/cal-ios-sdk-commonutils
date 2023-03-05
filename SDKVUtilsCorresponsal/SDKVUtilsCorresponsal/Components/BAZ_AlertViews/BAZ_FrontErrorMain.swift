//
//  BAZ_FrontErrorMain.swift
//  SDKVUtilsCorresponsal
//
//  Created by Phinder 2022 on 20/07/22.
//

import UIKit

open class BAZ_FrontErrorViewMain{

    
    public static func createModule(delegate: BAZ_FrontErrorViewDelegate?, message: String?) -> UIViewController{

        let viewController : BAZ_FrontErrorView? = BAZ_FrontErrorView()
        
        if let view = viewController{
            view.delegate = delegate
            view.message = message
            
            return view
        }
        
        return UIViewController()
    }
    
    
}

