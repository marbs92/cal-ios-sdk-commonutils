//
//  NSMutableString+Extension.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 09/04/21.
//

import UIKit

public extension UILabel {

    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}

public extension String{
    
    func formattedByTicket(characterToReplace: Character) -> String {
        let letters = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = letters.startIndex
        for ch in letters where index < letters.endIndex {
            if index > letters.prefix(letters.count - 5).endIndex{
                result.append(ch)
            }else{
                result.append(characterToReplace)
                index = letters.index(after: index)
            }
        }
        return result
    }
    
    func formattedByMask(maskToReplace: String, characterToReplace: Character) -> String {
        let letters = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = letters.startIndex
        for ch in maskToReplace where index < letters.endIndex {
            if ch == characterToReplace {
                result.append(letters[index])
                index = letters.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func priceUnDecorative() -> String{
        return self.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func priceDecorative() -> String{
        let amount = Double(self)
        let number = NSNumber(floatLiteral: amount ?? 0.0)
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: number)!
    }
    
    func underlineDecorative()->NSMutableAttributedString{
        let attibute = NSMutableParagraphStyle()
        attibute.alignment = .left
        attibute.lineBreakMode = .byWordWrapping
        
        let attributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: .darkGray as UIColor,
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font : .Poppins_Regular_16 as UIFont ,
                NSAttributedString.Key.paragraphStyle : attibute
        ]
        let stringAttribute = NSMutableAttributedString(string: self, attributes: attributes)
        return stringAttribute
    }
    
    
    func decorative(color: UIColor,
                    font: UIFont,
                    spacing: Double = 0,
                    lineBreakMode: NSLineBreakMode = .byWordWrapping)->NSMutableAttributedString{
       
        let attibute = NSMutableParagraphStyle()
        attibute.alignment = .left
        attibute.lineBreakMode = lineBreakMode
        let attributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font : font,
                NSAttributedString.Key.paragraphStyle : attibute
        ]
        let stringAttribute = NSMutableAttributedString(string: self, attributes: attributes)
        stringAttribute.addAttributes([.kern : spacing], range: NSRange(location: 0, length: stringAttribute.length - 1))
        return stringAttribute
    }
    
    func convertAmountToString() -> String{
        
        let cleanAmount = self.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "")
        let range = String(format: "%.2f", Double(cleanAmount) ?? 0.00).range(of: ".")
        let cent = String(format: "%.2f", Double(cleanAmount) ?? 0.00)[(range?.upperBound...)!]
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = Locale(identifier: "es_ES")
        let spanishAmount = formatter.string(from: Int(Double(cleanAmount) ?? 0.0) as NSNumber)?.uppercased()
        let spanishCents = formatter.string(from: Int(Double(cent) ?? 0.0) as NSNumber)?.uppercased()
        let fullAmount = "\(spanishAmount ?? "CERO") PESOS\(spanishCents == "CERO" ? "" : " CON \(spanishCents ?? " CERO") CENTAVOS")"
        
        return fullAmount
    }
    
    func maskName() -> String{
        var auxString = ""
        
        if self != ""{
            let nameArray = self.split(separator: " ")
            for word in nameArray{
                let firstCharacter = String(word[word.startIndex])
                auxString += "\(firstCharacter)*** "
            }
        }
        
        return auxString
    }
    
