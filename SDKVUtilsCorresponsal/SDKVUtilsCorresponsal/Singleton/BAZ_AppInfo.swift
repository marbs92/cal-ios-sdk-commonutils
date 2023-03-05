//
//  BAZ_AppInfo.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 31/10/22.
//

import Foundation

open class BAZ_AppInfo {
    public static let shared: BAZ_AppInfo = BAZ_AppInfo()
    
    public func getVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else {
                  return ""
              }
        
        return version
    }
}
