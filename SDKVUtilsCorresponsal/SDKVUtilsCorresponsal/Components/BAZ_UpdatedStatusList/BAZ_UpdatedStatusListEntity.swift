//
//  BAZ_UpdatedStatusListEntity.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 09/05/22.
//

import Foundation
import UIKit

public enum BAZ_UpdatedStatusListSectionStatus {
    case Success
    case Failure
    case Current
    case Pending
    
    func getOutterColor() -> UIColor {
        switch self {
        case .Success:
            return BAZ_ColorManager.statusListGreen.withAlphaComponent(0.4)
        case .Failure:
            return BAZ_ColorManager.redError.withAlphaComponent(0.4)
        case .Pending:
            return BAZ_ColorManager.statusListGray
        case .Current:
            return BAZ_ColorManager.statusListConditioned.withAlphaComponent(0.4)
        }
    }
    
    func getCenterColor() -> UIColor {
        switch self {
        case .Success:
            return BAZ_ColorManager.statusListGreen
        case .Failure:
            return BAZ_ColorManager.redError
        case .Pending:
            return .white
        case .Current:
            return BAZ_ColorManager.statusListConditioned
        }
    }
}


public struct BAZ_UpdatedStatusListSection {
    internal var dotDiameter: CGFloat
    internal var sectionStatus: BAZ_UpdatedStatusListSectionStatus
    internal var title: String
    internal var content: String
    internal var attributedContent: NSMutableAttributedString?
    internal var titleColor: UIColor
    internal var titleFont: UIFont
    internal var contentColor: UIColor
    internal var contentFont: UIFont
    internal var animateCircle: Bool
    
    public init (itemDotDiameter: CGFloat = 25,
                 title: String,
                 content: String = "",
                 attributedContent: NSMutableAttributedString? = nil,
                 sectionStatus: BAZ_UpdatedStatusListSectionStatus,
                 titleColor: UIColor = BAZ_ColorManager.onboardingDark,
                 titleFont: UIFont = .Poppins_Semibold_16,
                 contentColor: UIColor = BAZ_ColorManager.statusListGray,
                 contentFont: UIFont = .Poppins_Regular_14,
                 animateCircle: Bool = false) {
        self.dotDiameter = itemDotDiameter
        self.title = title
        self.content = content
        self.attributedContent = attributedContent
        self.sectionStatus = sectionStatus
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.contentColor = contentColor
        self.contentFont = contentFont
        self.animateCircle = animateCircle
    }
}
