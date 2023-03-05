//
//  BAZ_RejectionTicketWebService.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 09/02/22.
//

import Foundation
import SDKCUtilsCorresponsal

public class BAZ_RejectionTicketWebService: NSObject{
    
    public typealias Response = ResponseBase<BAZ_RejectionTicketResponse>
    private let path = BAZ_RejectionTicketServicesConfigWS.ticketStatus.value
    private let endpoint = "/comprobantes/"
    
    public func request(ticketID: Int, completion: @escaping (Response?, NetworkError?) -> Void) {
        if !CipherService.shared.areValid {
            CipherService.shared.request { [weak self] (accessId, error) in
                if let access = accessId {
                    self?.makeCall(ticketID: ticketID, accessId: access, completion: completion)
                } else {
                    completion(nil, error)
                }
            }
        } else {
            makeCall(ticketID: ticketID, accessId: CipherService.shared.accessId, completion: completion)
        }
    }
    
    private func makeCall(ticketID: Int, accessId: String, completion: @escaping (Response?, NetworkError?) -> Void) {

        let completeEndpoint = "\(SettingServiceManager.shared.base ?? "")\(path)\(endpoint)\(ticketID)/estatus"
        var options = RequestOptions()
        options.httpHeaders = [
            "x-idAcceso": accessId
        ]
        
        ApiWsManager.shared.makeCall(method: .get, endPoint: completeEndpoint, requestData: nil, responseData: DecodableDeserializer<Response>(), options: options) { (result) in
            switch result{
            case .success(let responseData, _):
                BAZ_FirebaseLogManager.registerServiceLog(endpoint: completeEndpoint,
                                                          accessID: accessId,
                                                          responseEncrypted: responseData.resultado,
                                                          responseDecrypted: responseData.resultado)
                completion(responseData, nil)
                
            case .failure(let error):
                BAZ_FirebaseLogManager.registerFailureServiceLog(endpoint: completeEndpoint,
                                                                 accessID: accessId,
                                                                 responseError: error)
                completion(nil, error)
            }
        }
    }
}
