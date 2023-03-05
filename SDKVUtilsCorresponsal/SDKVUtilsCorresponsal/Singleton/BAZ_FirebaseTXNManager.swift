//
//  BAZ_FirebaseTXNManager.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 03/11/22.
//

import UIKit

public class BAZ_TxnData {
    public var day: String
    public var hour: String
    public var errorCode: String
    public var errorMessage: String
    public var userPhone: String
    public var platform: String
    public var version: String
    public var systemVersion: String
    
    public init(errorCode: String, errorMessage: String) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
        self.day = "unknown"
        self.hour = "unknown"
        self.userPhone = KeychainManager.shared.getValue(forKey: UserAkKeystore.phone.rawValue) ?? "unknown"
        self.platform = "IOS"
        self.version = BAZ_AppInfo.shared.getVersion()
        self.systemVersion = UIDevice.current.systemVersion
        
        self.getTimeData()
    }
    
    private func getTimeData() {
        var timeData = Date().dayToStringMxFullFormat.split(separator: " ")
        self.day = String(timeData.first ?? "unknown").replacingOccurrences(of: "/", with: "")
        
        if timeData.count >= 2 {
            timeData.removeFirst()
            self.hour = String(timeData.joined(separator: " "))
        }
    }
}

open class BAZ_FirebaseTXNManager {
    
    public static func registerLog(txnData: BAZ_TxnData) {
        if let database = BAZ_FirebaseManager.shared.firestore {
            
            let data: [String : String] = ["OS": txnData.systemVersion,
                                           "codigo": txnData.errorCode,
                                           "desc": txnData.errorMessage,
                                           "fecha": txnData.day,
                                           "hora": txnData.hour,
                                           "plataforma": txnData.platform,
                                           "telefono": txnData.userPhone,
                                           "version": txnData.version]
            
            let lastUpdate: [String: String] = ["lastUpdate": "\(Date())"]
            
            database.collection("countTXN")
                .document(txnData.day)
                .collection("codigo")
                .document()
                .setData(data)
            
            database.collection("countTXN").document(txnData.day).setData(lastUpdate)
        }
    }
}
