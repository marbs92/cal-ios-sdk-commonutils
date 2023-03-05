//
//  CBR_AceptaPagoPurpleContainerView.swift
//  aceptapago-ios-sdk-cobros
//
//  Created by Branchbit on 03/12/21.
//

import Foundation
import UIKit
open class BAZ_PurpleContainerView: UIView {
    var withPath = true
    
    public convenience init(withPath:Bool){
        self.init()
        self.withPath = withPath
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let width: CGFloat = self.frame.size.width
        let height: CGFloat = self.frame.size.height
        
        // Initialize the path.
        if withPath{
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addCurve(to: CGPoint(x: width, y: height - 128), controlPoint1: CGPoint(x: 0, y: height - 128), controlPoint2: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: width, y: 0))
            path.close()
            
            let globeLayer = CAShapeLayer()
            globeLayer.path = path.cgPath
            
            self.layer.mask = globeLayer
        }
        let gradient = CAGradientLayer()

        gradient.frame = self.frame
        gradient.colors = [
            UIColor(red: 158/255, green: 114/255, blue: 246/255, alpha: 1).cgColor,
            UIColor(red:  123/255, green: 63/255, blue: 245/255, alpha: 1).cgColor,
        ]
        layer.insertSublayer(gradient, at: 0)
    }
}
