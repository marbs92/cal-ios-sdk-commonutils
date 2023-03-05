//
//  Print+Extension.swift
//  SDKVUtilsCorresponsal
//
//  Created by Armando Carrillo - EKT on 03/03/22.
//

import Foundation

public func printDebug(_ items: String..., filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\n\t-> "
        let output = items.map { "\($0)" }.joined(separator: separator)
        Swift.print(pretty+output, terminator: terminator)
    #else
        Swift.print("RELEASE MODE")
    #endif
}

public func printDebug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        let output = items.map { "\($0)" }.joined(separator: separator)
        Swift.print(output, terminator: terminator)
    #else
        Swift.print("RELEASE MODE")
    #endif
}
