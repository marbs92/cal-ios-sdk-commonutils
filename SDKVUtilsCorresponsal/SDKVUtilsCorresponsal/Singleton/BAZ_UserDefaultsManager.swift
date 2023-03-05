//
//  UserdefaultsManager.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 06/04/21.
//

import UIKit

open class BAZ_UserDefaultsManager: NSObject {

    let userDefault = UserDefaults.standard
    public static var shareManager = BAZ_UserDefaultsManager()
    
    public func saveUserDefaultString(stringValue value : String,forKey key: String){
        userDefault.set(value, forKey: key)
    }
    
    public func getUserDefaultString(forKey key: String)->String{
        return userDefault.string(forKey: key) ?? ""
    }
    
}
