//
//  BAZ_CircleProgressView.swift
//  cal-ios-sdk-commonutils
//
//  Created by Dsi Soporte Tecnico on 21/09/21.
//

import UIKit

open class BAZ_CircleProgressView: UIView {
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func createCircularPath(endPointPercent: CGFloat) {
        let centPercent = (((endPoint - startPoint) / 100 ) * endPointPercent) + startPoint
        // created circularPath for circleLayer and progressLayer
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 17, y: 17), radius: 17, startAngle: startPoint, endAngle: centPercent, clockwise: true)
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 3.0
        circleLayer.strokeEnd = 0.0
        circleLayer.strokeColor = BAZ_ColorManager.whiteNavBarBackground.cgColor
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 3.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = BAZ_ColorManager.greenDarkRW.cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
    }
    
    public func progressAnimation(duration: TimeInterval) {
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
