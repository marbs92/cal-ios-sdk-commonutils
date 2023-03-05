//
//  Data+Extension.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 14/12/21.
//

import UIKit

extension Data {
    public func getSizeInKB() -> Double {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useKB]
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(self.count)).replacingOccurrences(of: ",", with: ".")
        if let double = Double(string.replacingOccurrences(of: " KB", with: "")) {
            return double
        }
        return 0.0
    }
}
