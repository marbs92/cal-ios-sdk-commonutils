//
//  BAZ_ButtonView.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 23/04/21.
//

import UIKit

open class BAZ_ButtonView: BAZ_ButtonViewGradient {
 
    public convenience init(
        cornerRadius: Int = 25,
        background: UIColor,
        seconBackGroundToGradian: UIColor = BAZ_ColorManager.greenHightDarkRW,
        tintColor: UIColor,
        title: String,
        borderColor: UIColor = .clear,
        borderWidth: Int = 0,
        font: UIFont = .Poppins_Semibold_16
    ) {
        self.init()
        layer.borderWidth = CGFloat(borderWidth)
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.backgroundColor = background.cgColor
        setTitleColor(tintColor, for: .normal)
        startColor = seconBackGroundToGradian
        endColor = background
        startPoint = CGPoint(x: 0.0, y: 0.5)
        endPoint = CGPoint(x: 1.0, y: 0.5)
        self.tintColor = tintColor
        setTitle(title, for: .normal)
        titleLabel?.font = font
        translatesAutoresizingMaskIntoConstraints = false
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
