//
//  ResponseBase.swift
//  AceptaPagoBaz
//
//  Created by David on 06/05/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation

public struct ResponseBase<T>: Codable where T: Codable {
    public let mensaje: String
    public let folio: String
    public let resultado: T?
    public let codigo: String?
    public let info: String?
    public let detalles: [String]?
}

public struct EmptyResponse:Codable{}
