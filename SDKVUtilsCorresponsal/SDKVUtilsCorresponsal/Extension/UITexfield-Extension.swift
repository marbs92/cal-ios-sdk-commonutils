//
//  UITexfield-Extension.swift
//  eh-components
//
//  Created by Jorge Cruz on 11/03/21.
//

import UIKit

private var keyMaxLength    :   Int =   0

extension  UITextField {
    
    @IBInspectable var maxSize: Int {
        get {
            if let length = objc_getAssociatedObject(self, &keyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &keyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength(textField:)), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
              prospectiveText.count > maxSize
        else {
            return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxSize)
        text = String(prospectiveText[ ..<maxCharIndex])
        selectedTextRange = selection
    }
    
    public func asPhoneNumber(){
        if let text = self.text {
            let letters = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            var result = ""
            var index = letters.startIndex
            for ch in "(###) ### ####" where index < letters.endIndex {
                if ch == "#" {
                    result.append(letters[index])
                    index = letters.index(after: index)
                } else {
                    result.append(ch)
                }
            }
            self.text = result
        }
    }
}
