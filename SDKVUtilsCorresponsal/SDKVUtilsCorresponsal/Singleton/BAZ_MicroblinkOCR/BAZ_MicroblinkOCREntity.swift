//
//  BAZ_MicroblinkOCREntity.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 11/05/22.
//

import Foundation


public struct BAZ_MicroblinkOCREntity {
    public var name: String?
    public var fatherLastname: String?
    public var motherLastname: String?
    public var birthDate: String?
    public var rfc: String?
    public var curp: String?
    public var gender: String?
    public var ocr: String?
    public var address: _Address?
    public struct _Address {
        public var street: String?
        public var externalNumber: String?
        public var zipCode: String?
    }
}
