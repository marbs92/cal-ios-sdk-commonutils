//
//  NetworkError+Generic.swift
//  AceptaPagoBaz
//
//  Created by David on 14/05/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation

public struct ErrorResponse : Codable {
    public let message: String
    public let statusCode: String?
    public let dataResponse: Data?
}

public extension NetworkError{
    func genericError() -> ErrorResponse {
        switch self {
            case .badResponse(let data):
            return ErrorResponse(message: "No se pudo obtener una respuesta valida", statusCode: "400", dataResponse: data)
            case .malformedResponse(let data):
            return ErrorResponse(message: "No se pudo obtener una respuesta valida", statusCode: "400", dataResponse: data)
            case .unexpectedStatusCode(let statusCode, let data):
            return ErrorResponse(message: "", statusCode: String(statusCode), dataResponse: data)
            default:
                return ErrorResponse(message: "No se pudo obtener una respuesta valida", statusCode: nil, dataResponse: nil)
        }
    }
}

