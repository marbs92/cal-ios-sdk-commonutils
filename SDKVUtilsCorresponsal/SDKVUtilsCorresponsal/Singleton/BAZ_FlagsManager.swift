//
//  BAZ_FlagsManager.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 16/08/22.
//

import UIKit


open class BAZ_FlagsManager: NSObject {

    public static let shared = BAZ_FlagsManager()
    public var flagsTimer: Int64 = 15 * 60
    public var areValid: Bool {
        get {
            if let last = Int64(KeychainManager.shared.getValue(forKey: FlagsAk.lastDateQuery.rawValue) ?? "0") {
                return (last + flagsTimer) > Int64(Date().timeIntervalSince1970)
            }
            return false
        }
    }
    public var flags: BAZ_FirebaseFuntionalities = BAZ_FirebaseFuntionalities()
    
    public func saveLastQuery(){
        KeychainManager.shared.storeValue(value: "\(Int64(Date().timeIntervalSince1970))", forKey: FlagsAk.lastDateQuery.rawValue)
    }
}
