//
//  BAZ_CustomUpdateButtonView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Usuario Phinder 2022 on 24/05/22.
//

import Foundation
import UIKit
import SDKVUtilsCorresponsal

open class BAZ_CustomUpdateButtonView : BAZ_UpdatedButtonView{
    
    
    
    override public func setEnableButton(enable: Bool) {
        super.setEnableButton(enable: enable)
        self.layer.borderWidth = 1
        self.layer.borderColor = BAZ_ColorManager.noneSpaceRW.cgColor
        if !enable {
            self.layer.borderWidth = 1
            self.backgroundColor = self.defaultBackgroundColor
            self.layer.borderColor = BAZ_ColorManager.purpleToolBarRW.cgColor
            
            layer.shadowColor = UIColor.clear.cgColor
        
        }
        
    }
    
    
}
