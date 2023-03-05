//
//  BAZ_TicketWebService.swift
//  baz-ios-akpago-utils
//
//  Created by Gustavo Tellez on 12/08/21.
//

import Foundation
import SDKCUtilsCorresponsal

class BAZ_TicketWebService: NSObject{
    
    typealias Response = ResponseBase<BAZ_TicketResponse>
    private let path = BAZ_TicketsConfigWS.tickets.value
    private let endpoint = "/comprobantes/"
    
    func request(completion: @escaping (Response?, NetworkError?) -> Void) {
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

        let completeEndpoint = "\(SettingServiceManager.shared.base ?? "")\(path)\(endpoint)\(BAZ_Tickets.shared.entity?.idTicket ?? "")"
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
