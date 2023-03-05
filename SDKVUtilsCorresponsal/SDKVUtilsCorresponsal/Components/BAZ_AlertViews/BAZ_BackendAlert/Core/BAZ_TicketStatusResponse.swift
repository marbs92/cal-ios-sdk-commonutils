//
//  BAZ_TicketStatusResponse.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 24/11/21.
//

import Foundation
import SDKCUtilsCorresponsal

public struct BAZ_TicketStatusResponse: Codable{
    
    var id                  :   String?
    var digital             :   Bool?
    public var estatus      :   String?
    var comercio            :   __Comercio?
    var operacion           :   __Operacion?
    
    enum CodingKeys: String, CodingKey {
        case id         =   "id"
        case digital    =   "digital"
        case estatus    =   "estatus"
        case comercio   =   "comercio"
        case operacion  =   "operacion"
    }
    
    struct __Comercio: Codable{
        var id              :   Int?
        var idComisionista  :   Int?
        var idDispositivo   :   String?
        var nombre          :   String?
        var direccion       :   __Direccion?
        
        enum CodingKeys: String, CodingKey{
            case id                 =   "id"
            case idComisionista     =   "idComisionista"
            case idDispositivo      =   "idDispositivo"
            case nombre             =   "nombre"
            case direccion          =   "direccion"
        }
    }
    
    struct __Direccion: Codable{
        var idEstado        :   Int?
        var idMunicipio     :   Int?
        var estado          :   String?
        var municipio       :   String?
        var colonia         :   String?
        var calle           :   String?
        var numeroExterior  :   String?
        var numeroInterior  :   String?
        var codigoPostal    :   String?
        
        enum CodingKeys: String, CodingKey{
            case idEstado           =   "idEstado"
            case idMunicipio        =   "idMunicipio"
            case estado             =   "estado"
            case municipio          =   "municipio"
            case colonia            =   "colonia"
            case calle              =   "calle"
            case numeroExterior     =   "numeroExterior"
            case numeroInterior     =   "numeroInterior"
            case codigoPostal       =   "codigoPostal"
        }
    }
    
    struct __Operacion: Codable{
        var id                  :   String?
        var idTransaccion       :   Int?
        var tipoTransaccion     :   String?
        var fechaHora           :   String?
        
        enum CodingKeys: String, CodingKey{
            case id                 =   "id"
            case idTransaccion      =   "idTransaccion"
            case tipoTransaccion    =   "tipoTransaccion"
            case fechaHora          =   "fechaHora"
        }
    }
    
    public func decrypt() -> BAZ_TicketStatusResponse {
        
        let response = BAZ_TicketStatusResponse(
            id: self.id,
            digital: self.digital,
            estatus: self.estatus,
            comercio: __Comercio(id: self.comercio?.id,
                                 idComisionista: self.comercio?.idComisionista,
                                 idDispositivo: decryptStr(self.comercio?.idDispositivo ?? ""),
                                 nombre: self.comercio?.nombre,
                                 direccion: self.comercio?.direccion),
            operacion: self.operacion
        )
        
        return response
    }
    
    private func decryptStr(_ str: String) -> String {
        return CipherService.shared.decryptInformation(str)
    }
}
