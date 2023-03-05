//
//  Checkbox.swift
//  AceptaPagoBaz
//
//  Created by Branchbit on 12/08/21.
//  Copyright © 2021 Zeus. All rights reserved.
//

import UIKit

public protocol BAZ_CheckboxDelegate:class {
    func notifyCheckWasUpdated(currentState: Bool)
}

open class BAZ_Checkbox: UIButton{
    public weak var delegate : BAZ_CheckboxDelegate?
    public var isChecked: Bool = false
    private var checkedIcon: UIImage?
    private var uncheckedBackgroundColor: UIColor?
    private var checkedBackgroundColor: UIColor?
    private var uncheckedBorderColor: UIColor?
    private var checkedBorderColor: UIColor?
    
    public convenience init(uncheckedBackgroundColor: UIColor = BAZ_ColorManager.whiteNavBarBackground,
                            checkedBackgroundColor: UIColor = BAZ_ColorManager.greenDarkRW,
                            uncheckedBorderColor: UIColor = BAZ_ColorManager.borderColorRW,
                            checkedBorderColor: UIColor = BAZ_ColorManager.greenDarkRW,
                            cornerRadius: Float = 5,
                            borderWidth: Float = 1,
                            imageColor: UIColor = BAZ_ColorManager.whiteNavBarBackground,
                            imageInsets: Float = 4,
                            checkedIcon: UIImage = UIImage(bazNamed: "checkIcon") ?? UIImage()) {
        
        self.init()
        
        self.uncheckedBackgroundColor = uncheckedBackgroundColor
        self.checkedBackgroundColor = checkedBackgroundColor
        self.uncheckedBorderColor = uncheckedBorderColor
        self.checkedBorderColor = checkedBorderColor
        layer.borderWidth = CGFloat(borderWidth)
        layer.borderColor = uncheckedBorderColor.cgColor
        backgroundColor = uncheckedBackgroundColor
        layer.cornerRadius = CGFloat(cornerRadius)
        contentMode = .center
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
        self.checkedIcon = checkedIcon
        imageView?.contentMode = .scaleAspectFit
        tintColor = imageColor
        contentMode = .scaleAspectFill
        imageEdgeInsets = UIEdgeInsets(top: CGFloat(imageInsets), left: CGFloat(imageInsets), bottom: CGFloat(imageInsets), right: CGFloat(imageInsets))
        self.addTarget(self, action: #selector(self.check(_:)), for: UIControl.Event.touchUpInside)
    }//225,229,239
    
    public func toggleCheck(stated: Bool){
        isChecked = stated
        if isChecked {
            backgroundColor = checkedBackgroundColor
            layer.borderColor = checkedBorderColor?.cgColor
            setImage(checkedIcon, for: UIControl.State.normal)
        }else{
            backgroundColor = uncheckedBackgroundColor
            layer.borderColor = uncheckedBorderColor?.cgColor
            setImage(UIImage(), for: UIControl.State.normal)
        }
    }
    
    @objc func check(_ sender: UIButton){
        isChecked = !isChecked
        if isChecked {
            backgroundColor = checkedBackgroundColor
            layer.borderColor = checkedBorderColor?.cgColor
            setImage(checkedIcon, for: UIControl.State.normal)
        }else{
            backgroundColor = uncheckedBackgroundColor
            layer.borderColor = uncheckedBorderColor?.cgColor
            setImage(UIImage(), for: UIControl.State.normal)
        }
        delegate?.notifyCheckWasUpdated(currentState: isChecked)
    }
    
    public func checked() -> Bool{
        return isChecked
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