    func addSlashes() -> String{
        if self.trimmingCharacters(in: .whitespacesAndNewlines).count == 8{
            var aux = self
            let firstPosition = self.index(self.startIndex, offsetBy: 2)
            let secondPosition = self.index(self.startIndex, offsetBy: 5)
            aux.insert("/", at: firstPosition)
            aux.insert("/", at: secondPosition)
            
            return aux
        }else{
            return self
        }
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func subString(from: Int) -> String {
        if from < self.count && from >= 0 {
            let fromIndex = index(from: from)
            return String(self[fromIndex...])
        } else {
            return ""
        }
    }
    
    func subString(to: Int) -> String {
        if to < self.count && to >= 0 {
            let toIndex = index(from: to)
            return String(self[..<toIndex])
        }else {
            return ""
        }
    }
    func getCharacterAt(index: Int) -> String?{
        if index < self.count && index >= 0{
            let auxIndex = self.index(from: index)
            return String(self[auxIndex])
        }else {
            return nil
        }
    }
    
    func subString(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    func isEmail() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isSpecificEmail() -> Bool{
        let emailRegEx = "[A-Z0-9a-z.%+-]+@(hotmail|gmail|yahoo|outlook|icloud|live)\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func hasCapittalLetter() -> Bool{
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let capitalresult = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        return capitalresult.evaluate(with: self)
    }
    
    func isRFC()->Bool{
        let rfcRegEx =  "^([A-Z??&]{3,4}) ?(?:- ?)?(\\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\\d|3[01])) ?(?:- ?)?([A-Z\\d]{3})$"
        
        let rfcPred = NSPredicate(format:"SELF MATCHES %@", rfcRegEx)
        return rfcPred.evaluate(with: self)
    }
    
    func isCURP() -> Bool {
        let curpRegEx =  "^([A-Z][AEIOUX][A-Z]{2}\\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\\d|3[01])[HM](?:AS|B[CS]|C[CLMSH]|D[FG]|G[TR]|HG|JC|M[CNS]|N[ETL]|OC|PL|Q[TR]|S[PLR]|T[CSL]|VZ|YN|ZS)[B-DF-HJ-NP-TV-Z]{3}[A-Z\\d]{2})$"
        let curpPred = NSPredicate(format:"SELF MATCHES %@", curpRegEx)
        return curpPred.evaluate(with: self)
    }
    
    func hasNumber () -> Bool {
        let numberRegEx  = ".*[0-9]+.*"
        let numberResult = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return numberResult.evaluate(with: self)
    }
    
    func hasSpecialCharacter() -> Bool {
        let specialCharacterRegEx  = ".*[!.,¡!¿?@#$]+.*"
        let specialResult = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        return specialResult.evaluate(with: self)
    }
    
    func hasRepeatedCharacters() -> Bool {
        for n in 0..<self.count {
            if (self.subString(to: n).contains(self.getCharacterAt(index: n) ?? "")) {
                return true
            }
        }
        return false
    }
    
    func hasConsecutiveNumers(occurrenceTolerance: Int = 0) -> Bool? {
        var intArray: [Int] = []
        var positiveConsecutiveCounter = 0
        var negativeConsecutiveCounter = 0
        
        for character in self {
            if let currentIntChar = Int(String(character)) {
                intArray.append(currentIntChar)
            }else {
                // Returns nil if there are non integer parsable characters
                return nil
            }
        }
        
        for n in 0..<intArray.count {
            if n + 1 < intArray.count {
                if intArray[n] + 1 == intArray[n + 1] {
                    positiveConsecutiveCounter += 1
                    if positiveConsecutiveCounter > occurrenceTolerance {
                        return true
                    }
                }else {
                    positiveConsecutiveCounter = 0
                }
                
                if intArray[n] - 1 == intArray[n + 1] {
                    negativeConsecutiveCounter += 1
                    if negativeConsecutiveCounter > occurrenceTolerance {
                        return true
                    }
                }else {
                    negativeConsecutiveCounter = 0
                }
            }
        }
        return false
    }
    
    func hasRepeatedConsecutiveNumers(occurrenceTolerance: Int = 0) -> Bool? {
        var intArray: [Int] = []
        var positiveConsecutiveCounter = 0
        var negativeConsecutiveCounter = 0
        
        for character in self {
            if let currentIntChar = Int(String(character)) {
                intArray.append(currentIntChar)
            }else {
                return nil
            }
        }
        
        for n in 0..<intArray.count {
            if n + 1 < intArray.count {
                if intArray[n] == intArray[n + 1] {
                    positiveConsecutiveCounter += 1
                    if positiveConsecutiveCounter > occurrenceTolerance {
                        return true
                    }
                }else {
                    positiveConsecutiveCounter = 0
                }
                
                if intArray[n] == intArray[n + 1] {
                    negativeConsecutiveCounter += 1
                    if negativeConsecutiveCounter > occurrenceTolerance {
                        return true
                    }
                }else {
                    negativeConsecutiveCounter = 0
                }
            }
        }
        return false
    }
    
    func formatAsAttributedAmount(color: UIColor = BAZ_ColorManager.navyBlueDarkRW, asMoney: Bool = true, integerFont: UIFont = .Poppins_Medium_55, floatFont: UIFont = .Poppins_Medium_28, alignment: NSTextAlignment = .center) -> NSMutableAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        let integerStyle = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: integerFont,
            NSAttributedString.Key.foregroundColor: color
        ]
        let floatStyle = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: floatFont,
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.baselineOffset: (integerFont.pointSize - floatFont.pointSize)] as [NSAttributedString.Key : Any]
        
        var text = self.replacingOccurrences(of: "$", with: "")
        if asMoney {
            text = (Double(text) ?? 0.0).formatAsMoney()
            text = text.replacingOccurrences(of: "$", with: "")
            
            let attributedString = NSMutableAttributedString(string: "$", attributes: floatStyle as [NSAttributedString.Key: Any])
            attributedString.append(NSMutableAttributedString(string: "\(text.prefix(upTo: text.firstIndex(of: ".")!))", attributes: integerStyle as [NSAttributedString.Key: Any]))
            attributedString.append(NSMutableAttributedString(string: "\(text.suffix(from: text.firstIndex(of: ".")!))", attributes: floatStyle as [NSAttributedString.Key: Any]))
            return attributedString
        }else {
            if text.contains(".") {
                let attributedString = NSMutableAttributedString(string: "$", attributes: floatStyle as [NSAttributedString.Key: Any])
                attributedString.append(NSMutableAttributedString(string: "\(text.prefix(upTo: text.firstIndex(of: ".")!))", attributes: integerStyle as [NSAttributedString.Key: Any]))
                attributedString.append(NSMutableAttributedString(string: "\(text.suffix(from: text.firstIndex(of: ".")!))", attributes: floatStyle as [NSAttributedString.Key: Any]))
                return attributedString
            }else {
                let attributedString = NSMutableAttributedString(string: "$", attributes: floatStyle as [NSAttributedString.Key: Any])
                attributedString.append(NSMutableAttributedString(string: text, attributes: integerStyle as [NSAttributedString.Key: Any]))
                return attributedString
            }
        }
    }
    
    func asPhoneNumber() -> String {
        let letters = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
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
        return result
    }
    
    func asSecurityKeyPhoneNumber() -> String {
        let letters = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = letters.startIndex
        for ch in "## #### ####" where index < letters.endIndex {
            if ch == "#" {
                result.append(letters[index])
                index = letters.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    
    
    func formatDateWS() -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        return dateFormat.date(from: self)!
    }
    
    func validateCredential() -> Bool {
        let credentialRegEx = #"^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,20}$"#

        let credentialPred = NSPredicate(format:"SELF MATCHES %@", credentialRegEx)
        return credentialPred.evaluate(with: self)
    }
    
    func cleanPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isValidName() -> Bool {
        let cleanString = self.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        return cleanString.count >= 3
    }
    
    public func widthOfString(usingFont font: UIFont) -> CGFloat {

        let fontAttributes = [NSAttributedString.Key.font: font]

        let size = self.size(withAttributes: fontAttributes)

        return size.width

    }
}
