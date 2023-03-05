//
//  Serializer.swift
//  RestServices
//
//  Created by David on 20/11/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation

public protocol Serializer {
    init()
    func serialize() -> Data?
}

public class CodableSerializer<T: Encodable>: Serializer {
    public required init() {}
    
    public init(data: T) {
        self.data = data
    }
    
    private var data: T? = nil

    public func serialize() -> Data? {
        let encoder = JSONEncoder()
        guard let dataFromCodable = self.data,
              let encoded = try? encoder.encode(dataFromCodable)
              else { return nil }
        return encoded
    }

    
}

public class TextSerializer: Serializer {
    public required init() {}
    
    public init(data: String){
        self.data = data
    }
    
    private var data: String? = nil
    
    public func serialize() -> Data? {
        guard let text = self.data, let textData = text.data(using: .utf8) else {
            return nil
        }
        return textData
    }
}

public class DictionarySerializer: Serializer {
    public required init() {}
    
    public init(data: Dictionary<String, Any>){
        self.data = data
    }
    
    private var data: Dictionary<String, Any>? = nil
    
    public func serialize() -> Data? {
        guard let dictionaryData = self.data, let jsonData = try? JSONSerialization.data(withJSONObject: dictionaryData, options: []) else {
            return nil
        }
        return jsonData
    }
}

public class DictionaryQuerySerializer: Serializer {
    public required init() {}
    
    public init(data: Dictionary<String, Any>){
        self.data = data
    }
    
    private var data: Dictionary<String, Any>? = nil
    
    public func serialize() -> Data? {
        guard let dictionaryData = self.data else {
            return nil
        }
        var components = URLComponents()
        var queryItems: [URLQueryItem] = [URLQueryItem]()
        
        for (key, value) in dictionaryData {
            queryItems.append(URLQueryItem(name: key, value: "\(value)"))
        }
        components.queryItems = queryItems
        
        return components.query?.data(using: .utf8)
        
    }
    
    
}


public class DataSerializer: Serializer {
    public required init() {}
    
    public init(data: Data){
        self.data = data
    }
    
    private var data: Data? = nil
    
    public func serialize() -> Data? {
        return self.data
    }
}




