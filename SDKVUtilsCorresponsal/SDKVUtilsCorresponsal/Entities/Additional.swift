//
//  Additional.swift
//  aceptapago-ios-sdk-utils
//
//  Created by Omar Becerra on 20/07/21.
//

import Foundation

public struct Additional: Codable {
    public let description : String
    public let price : Double
    
    private enum CodingKeys: String, CodingKey {
        case description    =   "descripcion"
        case price          =   "precio"
    }
    
    public init(description: String, price:Double) {
        self.description = description
        self.price = price
    }
}
