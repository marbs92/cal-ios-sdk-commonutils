//
//  BAZ_TextFieldAmount.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 16/02/22.
//

import Foundation
import UIKit

public protocol BAZ_TextFieldAmountProtocol {
    func notifyTextFieldDidChange(_ textField: UITextField, value: Double)
}

open class BAZ_TextFieldAmount: UITextField {
    private var bazDelegate: BAZ_TextFieldAmountProtocol?
    private var textFieldTextColor: UIColor = BAZ_ColorManager.navyBlueDarkRW
    private var integerSize: CGFloat = 55
    private var floatSize: CGFloat = 30
    private var maxDigitsLenght: Int = 0
    
    public convenience init(delegate: BAZ_TextFieldAmountProtocol?,
                            maxDigitsLenght: Int,
                            textColor: UIColor = BAZ_ColorManager.navyBlueDarkRW,
                            integerSize: CGFloat = 55,
                            floatSize: CGFloat = 30) {
        self.init()
        
        self.bazDelegate = delegate
        self.maxDigitsLenght = maxDigitsLenght
        self.textFieldTextColor = textColor
        self.integerSize = integerSize
        self.floatSize = floatSize
        
        self.tintColor = .clear
        self.setCursorPosition()
        
        self.setValue(value: 0.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardType = .decimalPad
        self.delegate = self
        self.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.addTarget(self, action: #selector(self.setCursorPosition), for: UIControl.Event.allTouchEvents)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField){
        if let amount = textfield.text {
            let currentStringAmount = self.cleanSymbols(text: amount)
            let doubleAmount = (Double(currentStringAmount) ?? 0.0) / 100
            
            self.setValue(value: doubleAmount)
        }
    }
    
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc private func setCursorPosition(){
        let newPosition = self.endOfDocument
        self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
    }
    
    public func setValue(value: Double){
        self.attributedText = UIFormatterMoney.constructAttributedTotal(
            total: value,
            color: value > 0 ? self.textFieldTextColor : self.textFieldTextColor.withAlphaComponent(0.2),
            integerSize: self.integerSize,
            floatSize: self.floatSize,
            view: .cobro)
        
        self.bazDelegate?.notifyTextFieldDidChange(self, value: value)
        self.setCursorPosition()
    }
    
    private func cleanSymbols(text: String) -> String{
        return text.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "+", with: "")
    }
}


extension BAZ_TextFieldAmount: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text{
            let value = Int(self.cleanSymbols(text: text) + string) ?? 0
            let currentDigits = String(value).count
            return string != "." && (currentDigits <= self.maxDigitsLenght || string == "")
        }
        self.setCursorPosition()
        return false
    }
}
