//
//  APU_UIViewGradientExtension.swift
//  aceptapago-ios-sdk-utils
//
//  Created by Branchbit on 21/10/21.
//
import UIKit

public enum APU_GradientOrientation {
    case horizontal
    case vertical
}

public extension UIView {
    func applyGradient(startColor: UIColor = BAZ_ColorManager.greenDarkRW,
                              endColor: UIColor = BAZ_ColorManager.greenDarkRW,
                              cornerRadius: Float = 25.0,
                              orientation: APU_GradientOrientation = .horizontal){
        
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
                gradient.colors = [
                    startColor.cgColor,
                    endColor.cgColor,
                ]
        
        switch orientation {
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
        }
        
        gradient.cornerRadius = CGFloat(cornerRadius)
        
        self.layer.insertSublayer(gradient, at: 0)
        self.layer.masksToBounds = true
    }
    
    func removeGradient(){
        if let gradientLayers = (self.layer.sublayers?.compactMap { $0 as? CAGradientLayer}){
            for gradientLayer in gradientLayers {
                gradientLayer.removeFromSuperlayer()
            }
        }
    }
}
