//
//  NetworkError.swift
//  RestServices
//
//  Created by David on 20/11/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case notNetwork
    case notFound
    case timeOut
    
    /// Indicates the server responded with an unexpected status code.
    /// - parameter Int: The status code the server respodned with.
    /// - parameter Data?: The raw returned data from the server
    case unexpectedStatusCode(Int, Data?)

    /// Indicates that the server responded using an unknown protocol.
    /// - parameter Data?: The raw returned data from the server
    case badResponse(Data?)

    /// Indicates the server's response could not be deserialized using the given Deserializer.
    /// - parameter Data: The raw returned data from the server
    case malformedResponse(Data?)

    /// Inidcates the server did not respond to the request.
    case noResponse
    
    /// Badn URL
    case badURL
    
    func printData() {
        switch self {
        case .unexpectedStatusCode(_, let data), .badResponse(let data), .malformedResponse(let data):
            if let dataToStr = data {
                printService(String(decoding: dataToStr, as: UTF8.self))
            }
        default:
            printService("Error diferente")
        }
    }
}
