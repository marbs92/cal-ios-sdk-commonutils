//
//  CipherService.swift
//  AceptaPagoBaz
//
//  Created by David on 22/05/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation

open class CipherService {
    public static let shared = CipherService()
    typealias Response = ResponseBase<CipherResponse>
    private let path = "/seguridad/v1"
    private let endpoint = "/aplicaciones/llaves"
    private var data: CipherResponse? = nil
    private var publicK: PublicKey?
    private var privateK: PrivateKey?    
    public var areValid: Bool {
        get {
            if let last = lastDateQuery {
                return last + nextQuery > Int64(Date().timeIntervalSince1970)
            }
            return false
        }
    }
    
    private var lastDateQuery: Int64? = nil
    private var nextQuery: Int64 = 900
    public var accessId: String = ""
    
    
    public func request(completion: @escaping (String?, NetworkError?) -> Void) {
        let completeEndpoint = "\(SettingServiceManager.shared.base ?? "")\(path)\(endpoint)"
        ApiWsManager.shared.makeCall(method: .get, endPoint: completeEndpoint, responseData: DecodableDeserializer<Response>()) { [weak self] (result) in
            switch result {
            case .success(let response, _):
                guard let data = response.resultado else {
                    completion(nil, NetworkError.badResponse(nil))
                    return
                }
                self?.data = data
                self?.accessId = data.idAcceso
                self?.setKeys()
                self?.lastDateQuery = Int64(Date().timeIntervalSince1970)
                completion(data.idAcceso, nil)
            case .failure(let error):
                completion(nil, NetworkError.badResponse(nil))
            }
        }
        
    }
    
    private func setKeys() {
        if let keys = data {
            publicK = try? PublicKey(base64Encoded: keys.accesoPublico)
            privateK = try? PrivateKey(base64Encoded: keys.accesoPrivado)
        }
    }
    
    public func deleteCipher() {
        self.data = nil
        self.lastDateQuery = nil
    }
    
    public func encryptInformation(_ str: String) -> String {
        guard let pk = self.publicK, let clear = try? ClearMessage(string: str, using: .utf8), let encrypted = try? clear.encrypted(with: pk, padding: .PKCS1) else {
            return ""
        }
        return encrypted.base64String
    }
    
    public func decryptInformation(_ str: String) -> String {
        guard let pk = self.privateK, let encrypted = try? EncryptedMessage(base64Encoded: str),
            let clear = try? encrypted.decrypted(with: pk, padding: .PKCS1),
            let string = try? clear.string(encoding: .utf8) else {
                return ""
        }
        return string
    }
    
}
