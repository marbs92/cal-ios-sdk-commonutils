//
//  BAZ_TicketEntity.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 26/07/21.
//

import UIKit

public struct BAZ_TicketEntity: Codable {

    public var module               :   String?
    public var moduleDescription    :   String?
    
    public var importe      :   String?
    public var comision     :   String?
    public var ivaComision  :   String?
    public var total        :   String?
    
    public var folio                :   String?
    public var authorizationFolio   :   String?
    public var folioAdmin           :   String?
    public var idTransaccion        :   String?
    
    public var requirePrint : Bool?
    
    
    public init(module: String,
                moduleDescription : String,
                importe: String,
                comision: String,
                ivaComision: String,
                total : String,
                folio: String,
                authorizationFolio: String,
                folioAdmin: String = "",
                idTransaccion: String = "",
                requirePrint : Bool = false) {
        
        self.module                 =   module
        self.moduleDescription      =   moduleDescription
        self.importe                =   importe
        self.comision               =   comision
        self.ivaComision            =   ivaComision
        self.total                  =   total
        self.folio                  =   folio
        self.folioAdmin             =   folioAdmin
        self.authorizationFolio     =   authorizationFolio
        self.idTransaccion          =   idTransaccion
        self.requirePrint           =   requirePrint
    }
}
