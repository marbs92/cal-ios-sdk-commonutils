//
//  BAZ_TextFieldProtocol.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 18/04/21.
//

import UIKit



open class BAZ_TextFieldGeneric: UIView{
    
    public func setErrorUI(){
        //TODO: Terminar funcionalidad
        ()
    }
    
    public func setSuccessUI(){
        //TODO: Terminar funcionalidad
        ()
    }
    
    public func isRequired()->Bool{
       return false
    }
    
    public func hasErrorRequired(requiredErrorBorder: Bool = true)->Int{
        return 1
    }
    
    public func getBazForm() -> BAZ_TextFieldEntity {
        return BAZ_TextFieldEntity(defaultKey: "", currentValue: "", bazTypeInputMode: .DateEntity, withHelper: false)
    }
}
