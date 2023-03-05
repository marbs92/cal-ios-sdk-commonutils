//
//  Double+Extension.swift
//  cal-ios-sdk-commonutils
//
//  Created by Branchbit on 01/11/21.
//

import Foundation
extension Double {
    public func formatAsMoney() -> String{
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: self as NSNumber) {
            return formattedTipAmount
        }
        else {
            return "\(self)"
        }
    }
}
