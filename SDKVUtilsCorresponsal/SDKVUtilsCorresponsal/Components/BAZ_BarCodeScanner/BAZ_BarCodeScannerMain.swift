//
//  BAZ_BarCodeScannerMain.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 17/06/21.
//

import UIKit

open class BAZ_BarCodeScannerMain: NSObject {

    public static func createModule(navigation: UINavigationController? = nil, delegate: BAZ_BarCodeScannerViewDelegate, fromWhere: BAZ_ScannBarCodeFromWhere = .PayCredit) -> UIViewController{
        
        let viewController  :   BAZ_BarCodeScannerView?   =  BAZ_BarCodeScannerView()
        if let view = viewController {
            view.delegate = delegate
            view.fromWhere = fromWhere
            
            return view
        }
        return UIViewController()
    }
}
