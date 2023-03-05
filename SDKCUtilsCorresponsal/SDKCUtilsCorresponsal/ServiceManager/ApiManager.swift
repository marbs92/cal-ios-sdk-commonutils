//
//  ApiManager.swift
//  AceptaPagoBaz
//
//  Created by David on 21/04/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation

public struct AnyEncodable: Encodable {
    let value: Encodable
    
    public func encode(to encoder: Encoder) throws {
        try self.value.encode(to: encoder)
    }
}

public enum EnumRequest: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum EnumType {
    case codable(_ data: Codable)
    case dictionary(_ data: Dictionary<String, Any>)
    case text(_ data: String)
    
    var serializer: Serializer? {
        switch self {
        case .codable(let serializer):
            let anyCodable = AnyEncodable(value: serializer)
            return CodableSerializer(data: anyCodable)
        case .dictionary(let dictionary):
            return DictionarySerializer(data: dictionary)
        case .text(let text):
            return TextSerializer(data: text)
        }
    }
    
}

public struct RequestOptions {
    public var expectedStatusCode: Int? = 200
    public var httpHeaders: [String : String]?
    public var queryParams: [String : Any] = [String : Any]()
    public var requestTimeoutSeconds = 60 as TimeInterval
    public init() {}
}
