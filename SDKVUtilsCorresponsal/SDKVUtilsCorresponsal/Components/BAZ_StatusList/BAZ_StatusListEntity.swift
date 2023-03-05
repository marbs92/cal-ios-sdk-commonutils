//
//  BAZ_StatusListEntity.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 11/04/22.
//

import UIKit
open class BAZ_StatusListSection {
    internal var dotDiameter: CGFloat = 15
    internal var dotColor: UIColor = BAZ_ColorManager.purpleToolBarRW
    internal var title: String = ""
    internal var content: String = ""
    internal var titleColor: UIColor = BAZ_ColorManager.statusListTitleColor
    internal var titleFont: UIFont = .Poppins_Medium_16
    internal var contentColor: UIColor = BAZ_ColorManager.navyBlueDarkRW
    internal var contentFont: UIFont = .Poppins_Regular_16
    
    internal var subItems: [BAZ_StatusListSubItem]?
    
    public init (itemDotDiameter: CGFloat = 15,
                 title: String,
                 content: String,
                 dotColor: UIColor,
                 titleColor: UIColor = BAZ_ColorManager.statusListTitleColor,
                 titleFont: UIFont = .Poppins_Medium_16,
                 contentColor: UIColor = BAZ_ColorManager.navyBlueDarkRW,
                 contentFont: UIFont = .Poppins_Regular_16,
                 subItems: [BAZ_StatusListSubItem]? = nil) {
        self.dotDiameter = itemDotDiameter
        self.title = title
        self.content = content
        self.dotColor = dotColor
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.contentColor = contentColor
        self.contentFont = contentFont
        
        self.subItems = subItems
    }
}


public struct BAZ_StatusListSubItem {
    internal var subItemDotDiameter: CGFloat = 10
    internal var subItemColor: UIColor? = nil
    internal var content: String = ""
    internal var contentColor: UIColor = BAZ_ColorManager.navyBlueDarkRW
    internal var contentFont: UIFont = .Poppins_Regular_16
    
    public  init(subItemColor: UIColor? = nil,
                 subItemDotDiameter: CGFloat = 10,
                 content: String,
                 contentColor: UIColor = BAZ_ColorManager.navyBlueDarkRW,
                 contentFont: UIFont = .Poppins_Regular_16) {
        self.subItemColor = subItemColor
        self.subItemDotDiameter = subItemDotDiameter
        self.content = content
        self.contentColor = contentColor
        self.contentFont = contentFont
    }
}
