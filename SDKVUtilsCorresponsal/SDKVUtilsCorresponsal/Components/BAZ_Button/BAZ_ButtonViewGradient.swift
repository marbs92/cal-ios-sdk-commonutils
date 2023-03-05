//
//  BAZ_ButtonViewGradian.swift
//  cal-ios-sdk-commonutils
//
//  Created by Dsi Soporte Tecnico on 15/10/21.
//

import UIKit

@IBDesignable
open class BAZ_ButtonViewGradient: UIButton {
    public override class var layerClass: AnyClass         { CAGradientLayer.self }
    private var gradientLayer: CAGradientLayer             { layer as! CAGradientLayer }

    @IBInspectable public var startColor: UIColor = .white { didSet { updateColors() } }
    @IBInspectable public var endColor: UIColor = .red     { didSet { updateColors() } }

    // expose startPoint and endPoint to IB

    @IBInspectable public var startPoint: CGPoint {
        get { gradientLayer.startPoint }
        set { gradientLayer.startPoint = newValue }
    }

    @IBInspectable public var endPoint: CGPoint {
        get { gradientLayer.endPoint }
        set { gradientLayer.endPoint = newValue }
    }

    // while we're at it, let's expose a few more layer properties so we can easily adjust them in IB

    @IBInspectable public var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable public var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable public var borderColor: UIColor? {
        get { layer.borderColor.flatMap { UIColor(cgColor: $0) } }
        set { layer.borderColor = newValue?.cgColor }
    }

    // init methods

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateColors()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        updateColors()
    }
}

private extension BAZ_ButtonViewGradient {
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
