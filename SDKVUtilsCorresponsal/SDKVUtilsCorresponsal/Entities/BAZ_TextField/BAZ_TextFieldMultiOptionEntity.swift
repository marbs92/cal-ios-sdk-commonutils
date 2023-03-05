//
//  BAZ_TextFieldMultiNormalEntity.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 18/04/21.
//

import UIKit

open class BAZ_TextFieldMultiOptionEntity: BAZ_TextFieldEntity {

    public var multiOptionEntity: [BAZ_TextFieldEntity]
    
    public init(models: [BAZ_TextFieldEntity],
                withHelper: Bool = false){
        self.multiOptionEntity = models
        super.init(defaultKey: "", currentValue: "", bazTypeInputMode: .MultiOptionEntity, withHelper: withHelper)
    }
}
