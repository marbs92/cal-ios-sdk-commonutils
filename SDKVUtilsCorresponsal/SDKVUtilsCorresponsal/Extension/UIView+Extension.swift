//
//  UIView+Extension.swift
//  GenericPrinter
//
//  Created by Gustavo Tellez on 24/08/21.
//

import UIKit

public enum ViewBorder {
    case Top
    case Bottom
}

public enum LineOrientation {
    case Vertical
    case Horizontal
}


extension UIView {
    
    public func makeSecure() {
        DispatchQueue.main.async {
            let textField = UITextField()
            textField.isSecureTextEntry = true
            
            let auxView = textField.layer.sublayers?.first?.delegate as? UIView
            if let protectedView = auxView {
                protectedView.subviews.forEach { $0.removeFromSuperview() }
                protectedView.translatesAutoresizingMaskIntoConstraints = false
                protectedView.isUserInteractionEnabled = true
                
                let parentSubViews = self.subviews
                
                self.addSubview(protectedView)
                
                NSLayoutConstraint.activate([
                    protectedView.topAnchor.constraint(equalTo: self.topAnchor),
                    protectedView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    protectedView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                    protectedView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                ])
                
                for subView in parentSubViews {
                    protectedView.addSubview(subView)
                }
            }
        }
    }
    
    var snapshot: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let capturedImage = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return capturedImage
    }
    
    public func applyAceptaPagoOutlinedStyle(radius: CGFloat = 8, color: UIColor = BAZ_ColorManager.greenDarkRW) {
        layer.cornerRadius = radius
        layer.borderWidth = 2
        layer.borderColor = color.cgColor
    }
    
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()

        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func getCornersArray(data: UIRectCorner) -> CACornerMask{
        
        var corners : CACornerMask = []
        
        if data.contains(.topLeft){
            corners.insert(.layerMinXMinYCorner)
        }
        
        if data.contains(.topRight){
            corners.insert(.layerMaxXMinYCorner)
        }

        if data.contains(.bottomRight){
            corners.insert(.layerMaxXMaxYCorner)
        }

        if data.contains(.bottomLeft){
            corners.insert(.layerMinXMaxYCorner)
        }
        
        return corners
    }
    
    public func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
    }
    
    public func addBorder(whereToAdd viewBorder: ViewBorder = .Bottom, color: UIColor = BAZ_ColorManager.dissableButtonRW, borderSize: Float = 1.0) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            border.heightAnchor.constraint(equalToConstant: CGFloat(borderSize)),
        ])
        if viewBorder == .Top {
            NSLayoutConstraint.activate([
                border.topAnchor.constraint(equalTo: self.topAnchor)
            ])
        }else if viewBorder == .Bottom {
            NSLayoutConstraint.activate([
                border.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
    }
    
    
    public func dotted(color: UIColor, orientation: LineOrientation, diameter: CGFloat, separation: CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let caShapeLayer = CAShapeLayer()
            caShapeLayer.strokeColor = color.cgColor
            caShapeLayer.lineWidth = diameter
            
            caShapeLayer.lineDashPattern = [NSNumber(value: (diameter/5)), NSNumber(value: separation)]
            
            let cgPath = CGMutablePath()
            var cgPoint = [CGPoint()]
            
            switch orientation {
            case .Vertical:
                cgPoint = [CGPoint(x: self.bounds.midX, y: self.bounds.minY), CGPoint(x: self.bounds.midX, y: self.bounds.maxY)]
            case .Horizontal:
                cgPoint = [CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y), CGPoint(x: self.bounds.maxX, y: self.bounds.minY)]
            }
            
            cgPath.addLines(between: cgPoint)
            caShapeLayer.path = cgPath
            caShapeLayer.lineCap = .round
            
            self.layer.addSublayer(caShapeLayer)
        }
    }
    
    public func drawDottedLine(color: UIColor,
                               orientation: LineOrientation,
                               length: CGFloat = 7,
                               separation: CGFloat = 3) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.lineDashPattern = [NSNumber(value: length), NSNumber(value: separation)]

            let path = CGMutablePath()
            var cgPoint = [CGPoint()]

            switch orientation {
            case .Vertical:
                cgPoint = [CGPoint(x: self.bounds.midX, y: self.bounds.minY), CGPoint(x: self.bounds.midX, y: self.bounds.maxY)]
            case .Horizontal:
                cgPoint = [CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y), CGPoint(x: self.bounds.maxX, y: self.bounds.minY)]
            }

            path.addLines(between: cgPoint)
            shapeLayer.path = path
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    public func addShadowAndCornersCanonic(radius: CGFloat, shadowColor: UIColor, offSet: CGSize, opacity: Float){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.shadowRadius = radius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offSet
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
}
