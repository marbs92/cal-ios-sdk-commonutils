//
//  BAZ_TicketStatusWebService.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 24/11/21.
//

import Foundation
import SDKCUtilsCorresponsal

public class BAZ_TicketStatusWebService: NSObject{
    
    public typealias Response = ResponseBase<BAZ_TicketStatusResponse>
    private let path = BAZ_TicketStatusConfigWS.ticketStatus.value
    private let endpoint = "/comprobantes/"
    
    public func request(completion: @escaping (Response?, NetworkError?) -> Void) {
        if !CipherService.shared.areValid {
            CipherService.shared.request { [weak self] (accessId, error) in
                if let access = accessId {
                    self?.makeCall(accessId: access, completion: completion)
                } else {
                    completion(nil, error)
                }
            }
        } else {
            makeCall(accessId: CipherService.shared.accessId, completion: completion)
        }
    }
    
    private func makeCall(accessId: String, completion: @escaping (Response?, NetworkError?) -> Void) {

        let completeEndpoint = "\(SettingServiceManager.shared.base ?? "")\(path)\(endpoint)\(BAZ_TicketStatus.shared.entity?.idTicket ?? "")/estatus"
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
                BAZ_SentryLogManager.registerLog(user: KeychainManager.shared.getValue(forKey: UserAkKeystore.phone.rawValue) ?? "",
                                                 error: error,
                                                 endpoint: completeEndpoint)
                
                BAZ_FirebaseLogManager.registerFailureServiceLog(endpoint: completeEndpoint,
                                                                 accessID: accessId,
                                                                 responseError: error)
                completion(nil, error)
            }
        }
    }
}
