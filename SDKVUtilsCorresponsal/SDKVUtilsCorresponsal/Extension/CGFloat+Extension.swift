//
//  CGFloat+Extension.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Fernando Sánchez Palma on 10/06/22.
//

import Foundation
import UIKit

internal extension CGFloat {
    func clamp(lowerLimit: CGFloat, upperLimit: CGFloat) -> CGFloat {
        
        return lowerLimit > self ? lowerLimit : upperLimit < self ? upperLimit : self
    }
}
