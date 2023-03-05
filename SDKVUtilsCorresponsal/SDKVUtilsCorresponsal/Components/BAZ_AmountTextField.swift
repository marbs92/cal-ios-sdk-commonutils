//
//  BAZ_AmountTextField.swift
//  AmountTest
//
//  Created by Gustavo Tellez on 30/07/21.
//

import UIKit

public protocol BAZ_AmountTextFieldDelegate {
    func amountChanged()
    func finishedAmountEdition()
}

open class BAZ_AmountTextField : UIView{
    
    private lazy var currencyLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var integerTextField : UITextField = {
        let textField = UITextField()
        textField.tag                       = 1
        textField.delegate                  = self
        textField.placeholder               = "0"
        textField.keyboardType              = .decimalPad
        textField.textAlignment             = .right
        textField.contentVerticalAlignment  = .bottom
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(self.didMontEnd(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(self.didAmontChange(_:)), for: .editingChanged)
        textField.autocorrectionType = .no
        return textField
    }()
    
    private lazy var pointLabel : UILabel = {
        let label = UILabel()
        label.text = "."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var decimalTextField : UITextField = {
        let textField = UITextField()
        textField.tag                       = 2
        textField.delegate                  = self
        textField.placeholder               = "00"
        textField.maxSize                   = 2
        textField.keyboardType              = .numberPad
        textField.contentVerticalAlignment  = .top
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(self.didMontEnd(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(self.didAmontChange(_:)), for: .editingChanged)
        textField.autocorrectionType = .no
        return textField
    }()
    
    public var isEmpty : Bool {
        get{
            if let integerPartIsEmpty   = integerTextField.text?.isEmpty,
               let decimalPartIsEmpty      = decimalTextField.text?.isEmpty,
               integerPartIsEmpty == true,
               decimalPartIsEmpty == true{
                
                return true
            }else{
                return false
            }
        }
    }
    
    public var isEditing : Bool {
        get{
            return (integerTextField.isEditing || decimalTextField.isEditing)
        }
    }
    
    private var currentFont             : UIFont?
    private var currentColor            : UIColor?
    private var currentPlaceholderColor : UIColor?
    
    private var maxWidth        : CGFloat   = 0.0
    private var numberOfDigits  : Int       = 0
    private var editCents       : Bool      = false
    private var integerText     : String    = ""
    
    private var widthDecimalComponent : NSLayoutConstraint?
    private var decimalTexFieldBottomConstraint : NSLayoutConstraint?
    private var pointLabelBottomConstraint : NSLayoutConstraint?
    
    public var delegate : BAZ_AmountTextFieldDelegate?
    
    public init(currency        :   String  = "$",
                amount          :   String  = "",
                color           :   UIColor = BAZ_ColorManager.navyBlueDarkRW,
                placeHolderColor:   UIColor = BAZ_ColorManager.navyBlueDarDissablekRW,
                font            :   UIFont  =  UIFont.Poppins_Medium_80,
                maxWidth        :   CGFloat = UIScreen.main.bounds.width - 40.0,
                numberOfDigits  :   Int     = 5,
                editCents       :   Bool    = false)
    {
        super.init(frame: CGRect.zero)
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        buildUI(currency: currency, amount: amount, color: color, placeHolderColor: placeHolderColor, font: font, totalDigits: numberOfDigits, editCents: editCents)
        buildConstraints(maxWidth: maxWidth)
        
        if amount != ""{
            sendAmountToShow(text: amount)
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI(currency : String, amount: String, color: UIColor, placeHolderColor : UIColor, font: UIFont, totalDigits: Int, editCents: Bool){
        
        self.numberOfDigits          = totalDigits
        self.currentFont             = font
        self.currentColor            = color
        self.currentPlaceholderColor = placeHolderColor
        self.editCents               = editCents
        
        changeColorComponents(to: amount == "" ? currentPlaceholderColor : currentColor)
        changeFontComponents(to: currentFont)
        
        currencyLabel.text = currency
        
        if editCents == false{
            decimalTextField.isEnabled = false
        }
        
        [currencyLabel, integerTextField, pointLabel, decimalTextField].forEach { component in
            self.addSubview(component)
        }
    }
    
    private func buildConstraints(maxWidth: CGFloat){
        
        let heightCurrencyLabel = currencyLabel.intrinsicContentSize.height
        let widthCurrencyLabel  = currencyLabel.intrinsicContentSize.width
        let widthPointLabel     = pointLabel.intrinsicContentSize.width
        let widthDecimalTextField  = decimalTextField.intrinsicContentSize.width
        
        self.maxWidth = maxWidth - (widthCurrencyLabel + widthPointLabel + widthDecimalTextField)
        
        let widthIntegerTextField = integerTextField.intrinsicContentSize.width
        widthDecimalComponent = integerTextField.widthAnchor.constraint(equalToConstant: widthIntegerTextField)
        
        let heightDecimalTextField = decimalTextField.intrinsicContentSize.height
        
        let spacingBottom : CGFloat = getSpacingBottom()
        pointLabelBottomConstraint = pointLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: spacingBottom)
        decimalTexFieldBottomConstraint = decimalTextField.topAnchor.constraint(equalTo: self.topAnchor,constant: 18)
        
        NSLayoutConstraint.activate([
            
            currencyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            currencyLabel.heightAnchor.constraint(equalToConstant: heightCurrencyLabel),
            currencyLabel.widthAnchor.constraint(equalToConstant: widthCurrencyLabel),
            currencyLabel.topAnchor.constraint(equalTo: decimalTextField.topAnchor),
            //currencyLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            integerTextField.topAnchor.constraint(equalTo: self.topAnchor),
            integerTextField.leadingAnchor.constraint(equalTo: currencyLabel.trailingAnchor),
            widthDecimalComponent!,
            integerTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            pointLabel.leadingAnchor.constraint(equalTo: integerTextField.trailingAnchor),
            pointLabel.widthAnchor.constraint(equalToConstant: widthPointLabel),
            pointLabelBottomConstraint!,
            
            decimalTextField.leadingAnchor.constraint(equalTo: pointLabel.trailingAnchor),
            decimalTextField.widthAnchor.constraint(equalToConstant: widthDecimalTextField),
            decimalTextField.heightAnchor.constraint(equalToConstant: heightDecimalTextField),
            decimalTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            decimalTextField.centerYAnchor.constraint(equalTo: integerTextField.centerYAnchor),
//            decimalTexFieldBottomConstraint!
        ])
    }
    
    private func updateAmount(to newAmount: String, withColor color: UIColor?){
        
        updateText(to: newAmount)
        changeColorComponents(to: color)
        updateAmountConstraints()
    }
    
    private func updateText(to newText: String){
        integerTextField.attributedText = NSAttributedString(
            string: newText,
            attributes: [NSAttributedString.Key.font : currentFont!]
        )
    }
    
    private func changeColorComponents(to color: UIColor?){
        currencyLabel.textColor     =   color
        pointLabel.textColor        =   color
        
        if (integerTextField.text?.isEmpty ?? false){
            integerTextField.attributedPlaceholder = NSAttributedString(
                string: "0",
                attributes: [NSAttributedString.Key.foregroundColor : color!])
        }else{
            integerTextField.textColor = color
        }
        
        if (decimalTextField.text?.isEmpty ?? false){
            decimalTextField.attributedPlaceholder = NSAttributedString(
                string: "00",
                attributes: [NSAttributedString.Key.foregroundColor : color!])
        }else{
            decimalTextField.textColor = color
        }
    }
    
    private func changeFontComponents(to font: UIFont?){
        let fontSizeToAnotherComponents = (font?.pointSize ?? 0.0) / 3.0
        
        integerTextField.font   = font
        currencyLabel.font      = font?.withSize(fontSizeToAnotherComponents)
        pointLabel.font         = font?.withSize(fontSizeToAnotherComponents)
        decimalTextField.font      = font?.withSize(fontSizeToAnotherComponents)
    }
    
    private func updateAmountConstraints(){
        
        if let widthContraint = widthDecimalComponent{

            integerTextField.adjustsFontSizeToFitWidth = false
            widthContraint.constant = integerTextField.intrinsicContentSize.width
                    
            if widthContraint.constant > maxWidth{
                integerTextField.adjustsFontSizeToFitWidth = true
                widthContraint.constant = maxWidth
            }
        }
        self.layoutIfNeeded()
        //updateBottomContraint()
    }
    
    private func updateBottomContraint(){
        pointLabelBottomConstraint?.constant    = getSpacingBottom()
        decimalTexFieldBottomConstraint?.constant  = getSpacingBottom()
        self.layoutIfNeeded()
    }
    
    private func getSpacingBottom() -> CGFloat{
        let height  = integerTextField.font?.pointSize ?? 0.0
        let spacing = -(height / 10.0)
        return spacing
    }
    
    public func sendAmountToShow(text: String){
        if text.contains("."){
            let aux = text.split(separator: ".")
            let integer = String(aux[0])
            let decimal = String(aux[1])
            
            if integer.count <= numberOfDigits{
                let decimalAmount = addCommas(ToString: integer)
                updateDecimal(text: decimal)
                updateAmount(to: decimalAmount, withColor: currentColor)
            }
            
        }else{
            if text.count <= numberOfDigits{
                let amount = addCommas(ToString: text)
                if text != "" && text != "0.00" && text != "0.00"{
                    updateAmount(to: amount, withColor: currentColor)
                }else{
                    updateAmount(to: amount, withColor: currentPlaceholderColor)
                }
                
            }
        }
    }
    
    private func updateDecimal(text: String){
        var newDecimal = ""

        if text.count == 1{
            newDecimal = "\(text)0"
            
        }else if text.count > 2{
            let aux = String(format: "%.2f", Double("0.\(text)")!)
            let decimalPart = aux.split(separator: ".")
            newDecimal = String(decimalPart[1])
            
        }else{
            newDecimal = text
        }
        
        decimalTextField.text = newDecimal
    }
    
    public func getAmount() -> String{
        let auxInteger = (integerTextField.text ?? "0").replacingOccurrences(of: ",", with: "")
        let auxDecimal = decimalTextField.text ?? "00"
        
        let integerPart = auxInteger != "" ? auxInteger : "0"
        let decimalPart = auxDecimal != "" ? auxDecimal : "00"
        
        return "\(integerPart).\(decimalPart)"
    }
    
    @objc private func didAmontChange(_ sender: UITextField){
        delegate?.amountChanged()
    }
    
    @objc private func didMontEnd(_ sender: UITextField){
        
        if self.isEmpty{
            changeColorComponents(to: currentPlaceholderColor)
        }
        
        delegate?.finishedAmountEdition()
    }
    
    public func endEditing(){
        self.integerTextField.resignFirstResponder()
        self.decimalTextField.resignFirstResponder()
    }
}

extension BAZ_AmountTextField : UITextFieldDelegate{
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if getAmount() != "" && getAmount() != "0.00" && getAmount() != "0"{
            changeColorComponents(to: currentColor)
        }else{
            changeColorComponents(to: currentPlaceholderColor)
        }
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if editCents && textField.tag == 1 {
            textField.tintColor = .clear
            DispatchQueue.main.async {
                self.decimalTextField.becomeFirstResponder()
            }
        }
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
//        let position = textField.endOfDocument
        // only if there is a currently selected range
        if let selectedRange = textField.selectedTextRange {
            // and only if the new position is valid
            if let newPosition = textField.position(from: selectedRange.start, offset: +1) {
                // set the new position
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 1{
            
//            var newText = ""
            
            switch string {
            
            case ".":
                integerText = integerTextField.text ?? ""
                if editCents{
                    decimalTextField.text = ""
                    decimalTextField.becomeFirstResponder()
                }
                
            case "":
                integerTextField.text?.removeLast()
                integerText = addCommas(ToString: integerTextField.text ?? "")
                
            default:
                integerText = validateText(string)
            }
            
            if integerText != "" && integerText != "0" && integerText != "0.00"{
                updateAmount(to: integerText, withColor: currentColor)
            }else{
                updateAmount(to: "", withColor: currentPlaceholderColor)
            }
            
            delegate?.amountChanged()
            return false
            
        }else{
            var maxLength = 3
            
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            if !(textField.text?.count == 0 && string == "0"){
                changeColorComponents(to: currentColor)
                if newString.length == maxLength{
                    if !(integerTextField.text?.count == numberOfDigits + 1) {
                        let decToIntText = String((textField.text ?? "").prefix(1))
                        integerText = validateText(decToIntText)
                        updateAmount(to: integerText, withColor: currentColor)
                        textField.text?.removeFirst()
                    } else {
                        maxLength = 2
                    }
                }
            }else{
                return false
            }
            
            if string == "" {
                if !integerText.isEmpty {
                    let currentString = decimalTextField.text ?? ""
                    let intToDecText = String(integerText.suffix(1))
                    decimalTextField.text = intToDecText + currentString
                    integerText.removeLast()
                    integerText = addCommas(ToString: integerText)
                    updateAmount(to: integerText, withColor: currentColor)
                }
                if textField.text?.count == 1 {
                    decimalTextField.text = ""
                    changeColorComponents(to: currentPlaceholderColor)
                }
            }
                return newString.length <= maxLength 
        }
    }
    
    func validateText(_ text: String) -> String{
        var newText             =   integerTextField.text ?? ""
        let totalCharacters     =   integerTextField.text?.count ?? 0
        let firstCharacter      =   String(integerTextField.text?.first ?? Character(" "))
        
        if totalCharacters <= numberOfDigits && firstCharacter != "0"{
            newText = addCommas(ToString: newText + text)
        }
        return newText
    }
    
    func addCommas(ToString text: String) -> String{
        
        var auxText = text.replacingOccurrences(of: ",", with: "")
        if auxText.count > 6{
            let index = auxText.index(auxText.endIndex, offsetBy: -6)
            auxText.insert(",", at: index)
            
        }
        
        if auxText.count > 3{
            let index = auxText.index(auxText.endIndex, offsetBy: -3)
            auxText.insert(",", at: index)
        }
        return auxText
    }
    public func FirstResponse(){
               // self.decimalTextField.becomeFirstResponder()
                self.integerTextField.becomeFirstResponder()
            }
}
