//
//  BAZ_SendSMSRequest.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 14/12/21.
//

import SDKCUtilsCorresponsal

public struct BAZ_SendSMSRequest: Codable {
    var user: String?
    var password: String?
    var number: String?
    var message: String?
    var camp_aux: String?
    var test_mode: Bool?
}
