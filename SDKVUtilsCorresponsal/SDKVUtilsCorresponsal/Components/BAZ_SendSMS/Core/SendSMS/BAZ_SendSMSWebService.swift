//
//  SendSMSWebService.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 14/12/21.
//

import UIKit
import SDKCUtilsCorresponsal

internal class BAZ_SendSMSWebService: NSObject {

    typealias Response = BAZ_SendSMSResponse
    typealias Request = BAZ_SendSMSRequest
    private let path = "/api/v2/message"
    
    
    func request(data: Request, completion: @escaping (Response?, NetworkError?) -> Void) {
        SettingServiceManager.shared.host = "https://aztecadev.directo.com:1445"
        self.makeCall(data: data, completion: completion)
    }
    
    func makeCall(data: Request, completion: @escaping (Response?, NetworkError?) -> Void) {
        let completeEndpoint = self.path
        
        ApiWsManager.shared.makeCall(method: .post, endPoint: completeEndpoint, requestData: .codable(data), responseData: DecodableDeserializer<Response>()) { (result) in
            switch result {
            case .success(let data, _):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
