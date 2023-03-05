//
//  ComponentMainButton.swift
//  PrestaprendaNIP
//
//  Created by Branchbit on 14/07/21.
//

import Foundation
import UIKit

public enum ContentAlignment{
    case Left
    case Center
    //case Right
}

open class BAZ_UpdatedButtonView: BAZ_ButtonViewGradient{
    

    var defaultBackgroundColor: UIColor?
    var defaultSecondBackgroundColor: UIColor?
    var defaultTintColor: UIColor?
    var defaultShadowColor: UIColor?
    var defaultDisabledBackgroundColor: UIColor?
    var defaultDisabledTintColor: UIColor?
    var defaultDisabledShadowColor: UIColor?
    var arrowIcon: UIImage = UIImage()
    
    public var showIcon: Bool = true {
        didSet {
            self.setImage(self.showIcon ? self.arrowIcon : UIImage(), for: UIControl.State.normal)
        }
    }
    
    public var contentAlignment: ContentAlignment = .Left {
        didSet {
            contentHorizontalAlignment = (contentAlignment == .Left ? ContentHorizontalAlignment.left : ContentHorizontalAlignment.center)
        }
    }

    public convenience init(
        titleText: String,
        titleFont: UIFont = .Poppins_Semibold_16,
        textAlignment: ContentAlignment = ContentAlignment.Left,

        buttonBackgroundColor: UIColor = BAZ_ColorManager.greenDarkRW,
        buttonSecondBackgroundColor: UIColor = BAZ_ColorManager.greenHightDarkRW,
        buttonTintColor: UIColor = BAZ_ColorManager.whiteNavBarBackground,
        buttonCornerRadius: CGFloat = 25,
        
        buttonShadowColor: UIColor = BAZ_ColorManager.shadowButtonRW,
        buttonShadowOffset: CGSize = CGSize(width: 0, height: 3),
        buttonShadowOpacity: Float = 0,
        buttonShadowRadius: CGFloat = 8,
        
        buttonDisabledBackgroundColor: UIColor = BAZ_ColorManager.dissableButtonRW,
        buttonDisabledTintColor: UIColor = BAZ_ColorManager.navyBlueDarDissablekRW,
        buttonDisabledShadowColor: UIColor = UIColor.clear,
                              
        showIcon: Bool = true,
        icon: UIImage = UIImage(bazNamed: "arrowToRightIcon")!
        //iconAlignment: ContentHorizontalAlignment = ContentHorizontalAlignment.right,
    ) {
        self.init(type: UIButton.ButtonType.system)
        
        
        setTitle(titleText, for: UIControl.State.normal)
        titleLabel?.font = titleFont
        defaultSecondBackgroundColor = buttonSecondBackgroundColor
        defaultBackgroundColor = buttonBackgroundColor
        defaultTintColor = buttonTintColor
        defaultShadowColor = buttonShadowColor
        defaultDisabledBackgroundColor = buttonDisabledBackgroundColor
        defaultDisabledTintColor = buttonDisabledTintColor
        defaultDisabledShadowColor = buttonDisabledShadowColor
        
        self.arrowIcon = icon
        
        //backgroundColor = defaultBackgroundColor
        tintColor = defaultTintColor
        
        startColor = defaultSecondBackgroundColor!
        endColor = defaultBackgroundColor!
        startPoint = CGPoint(x: 0.0, y: 0.5)
        endPoint = CGPoint(x: 1.0, y: 0.5)
        
        layer.shadowColor = defaultShadowColor!.cgColor
        layer.shadowOffset = buttonShadowOffset
        layer.shadowRadius = buttonShadowRadius
        layer.shadowOpacity = buttonShadowOpacity
        
        layer.cornerRadius = buttonCornerRadius
        
        switch textAlignment {
        case ContentAlignment.Left:
            contentHorizontalAlignment = ContentHorizontalAlignment.left
            //titleLeftPadding = buttonWidth * (30/315)
            //iconLeftPadding = buttonWidth * (278/315)
            if showIcon {
                setImage(icon, for: UIControl.State.normal)
                titleEdgeInsets = UIEdgeInsets(top: 0, left:  10, bottom: 0, right: 0)
                imageView?.translatesAutoresizingMaskIntoConstraints = false
                imageView?.contentMode = .scaleAspectFit

                NSLayoutConstraint.activate([
                    imageView!.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
                    imageView!.centerYAnchor.constraint(equalTo: centerYAnchor),
                    imageView!.widthAnchor.constraint(equalToConstant: 16)
                ])
            }else{
                titleEdgeInsets = UIEdgeInsets(top: 0, left:  10, bottom: 0, right: 0)
            }
        case ContentAlignment.Center:
            contentHorizontalAlignment = ContentHorizontalAlignment.center
            
            if showIcon {
                setImage(icon, for: UIControl.State.normal)
                semanticContentAttribute = .forceRightToLeft
                contentHorizontalAlignment = .center
                titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 25)
//                titleLabel?.translatesAutoresizingMaskIntoConstraints = false
//                imageView?.translatesAutoresizingMaskIntoConstraints = false
//
//                NSLayoutConstraint.activate([
//                    imageView!.leftAnchor.constraint(equalTo:  titleLabel!.rightAnchor, constant: 20),
//                    imageView!.centerYAnchor.constraint(equalTo: centerYAnchor),
//                ])
//                NSLayoutConstraint.activate([
//                    titleLabel!.centerXAnchor.constraint(equalTo: centerXAnchor),
//                    imageView!.leftAnchor.constraint(equalTo: titleLabel!.rightAnchor, constant:0)
//                ])
            }else{
                titleEdgeInsets = UIEdgeInsets(top: 0, left:  10, bottom: 0, right: 10)
            }
        }
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
   
    
    public func setEnableButton(enable: Bool){
        if enable {
            startColor = defaultSecondBackgroundColor!
            endColor = defaultBackgroundColor!
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint = CGPoint(x: 1.0, y: 0.5)
            tintColor = self.defaultTintColor
            setTitleColor(defaultTintColor, for: .normal)
            layer.shadowColor = self.defaultShadowColor!.cgColor
        }else{
            startColor = defaultDisabledBackgroundColor!
            endColor = defaultDisabledBackgroundColor!
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint = CGPoint(x: 1.0, y: 0.5)
            tintColor = self.defaultDisabledTintColor
            setTitleColor(defaultDisabledTintColor, for: .normal)
            layer.shadowColor = self.defaultDisabledShadowColor!.cgColor
        }
        self.isUserInteractionEnabled = enable
    }

}
