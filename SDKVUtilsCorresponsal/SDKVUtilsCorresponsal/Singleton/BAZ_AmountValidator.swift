//
//  BAZ_AmountValidator.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 07/12/21.
//

import UIKit
open class BAZ_AmountValidator {
  
    public static let shared: BAZ_AmountValidator = BAZ_AmountValidator()
    private var maxAmount: Double = -1.0
    private var minAmount: Double = -1.0
    private var maxDigits: Int = -1

    public func validateAmount(amount: Double) -> Bool{
        return validateAmount(amount: String(amount))
    }
    
    public func validateAmount(amount: Int) -> Bool{
        return validateAmount(amount: String(amount))
    }
    
    public func validateAmount(amount: String) -> Bool{
        if self.getParameters() {
            if let doubleAmount = Double(amount) {
                let validation = ((doubleAmount <= self.maxAmount) && (doubleAmount >= self.minAmount))
                
                if !validation {
                    var message = "Inténtalo más tarde."
                    
                    if self.maxAmount < doubleAmount {
                        message = "El monto ingresado es superior al monto máximo permitido: \(maxAmount.formatAsMoney())"
                    }else if self.minAmount > doubleAmount {
                        message = "El monto ingresado es inferior al monto mínimo permitido: \(minAmount.formatAsMoney())"
                    }
                    
                    if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                        let controller = BAZ_AlertErrorMain.createModule(title: nil, delegate: nil)
                        controller.descriptionLabel.text = message
                        rootViewController.present(controller, animated: true)
                    }
                }
                return validation
            }
        }
        return false
    }
    
    public func validateMaxAmount(amount: String) -> Bool{
        if self.getParameters() {
            if let doubleAmount = Double(amount) {
                let validation = (doubleAmount <= self.maxAmount)
                
                if !validation {
                    var message = "Inténtalo más tarde."
                    
                    if self.maxAmount < doubleAmount {
                        message = "El monto ingresado es superior al monto máximo permitido: \(maxAmount.formatAsMoney())"
                    }
                    
                    if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                        let controller = BAZ_AlertErrorMain.createModule(title: nil, delegate: nil)
                        controller.descriptionLabel.text = message
                        rootViewController.present(controller, animated: true)
                    }
                }
                return validation
            }
        }
        return false
    }
    
    public func getMaxAmount() -> Double?{
        if self.getParameters() {
            return self.maxAmount
        }
        return nil
    }
    public func getMinAmount() -> Double?{
        if self.getParameters() {
            return self.minAmount
        }
        return nil
    }
    
    public func validateDigitsAmount(amount: Int) -> Bool{
        return validateDigistAmount(amount: String(amount))
    }
    
    public func validateDigitsAmount(amount: Double) -> Bool{
        return validateDigistAmount(amount: String(amount))
    }
    
    public func validateDigistAmount(amount: String) -> Bool{
        if self.getParameters() {
            let auxStringAmount = String(Int(Double(amount) ?? Double.infinity))
            return auxStringAmount.count <= self.maxDigits
        }
        return false
    }
    
    public func getMaxDigits() -> Int?{
        if self.getParameters() {
            return self.maxDigits
        }
        return nil
    }
    
    private func getParameters() -> Bool{
        if self.maxAmount < 0 {
            guard let nonNilMaxAmount = KeychainManager.shared.getValue(forKey: CommerceAKKeystore.maximumPerTransaction.rawValue),
                  let doubleMaxAmount = Double(nonNilMaxAmount) else {
                      return false
                  }
            self.maxAmount = doubleMaxAmount
        }
        
        if self.minAmount < 0 {
            guard let nonNilMinAmount = KeychainManager.shared.getValue(forKey: CommerceAKKeystore.minimumPerTransaction.rawValue),
                  let doubleMinAmount = Double(nonNilMinAmount) else {
                      return false
                  }
            self.minAmount = doubleMinAmount
        }
        if self.maxDigits < 0 {
            let intMaxAmount = Int(self.maxAmount)
            let stringMaxAmount = String(intMaxAmount)
            self.maxDigits = stringMaxAmount.count
        }
        return true
    }
    
}
