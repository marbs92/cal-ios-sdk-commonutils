//
//  BAZ_UILoaderESAN.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 08/08/22.
//

import UIKit

open class BAZ_UILoaderESAN{
    
    private static let tagView = -123456789
    
    public static func show(parent: UIView) {
        if parent.viewWithTag(tagView) != nil {
            return
        }
        parent.isUserInteractionEnabled = false
        let mainView = UIView(frame: (parent.frame))
        mainView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainView.tag = tagView
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = parent.center
        activityIndicator.startAnimating()
        mainView.addSubview(activityIndicator)
        parent.addSubview(mainView)
    }
    
    public static func remove(parent: UIView) {
        parent.isUserInteractionEnabled = true
        if let loaderView = parent.viewWithTag(tagView) {
            loaderView.removeFromSuperview()
        }
    }
    
}
