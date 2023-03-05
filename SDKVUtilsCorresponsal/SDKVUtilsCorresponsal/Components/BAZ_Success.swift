//
//  BAZ_Success.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 23/09/22.
//

import UIKit
import Lottie

public protocol BAZ_SuccessDelegate: AnyObject{
    func onDismissSuccess()
}

open class BAZ_Success : UIViewController{
    public weak var delegate: BAZ_SuccessDelegate?
    
    private lazy var lottiImageView: AnimationView = {
        let animation = Animation.named("checkbaz",
                                        bundle: Bundle.local_ak_utils,
                                        subdirectory: nil,
                                        animationCache: nil)
        
        let lottie = AnimationView(animation: animation)
        lottie.contentMode = .scaleAspectFit
        lottie.backgroundBehavior = .pauseAndRestore
        lottie.loopMode = .playOnce
        lottie.translatesAutoresizingMaskIntoConstraints = false
        return lottie
    }()
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupUIElements()
        setupConstraints()
    }
    
    
    fileprivate func setupUIElements() {
        view.alpha = 0
        view.addSubview(lottiImageView)
        
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            lottiImageView.topAnchor.constraint(equalTo: view.topAnchor),
            lottiImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lottiImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lottiImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    public func onDisplay(){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .curveEaseOut]) {
            self.view.alpha = 1
            self.view.layoutIfNeeded()
        } completion: { comp in
            self.lottiImageView.play { comp in
                self.onDissmiss()
            }
        }
    }
    
    public func onDissmiss(){
        self.delegate?.onDismissSuccess()
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .curveEaseOut]) {
            self.view.alpha = 0.5
            self.view.layoutIfNeeded()
        } completion: { comp in
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .curveEaseOut]) {
                self.view.alpha = 0
                self.view.layoutIfNeeded()
            } completion: { comp in
                self.dismiss(animated: false, completion: nil)
            }
        }
        
    }
}
