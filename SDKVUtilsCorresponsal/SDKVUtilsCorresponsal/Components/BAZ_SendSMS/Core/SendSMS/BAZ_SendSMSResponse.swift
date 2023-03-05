//
//  BAZ_SendSMSResponse.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 14/12/21.
//

import Foundation

public struct BAZ_SendSMSResponse: Codable {
    public let resp: Int?
    public let description: String?
    public let UID: String?
    public let oper: String?
    public let city: String?
    public let town: String?
    public let region: String?
    
    enum CodingKeys: String, CodingKey {
        case resp = "resp"
        case description = "description"
        case UID = "UID"
        case oper = "operator"
        case city = "city"
        case town = "town"
        case region = "region"
    }
}
