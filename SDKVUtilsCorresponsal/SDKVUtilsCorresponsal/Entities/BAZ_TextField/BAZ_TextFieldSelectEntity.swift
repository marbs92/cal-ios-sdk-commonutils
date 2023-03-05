//
//  BAZ_TextFieldOptionEntity.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 20/04/21.
//

import UIKit

open class BAZ_TextFieldSelectEntity<T:Codable>: BAZ_TextFieldEntity {
    
    var widthPercent: CGFloat?
    var titleTop: String?
    var decorativeTitleTop: NSMutableAttributedString?
    var isRequired: Bool?
    var data: [T]?
    var dataTitle: [String]?
    
    public init(defaultKey : String,
                titleTop: String = "",
                decorativeTitleTop: NSMutableAttributedString? = nil,
                isRequired: Bool = false,
                widthPercent: CGFloat = 100.0,
                data: [T]?,
                dataTitle:[String] = [],
                withHelper: Bool = false){
        self.titleTop = titleTop
        self.decorativeTitleTop = decorativeTitleTop
        self.isRequired = isRequired
        self.widthPercent = widthPercent
        self.data = data
        self.dataTitle = dataTitle
        super.init(defaultKey: defaultKey, currentValue: "", bazTypeInputMode: .SelectEntity, withHelper: withHelper)
    }
}
