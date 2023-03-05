//
//  BAZ_TextFieldProtocol.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 18/04/21.
//

import UIKit


@objc public protocol BAZ_TextFieldEntityProtocol: class{
    
    @objc optional func notifyDidTapHelper(defaultKey: String, view: BAZ_CircleHelperMessageView)
    @objc optional func notifyDidChange(element: String, defaultKey: String)
    @objc optional func notifyDidChangeGeneric()
    @objc optional func notifyRightViewTap(_ sender: UIButton)
    @objc optional func notifyOptionSelected(element: String, defaultKey: String)
    @objc optional func notifyTapSelect(defaultKey: String)
    @objc optional func notifyDoneButtonTapped(tag: Int)
}


open class BAZ_TextFieldEntity{
    
    public weak var delegate: BAZ_TextFieldEntityProtocol?
    
    private var withHelper: Bool?
    private var defaultKey: String?
    private var currentValue: String?
    private var currentGenericValue : Codable?
    public  var bazTypeInputMode :BAZ_TypeInputMode?
    
    init(defaultKey: String, currentValue: String,bazTypeInputMode:BAZ_TypeInputMode, withHelper: Bool) {
        self.currentValue = currentValue
        self.defaultKey = defaultKey
        self.bazTypeInputMode = bazTypeInputMode
        self.withHelper = withHelper
    }
    
    public func getCurrentValue()->String{
        return currentValue ?? ""
    }
    
    public func setCurrentValue(value text: String){
        if(text == "Masculino"){
            self.currentValue = "M"
        }else if (text == "Femenino"){
            self.currentValue = "F"
        }else{
            self.currentValue = text
        }
        delegate?.notifyOptionSelected?(element: text, defaultKey: defaultKey ?? "")
        delegate?.notifyDidChange?(element: text, defaultKey: defaultKey ?? "")
        
    }
    
    public func setSelectTap(){
        delegate?.notifyTapSelect?(defaultKey: defaultKey ?? "")
    }
    
    public func setEventTap(objectToTap: BAZ_CircleHelperMessageView){
        delegate?.notifyDidTapHelper?(defaultKey: defaultKey ?? "", view: objectToTap)
    }
    
    public func setCurrentGenericValue(value object: Codable){
        self.currentGenericValue = object
        delegate?.notifyDidChangeGeneric?()
    }
    
    public func getCurrenGenerictValue()->Codable{
        return currentGenericValue ?? ""
    }
    
    public func getDefaultKey()->String{
        return defaultKey ?? ""
    }
    
    public func getWithHelper()->Bool{
        return withHelper ?? false
    }
}
