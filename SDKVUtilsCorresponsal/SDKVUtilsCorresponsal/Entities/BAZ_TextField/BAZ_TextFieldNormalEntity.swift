//
//  BAZ_TextFieldEntity.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 14/04/21.
//

import UIKit


public enum BAZ_TextFieldViewMask : String{
    case Phone = "Phone"
    case PhoneLogin = "PhoneLogin"
    case VisaCardNumber = "VisaCardNumber"
    case MMYYDate = "MMYYDate"
    case DDMMYYDate = "DDMMYYDate"
    case ClienteUniq = "ClienteUniq"
    case Reference = "Reference"
}

public enum BAZ_TextFieldTypeKeyboard: String{
    case AlfaNumeric = "AlfaNumeric"
    case ASCII = "ASCII"
    case Alfa = "Alfapheto"
    case AlfaSpa = "AlfaphetoSpanish"
    case AlfaNumericSpa = "AlfaNumericSpanish"
    case UUID = "UUID"
}

open class BAZ_TextFieldNormalEntity: BAZ_TextFieldEntity {
    

    var widthPercent: CGFloat?
    var titleTop: String?
    var decorativeTitleTop: NSMutableAttributedString?
    var isRequired: Bool?
    var typeKeyBoard: UIKeyboardType?
    var withMask: BAZ_TextFieldViewMask?
    var withSecurityEntry: Bool?
    var maxLenght: Int?
    var rightEvent: UIButton?
    var inputValidation: BAZ_TextFieldTypeKeyboard?
    var showToggleSecureEntry: Bool?
    var placeHolderText: String?
    var showPlaceHolderOnTop: Bool? = false
    
    public init(defaultKey : String,
                currentValue: String = "",
                titleTop: String = "",
                decorativeTitleTop: NSMutableAttributedString? = nil,
                isRequired: Bool = false,
                widthPercent: CGFloat = 100.0,
                typeKeyBoard: UIKeyboardType = .asciiCapable,
                withMask: BAZ_TextFieldViewMask? = nil,
                withSecurityEntry: Bool = false,
                maxLenght: Int = 0,
                withHelper: Bool = false,
                rightEvent: UIButton? = nil,
                inputValidation: BAZ_TextFieldTypeKeyboard = .ASCII,
                showToggleSecureEntry: Bool = false,
                placeHolderText: String = "",
                showPlaceHolderOnTop: Bool = false){
        self.rightEvent = rightEvent
        self.titleTop = titleTop
        self.decorativeTitleTop = decorativeTitleTop
        self.isRequired = isRequired
        self.typeKeyBoard = typeKeyBoard
        self.widthPercent = widthPercent
        self.withMask = withMask
        self.withSecurityEntry = withSecurityEntry
        self.maxLenght = maxLenght
        self.inputValidation = inputValidation
        self.showToggleSecureEntry = showToggleSecureEntry
        self.placeHolderText = placeHolderText
        self.showPlaceHolderOnTop = showPlaceHolderOnTop
        super.init(defaultKey: defaultKey, currentValue: currentValue, bazTypeInputMode: .NormalEntity, withHelper: withHelper)
    }
    
}
