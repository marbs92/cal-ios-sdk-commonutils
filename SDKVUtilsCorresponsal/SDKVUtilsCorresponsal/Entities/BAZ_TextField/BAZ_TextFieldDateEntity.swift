//
//  BAZ_TextFieldDateEntity.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 18/04/21.
//

import UIKit

open class BAZ_TextFieldDateEntity: BAZ_TextFieldEntity {

    var widthPercent: CGFloat?
    var titleTop: String?
    var decorativeTitleTop: NSMutableAttributedString?
    var isRequired: Bool?
    var minimumDate: Date?
    var maximumDate: Date?
    var datePickerMode : UIDatePicker.Mode?
    var rightEvent: UIButton?
    public init(defaultKey : String,
                currentValue: String = "",
                titleTop: String = "",
                decorativeTitleTop: NSMutableAttributedString? = nil,
                isRequired: Bool = false,
                rightEvent: UIButton? = nil,
                widthPercent: CGFloat = 100.0,
                minimumDate: Date? = nil,
                maximumDate: Date? = nil,
                datePickerMode: UIDatePicker.Mode,
                withHelper: Bool = false){
        self.rightEvent = rightEvent
        self.titleTop = titleTop
        self.decorativeTitleTop = decorativeTitleTop
        self.isRequired = isRequired
        self.widthPercent = widthPercent
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.datePickerMode = datePickerMode
        super.init(defaultKey: defaultKey, currentValue: currentValue, bazTypeInputMode: .DateEntity, withHelper: withHelper)
    }
    
}

