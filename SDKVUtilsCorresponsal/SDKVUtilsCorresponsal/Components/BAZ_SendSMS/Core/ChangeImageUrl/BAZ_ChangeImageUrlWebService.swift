//
//  BAZ_ChangeImageUrlWebService.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Fernando Sánchez Palma on 24/02/22.
//

import Foundation


import UIKit
import SDKCUtilsCorresponsal

internal class BAZ_ChangeImageUrlWebService: NSObject {

    typealias Response = ResponseBase<BAZ_ChangeImageUrlResponse>
    typealias Request = BAZ_ChangeImageUrlRequest
    private let path = BAZ_SendSMSWebServicesConfigWS.ticketStatus.value
    private let endpoint = "/comprobantes-digitales"
    
    
    func request(data: Request, completion: @escaping (Response?, NetworkError?) -> Void) {
        
        if !CipherService.shared.areValid {
            CipherService.shared.request { [weak self] (accessId, error) in
                if let access = accessId {
                    self?.makeCall(data: data, accessId: access, completion: completion)
                } else {
                    completion(nil, error)
                }
            }
        } else {
            self.makeCall(data: data, accessId: CipherService.shared.accessId, completion: completion)
        }
        

    }
    
    func makeCall(data: Request, accessId: String, completion: @escaping (Response?, NetworkError?) -> Void) {
        let completeEndpoint =  "\(SettingServiceManager.shared.base ?? "")\(path)\(endpoint)"
        
        var options = RequestOptions()
        options.httpHeaders = [
            "x-idAcceso": accessId
        ]
        
        let encryptedData = data.cipher()
        ApiWsManager.shared.makeCall(method: .post, endPoint: completeEndpoint, requestData: .codable(data), responseData: DecodableDeserializer<Response>(), options: options) { (result) in
            switch result {
            case .success(let responseData, _):
                BAZ_FirebaseLogManager.registerServiceLog(endpoint: completeEndpoint,
                                                          accessID: accessId,
                                                          requestEncrypted: encryptedData,
                                                          requestDecrypted: data,
                                                          responseEncrypted: responseData.resultado,
                                                          responseDecrypted: responseData.resultado)
                completion(responseData, nil)
                
            case .failure(let error):
                BAZ_FirebaseLogManager.registerFailureServiceLog(endpoint: completeEndpoint,
                                                                 accessID: accessId,
                                                                 requestEncrypted: encryptedData,
                                                                 requestDecrypted: data,
                                                                 responseError: error)
                completion(nil, error)
            }
        }
    }
}
