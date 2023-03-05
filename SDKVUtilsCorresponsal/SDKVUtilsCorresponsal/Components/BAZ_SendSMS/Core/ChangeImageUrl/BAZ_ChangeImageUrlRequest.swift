//
//  BAZ_ChangeImageUrlRequest.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Fernando Sánchez Palma on 24/02/22.
//

import Foundation

import SDKCUtilsCorresponsal

public struct BAZ_ChangeImageUrlRequest: Codable {
    
    var idDispositivo          : String?
    var idUsuario              : String?
    var comprobante            :   __Comprobante?

    enum CodingKeys: String, CodingKey {
        case idDispositivo         =   "idDispositivo"
        case idUsuario             =   "idUsuario"
        case comprobante           =   "comprobante"
    }

    struct __Comprobante: Codable {
        var id              :   String?
        var urlImagen       :   String?

        enum CodingKeys: String, CodingKey{
            case id                 =   "id"
            case urlImagen          =   "urlImagen"
        }
    }
    
    func cipher() -> BAZ_ChangeImageUrlRequest {
        return BAZ_ChangeImageUrlRequest(
            idDispositivo: cipherStr(self.idDispositivo ?? ""),
            idUsuario: self.idUsuario,
            comprobante: __Comprobante(id: cipherStr(self.comprobante?.id ?? ""),
                                       urlImagen: self.comprobante?.urlImagen))
    }
    
    private func cipherStr(_ str: String) -> String {
        return CipherService.shared.encryptInformation(str)
    }

}
