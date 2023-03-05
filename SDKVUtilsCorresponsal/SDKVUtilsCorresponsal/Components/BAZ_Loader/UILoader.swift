//
//  UILoader.swift
//  AceptaPagoBaz
//
//  Created by David on 29/04/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import UIKit
import Lottie

open class UILoader {
    
    private static let tagView = -123456789
    
    public static func show(parent: UIView) {
        parent.endEditing(true)
        if parent.viewWithTag(tagView) != nil {
            return
        }
        parent.isUserInteractionEnabled = false
        let mainView = UIView(frame: (parent.frame))
//        mainView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainView.tag = tagView
        
        let lottie = AnimationView(animation: Animation.named("loader", bundle: Bundle.local_ak_utils, subdirectory: nil, animationCache: nil))
        lottie.frame = UIScreen.main.bounds//CGRect(x: 0, y: 0, width: UIS, height: 50)
        lottie.contentMode = .scaleAspectFill
        lottie.backgroundBehavior = .pauseAndRestore
        lottie.loopMode = LottieLoopMode.loop
        lottie.play()
        
        mainView.addSubview(lottie)
        parent.addSubview(mainView)
    }
    
    public static func remove(parent: UIView) {
        parent.endEditing(true)
        parent.isUserInteractionEnabled = true
        if let loaderView = parent.viewWithTag(tagView) {
            loaderView.removeFromSuperview()
        }
    }
}
