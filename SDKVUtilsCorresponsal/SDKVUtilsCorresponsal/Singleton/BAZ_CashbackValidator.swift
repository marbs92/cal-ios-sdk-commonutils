//
//  BAZ_CashbackValidator.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 23/12/21.
//

import Foundation
import UIKit
open class BAZ_CashbackValidator {
    public static let shared: BAZ_CashbackValidator = BAZ_CashbackValidator()
    private var maxCashback: Double = -1.0
    private var minCashback: Double = -1.0
    private var cashbackMaxDigits: Int = -1

    public func validateCashback(amount: Double, cashback: Double, parent: UIView) -> Bool{
        return validateCashback(amount: String(amount), cashback: String(cashback), parent: parent)
    }
    
    public func validateCashback(amount: Int, cashback: Int, parent: UIView) -> Bool{
        return validateCashback(amount: String(amount), cashback: String(cashback), parent: parent)
    }
    
    public func validateCashback(amount: String, cashback: String, parent: UIView) -> Bool{
        if self.getParameters() {
            if let doubleAmount = Double(amount),
                let doubleCashback = Double(cashback),
                let maxAmount = BAZ_AmountValidator.shared.getMaxAmount(),
               self.isCashbackAllowed(amount: amount){
                
                let cashbackValidation = ((doubleCashback <= self.maxCashback) && (doubleCashback >= self.minCashback))
                
                if !cashbackValidation {
                    var message = "Inténtalo más tarde."
                    
                    if self.maxCashback < doubleCashback {
                        message = "El monto ingresado es superior al monto máximo permitido: \(maxCashback.formatAsMoney())"
                    }else if self.minCashback > doubleCashback {
                        message = "El monto ingresado es inferior al monto mínimo permitido: \(minCashback.formatAsMoney())"
                    }

                    if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                        let controller = BAZ_AlertErrorMain.createModule(title: nil, delegate: nil)
                        controller.descriptionLabel.text = message
                        rootViewController.present(controller, animated: true)
                    }
                    return false
                }
  
                let cashbackMaxAmountValidation = ((doubleAmount + doubleCashback) <= maxAmount)
                if !cashbackMaxAmountValidation {
                    let currentMaxCashback = (maxAmount - doubleAmount) <= self.maxCashback ? (maxAmount - doubleAmount) : self.maxCashback
                    let message = "El total de la suma de retiro de efectivo y el monto de la transacción es superior al monto máximo permitido por transacción: \(maxAmount.formatAsMoney())" + "\n\n" + "El monto máximo actual de retiro de efectivo permitido es: \(currentMaxCashback.formatAsMoney())"
                    
                    if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                        let controller = BAZ_AlertErrorMain.createModule(title: nil, delegate: nil)
                        controller.descriptionLabel.text = message
                        rootViewController.present(controller, animated: true)
                    }
                    return false
                }
                
                return true
            }
        }
        return false
    }
    
    public func isCashbackAllowed(amount: Int) -> Bool {
        return isCashbackAllowed(amount: String(amount))
    }
    
    public func isCashbackAllowed(amount: Double) -> Bool {
        return isCashbackAllowed(amount: String(amount))
    }
    
    public func isCashbackAllowed(amount: String) -> Bool {
        if self.getParameters(), let maxAmount = BAZ_AmountValidator.shared.getMaxAmount(), let amount = Double(amount){
             let currentMaxCashback = (maxAmount - amount)
            return currentMaxCashback >= self.minCashback
        }
        return false
    }
    
    public func getCurrentMaxAllowedCashback(amount: Int) -> Int? {
        guard let currentMaxCashback = self.getCurrentMaxAllowedCashback(amount: String(amount)), let currentDoubleMaxCashback = Double(currentMaxCashback) else {
            return nil
        }
        
        return Int(currentDoubleMaxCashback)
    }
    
    public func getCurrentMaxAllowedCashback(amount: Double) -> Double? {
        guard let currentMaxCashback = self.getCurrentMaxAllowedCashback(amount: String(amount)) else {
            return nil
        }
        return Double(currentMaxCashback)
    }
    
    public func getCurrentMaxAllowedCashback(amount: String) -> String? {
        if self.getParameters(),
            let maxAmount = BAZ_AmountValidator.shared.getMaxAmount(),
            let amount = Double(amount),
            self.isCashbackAllowed(amount: amount) {
            
            let currentMaxCashback = (maxAmount - amount) <= self.maxCashback ? (maxAmount - amount) : self.maxCashback
           return "\(currentMaxCashback)"
        }
        return nil
    }
    
    public func getMaxCashback() -> Double?{
        if self.getParameters() {
            return self.maxCashback
        }
        return nil
    }
    public func getMinCashback() -> Double?{
        if self.getParameters() {
            return self.minCashback
        }
        return nil
    }
    
    public func validateDigistAmount(amount: Int) -> Bool{
        return validateDigistAmount(amount: String(amount))
    }
    
    public func validateDigistAmount(amount: Double) -> Bool{
        return validateDigistAmount(amount: String(amount))
    }
    
    public func validateDigistAmount(amount: String) -> Bool{
        if self.getParameters() {
            let auxStringAmount = String(Int(Double(amount) ?? Double.infinity))
            return auxStringAmount.count <= self.cashbackMaxDigits
        }
        return false
    }
    
    public func getCashbackMaxDigits() -> Int?{
        if self.getParameters() {
            if let amountMaxDigits = BAZ_AmountValidator.shared.getMaxDigits() {
                return self.cashbackMaxDigits <= amountMaxDigits ? self.cashbackMaxDigits : amountMaxDigits
            }else {
                return nil
            }
        }
        return nil
    }
    
    private func getParameters() -> Bool{
        if self.maxCashback < 0 {
            guard let nonNilMaxCashback = KeychainManager.shared.getValue(forKey: CommerceAKKeystore.maximumPerCashback.rawValue),
                  let doubleMaxCashback = Double(nonNilMaxCashback) else {
                      return false
                  }
            guard let maxAmount = BAZ_AmountValidator.shared.getMaxAmount() else {
                    return false
                }
            self.maxCashback = doubleMaxCashback <= maxAmount ? doubleMaxCashback : maxAmount
        }
        
        if self.minCashback < 0 {
            guard let nonNilMinCashback = KeychainManager.shared.getValue(forKey: CommerceAKKeystore.minimumPerCashback.rawValue),
                  let doubleMinCashback = Double(nonNilMinCashback) else {
                      return false
                  }
            self.minCashback = doubleMinCashback
        }
        
        if self.cashbackMaxDigits < 0 {
            let intMaxCashback = Int(self.maxCashback)
            let stringMaxCashback = String(intMaxCashback)
            guard let amountMaxDigits = BAZ_AmountValidator.shared.getMaxDigits() else {
                return false
            }
            self.cashbackMaxDigits = stringMaxCashback.count <= amountMaxDigits ? stringMaxCashback.count : amountMaxDigits
        }
        return true
    }
    
}
