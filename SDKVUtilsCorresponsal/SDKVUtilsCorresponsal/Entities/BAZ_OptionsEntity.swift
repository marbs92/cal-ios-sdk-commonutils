//
//  OptionsEntity.swift
//  baz-ios-sdk-ecomerce
//
//  Created by Jorge Cruz on 30/03/21.
//

import UIKit

public struct BAZ_OptionsEntity: Codable {

    public var imageOption: String?
    public var titleOption: String?
    public var descriptionOption: String?
    public var idProducto: Int?
    public var idComercio: Int?
    public var idOperacion: Int?
    public var decimales: Bool?
    public var limitesOperacion: __limitesOperacion?
    public var bines : [String]?
    
    public struct __limitesOperacion: Codable  {
        public var minimo: Int?
        public var maximo: Int?
        
        public init(){
            
        }
        public init(minimo: Int, maximo: Int){
            self.minimo = minimo
            self.maximo = maximo
        }
    }
    
    public init(){
        
    }
    
    public init(imageOption: String, titleOption: String, descriptionOption: String, idComercio: Int, idOperacion: Int){
        self.imageOption = imageOption
        self.titleOption = titleOption
        self.idComercio = idComercio
        self.idOperacion = idOperacion
        self.descriptionOption = descriptionOption
    }
}
