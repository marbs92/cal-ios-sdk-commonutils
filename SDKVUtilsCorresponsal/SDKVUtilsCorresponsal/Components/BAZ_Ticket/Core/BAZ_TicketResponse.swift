//
//  BAZ_TicketResponse.swift
//  baz-ios-akpago-utils
//
//  Created by Gustavo Tellez on 12/08/21.
//

import Foundation
import SDKCUtilsCorresponsal

public struct BAZ_TicketResponse: Codable{
    
    public var id                      :   String?
    public var folioAdministrador      :   String?
    public var folioBanco              :   String?
    public var numeroReferencia        :   String?
    public var descripcionReferencia   :   String?
    public var monto                   :   String?
    public var saldo                   :   String?
    public var comision                :   String?
    public var iva                     :   String?
    public var montoTotal              :   String?
    public var descripcionMontoTotal   :   String?
    public var ganancia                :   String?
    public var fechaHora               :   String?
    public var digital                 :   Bool?
    public var comercio                :   __Comercio?
    public var flujoArchivo            : String?
    
    enum CodingKeys: String, CodingKey {
        case id                     =   "id"
        case folioAdministrador     =   "folioAdministrador"
        case folioBanco             =   "folioBanco"
        case numeroReferencia       =   "numeroReferencia"
        case descripcionReferencia  =   "descripcionReferencia"
        case monto                  =   "monto"
        case saldo                  =   "saldo"
        case comision               =   "comision"
        case iva                    =   "iva"
        case montoTotal             =   "montoTotal"
        case descripcionMontoTotal  =   "descripcionMontoTotal"
        case ganancia               =   "ganancia"
        case fechaHora              =   "fechaHora"
        case digital                =   "digital"
        case comercio               =   "comercio"
        case flujoArchivo           =   "flujoArchivo"
    }
    
    public struct __Comercio: Codable{
        public var id              :   Int?
        public var idComisionista  :   Int?
        public var idDispositivo   :   String?
        public var nombre          :   String?
        public var identificador   :   String?
        public var direccion       :   __Direccion?
        public var operacion       :   __Operacion?
        public var movimientos     :   [__Movimientos]?
        
        enum CodingKeys: String, CodingKey{
            case id                 =   "id"
            case idComisionista     =   "idComisionista"
            case idDispositivo      =   "idDispositivo"
            case nombre             =   "nombre"
            case identificador      =   "identificador"
            case direccion          =   "direccion"
            case operacion          =   "operacion"
            case movimientos        =   "movimientos"
        }
    }
    
    public struct __Direccion: Codable{
        public var idEstado        :   Int?
        public var idMunicipio     :   Int?
        public var estado          :   String?
        public var municipio       :   String?
        public var colonia         :   String?
        public var calle           :   String?
        public var numeroExterior  :   String?
        public var numeroInterior  :   String?
        public var codigoPostal    :   String?
        
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
    
    public struct __Operacion: Codable{
        public var id                      :   String?
        public var idTipo                  :   Int?
        public var idOperador              :   String?
        public var descripcionTipo         :   String?
        public var nombreCompletoOperador  :   String?
        
        enum CodingKeys: String, CodingKey{
            case id                         =   "id"
            case idTipo                     =   "idTipo"
            case idOperador                 =   "idOperador"
            case descripcionTipo            =   "descripcionTipo"
            case nombreCompletoOperador     =   "nombreCompletoOperador"
        }
    }
    
    public struct __Movimientos: Codable{
        public var fecha       :   String?
        public var detalle     :   String?
        public var monto       :   String?
        
        enum CodingKeys: String, CodingKey{
            case fecha      =   "fecha"
            case detalle    =   "detalle"
            case monto      =   "monto"
        }
    }
    
    func decrypt() -> BAZ_TicketResponse {
        
        let response = BAZ_TicketResponse(
            id: self.id,
            folioAdministrador: self.folioAdministrador,
            folioBanco: self.folioBanco,
            numeroReferencia: decryptStr(self.numeroReferencia ?? ""),
            descripcionReferencia: self.descripcionReferencia,
            monto: decryptStr(self.monto ?? ""),
            saldo: decryptStr(self.saldo ?? ""),
            comision: self.comision,
            iva: self.iva,
            montoTotal: self.montoTotal,
            descripcionMontoTotal: self.descripcionMontoTotal,
            ganancia: self.ganancia,
            fechaHora: self.fechaHora,
            digital: self.digital,
            comercio: __Comercio(
                id: self.comercio?.id,
                idComisionista: self.comercio?.idComisionista,
                idDispositivo: decryptStr(self.comercio?.idDispositivo ?? ""),
                nombre: self.comercio?.nombre,
                identificador: self.comercio?.identificador,
                direccion: self.comercio?.direccion,
                operacion: self.comercio?.operacion,
                movimientos: self.comercio?.movimientos
            ),
            flujoArchivo: self.flujoArchivo
        )
        
        return response
    }
    
    private func decryptStr(_ str: String) -> String {
        return CipherService.shared.decryptInformation(str)
    }
}
