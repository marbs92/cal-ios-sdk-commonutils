//
//  CipherResponse.swift
//  AceptaPagoBaz
//
//  Created by David on 01/06/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation

struct CipherResponse: Codable {
    let idAcceso: String
    let accesoPublico: String
    let accesoPrivado: String
    let accesoSimetrico: String?
    let codigoAutentificacionHash: String?
}
