//
//  BAZ_TextFieldOptionEntity.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 18/04/21.
//

import UIKit

open class BAZ_TextFieldOptionEntity: BAZ_TextFieldEntity {
    
    var entities: [String]?
    var titleTop: String?
    var isRequired: Bool?
    
    public init(defaultKey : String,
                titleTop: String = "",
                isRequired: Bool = false,
                models: [String],
                withHelper: Bool = false){
        self.entities = models
        self.titleTop = titleTop
        self.isRequired = isRequired
        super.init(defaultKey: defaultKey, currentValue: "", bazTypeInputMode: .OptionEntity, withHelper: withHelper)
    }
}
