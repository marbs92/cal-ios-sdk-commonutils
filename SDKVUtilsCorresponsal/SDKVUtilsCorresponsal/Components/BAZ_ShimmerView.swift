//
//  ShimmerView.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 30/03/21.
//

import UIKit

open class BAZ_ShimmerView: UIView {
    
    let kWidth = UIScreen.main.bounds.width
    let kHeight = UIScreen.main.bounds.height
    
    var gradientColorOne : CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
    var gradientColorTwo : CGColor = UIColor(white: 0.95, alpha: 1.0).cgColor
    
    func addGradientLayer() -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        self.layer.addSublayer(gradientLayer)
        
        return gradientLayer
    }
    
    func addAnimation() -> CABasicAnimation {
       
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 0.9
        return animation
    }
    
    public func startAnimating() {
        
        layer.masksToBounds = true
        
        // Front View
        let shimmerView = UIView(frame: CGRect(x: 0, y: -50, width: kHeight*2, height: kHeight*2))
        shimmerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        shimmerView.clipsToBounds = true
        shimmerView.tag = 1001
        addSubview(shimmerView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.gray.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.1]
        gradientLayer.startPoint = CGPoint(x: 0.7, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
        
        // Frame of the layer
        gradientLayer.frame = shimmerView.frame
        shimmerView.layer.mask = gradientLayer
        
        // Animation
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 1.0
        animation.fromValue = -(shimmerView.frame.width)
        animation.toValue = shimmerView.frame.width
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        gradientLayer.add(animation, forKey: "")
       
    }

}
