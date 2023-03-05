//
//  UIFormatter.swift
//  SDKVUtilsCorresponsal
//
//  Created by Armando Carrillo - EKT on 29/11/21.
//

import Foundation
import UIKit
public class UIFormatterMoney{
    
    public enum fromlocation {
        case balance
        case cobro
        case terminal
        case addAmountIntegrer
    }

    public static func constructAttributedTotal(total: Double,
                                                color: UIColor,
                                                integerSize: CGFloat = 39,
                                                floatSize: CGFloat = 23,
                                                alignment: NSTextAlignment = .center,
                                                view : fromlocation = .balance,
                                                isNegativeValue: Bool = false) -> NSMutableAttributedString {
        
        var valueToCents = CGFloat()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        switch view {
        case .balance:
            if UIScreen.main.bounds.height < 800 {
                valueToCents = (20/1000)
            } else {
                valueToCents = (20/1700)
            }
            break
        case .cobro:
            valueToCents = (20/600)
            break
        case .terminal:
            if UIScreen.main.bounds.height < 800 {
                valueToCents = (20/800)
            } else {
                valueToCents = (20/1000)
            }
            break
        case .addAmountIntegrer:
            valueToCents = (20/1700)
            break
        }
        
        let integerStyle = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: integerSize),
            NSAttributedString.Key.foregroundColor: color
        ]
        let floatStyle = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: floatSize),
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.baselineOffset: valueToCents*UIScreen.main.bounds.height] as [NSAttributedString.Key : Any]
        
        var text = total.formatAsMoney()
        text = text.replacingOccurrences(of: "$", with: "")
        
        let attributedString = NSMutableAttributedString()
        
        if isNegativeValue{
            attributedString.append(NSMutableAttributedString(string: "-", attributes: integerStyle as [NSAttributedString.Key: Any]))
        }
        
        attributedString.append(NSMutableAttributedString(string: "$", attributes: floatStyle as [NSAttributedString.Key: Any]))
        
        attributedString.append(NSMutableAttributedString(string: "\(text.prefix(through: text.firstIndex(of: ".")!))", attributes: integerStyle as [NSAttributedString.Key: Any]))
        if let afterPoint = text.range(of: ".")?.lowerBound{
            let cent = String(text.suffix(from: afterPoint).replacingOccurrences(of: ".", with: ""))
            
            attributedString.append(NSMutableAttributedString(string: cent, attributes: floatStyle as [NSAttributedString.Key: Any]))
        }
        
        
        return attributedString
    }

    
    public static func constructAttributedTotalInterger(total: Double, color: UIColor, integerSize: CGFloat = 34, floatSize: CGFloat = 18, alignment: NSTextAlignment = .center, isNegativeValue: Bool = false) -> NSMutableAttributedString {
        
        return constructAttributedTotal(total: total, color: color, integerSize: integerSize, floatSize: floatSize, alignment: alignment, view: .addAmountIntegrer, isNegativeValue: isNegativeValue)
        
    }
}
