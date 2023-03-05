//
//  BAZ_ChangeImageUrlResponse.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Fernando Sánchez Palma on 24/02/22.
//

import Foundation

public struct BAZ_ChangeImageUrlResponse: Codable {
    var comprobante         :  __Comprobante?
    
    enum CodingKeys: String, CodingKey {
        case comprobante       =  "comprobante"
    }
    struct __Comprobante: Codable {
        var id                :   String?
        var urlConsulta       :   String?
        var vigencia          :   String?
        
        enum CodingKeys: String, CodingKey {
            case id                   =   "id"
            case urlConsulta          =   "urlConsulta"
            case vigencia             =   "vigencia"
        }
    }
}



