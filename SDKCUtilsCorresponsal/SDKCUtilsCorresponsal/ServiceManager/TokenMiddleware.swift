//
//  TokenMiddleware.swift
//  AceptaPagoBaz
//
//  Created by David on 14/05/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation
public enum TokenMiddlewareType {
    case ACEPTAPAGO
    case CORRESPONSALES
    
    func getHost() -> String? {
        switch self {
        case .ACEPTAPAGO:
            return SettingServiceManager.shared.host
        case .CORRESPONSALES:
            return SettingServiceManager.shared.host
        }
    }
}

open class TokenMiddleware: MiddlewareProtocol {
    public var header: [String : String] = [String : String]()
    private var aceptapagoHeader: [String : String] = [String : String]()
    private var corresponsalHeader: [String : String] = [String : String]()
    private var response: TokenResponse? = nil
    private var lastDateQueryAceptapago: Int64? = nil
    private var lastDateQueryCorresponsales: Int64? = nil
    public var oauthHeader: String = ""
    private var requestEnqueue: [DispatchWorkItem] = []
    private var isTokenRefreshing: Bool = false
    
    public init() {
        guard let data = SettingServiceManager.shared.valToken else{ return }
        let concatUP = "\(data)".data(using: .utf8)!
        oauthHeader = concatUP.base64EncodedString()
    }
    
    private func getToken(module: TokenMiddlewareType, completion: @escaping (NetworkError?) -> Void) {
        
        
        let endpoint = SettingServiceManager.shared.token
        
        var restOptions = RequestOptions()
        var requestArr = [String: String]()
        
        if module == .CORRESPONSALES {
            guard let host = SettingServiceManager.shared.host, let makeRestController = RestController.make(urlString: "\(host)") else {
                //"No se pudo iniciar el conttrolador")
                completion(.badURL)
                return
            }
            
            restOptions.httpHeaders = ["Authorization": "Basic \(SettingServiceManager.shared.valToken ?? "")", "Content-Type": "application/x-www-form-urlencoded"]
            requestArr = ["grant_type": "client_credentials"]
            makeRestController.makeCall(endpoint, httpMethod: "POST", requestSerializer: DictionaryQuerySerializer(data: requestArr), responseDeserializer: DecodableDeserializer<TokenResponse>(), options: restOptions) { [weak self] (result) in
                switch result {
                case .success(let data, _):
                    self?.lastDateQueryCorresponsales = Int64(Date().timeIntervalSince1970)
                    self?.response = data
                    self?.corresponsalHeader["Authorization"] = "Bearer \(self?.response?.accessToken ?? "")"
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
        
        if module == .ACEPTAPAGO {
            guard let host = SettingServiceManager.shared.host, let makeRestController = RestController.make(urlString: "\(host)") else {
                //"No se pudo iniciar el conttrolador")
                completion(.badURL)
                return
            }
            
            restOptions.httpHeaders = ["Authorization": "Basic \(SettingServiceManager.shared.valToken ?? "")", "Content-Type": "application/x-www-form-urlencoded"]
            requestArr = ["grant_type": "client_credentials"]
            makeRestController.makeCall(endpoint, httpMethod: "POST", requestSerializer: DictionaryQuerySerializer(data: requestArr), responseDeserializer: DecodableDeserializer<TokenResponse>(), options: restOptions) { [weak self] (result) in
                switch result {
                case .success(let data, _):
                    self?.lastDateQueryAceptapago = Int64(Date().timeIntervalSince1970)
                    self?.response = data
                    self?.aceptapagoHeader["Authorization"] = "Bearer \(self?.response?.accessToken ?? "")"
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
        
    private func isValidTokenAceptapago() -> Bool {
        guard let response = self.response, let lastDate = lastDateQueryAceptapago else { return false }
        let currentDate = Int64(Date().timeIntervalSince1970)
        let dateExpirationToken = Int64(response.expiresIn) ?? 0
        return (lastDate + dateExpirationToken > currentDate)
    }
    
    private func isValidTokenCorresponsal() -> Bool {
        guard let response = self.response, let lastDate = lastDateQueryCorresponsales else { return false }
        let currentDate = Int64(Date().timeIntervalSince1970)
        let dateExpirationToken = Int64(response.expiresIn) ?? 0
        return (lastDate + dateExpirationToken > currentDate)
    }
    
        
    public func excute(module: TokenMiddlewareType, completion: @escaping (NetworkError?) -> Void) {
        if isTokenRefreshing {
            saveRequest {
                completion(nil)
            }
            return
        }
        
        var validToken = false
        if module == .ACEPTAPAGO{
            validToken = isValidTokenAceptapago()
        }else if module == .CORRESPONSALES{
            validToken = isValidTokenCorresponsal()
        }
        
        if !validToken {
            isTokenRefreshing = true
            saveRequest {
                completion(nil)
            }
            self.getToken(module: module) { [unowned self] (error) in
                switch module {
                case .ACEPTAPAGO:
                    header = aceptapagoHeader
                case .CORRESPONSALES:
                    header = corresponsalHeader
                }
                self.isTokenRefreshing = false
                self.executeAllSavedRequests()
            }
        } else {
            switch module {
            case .ACEPTAPAGO:
                header = aceptapagoHeader
            case .CORRESPONSALES:
                header = corresponsalHeader
            }
            completion(nil)
        }
        
    }

    private func saveRequest(_ block: @escaping () -> Void) {
        self.requestEnqueue.append( DispatchWorkItem {
            block()
        })
    }

    private func executeAllSavedRequests() {
        requestEnqueue.forEach({ DispatchQueue.global().async(execute: $0) })
        requestEnqueue.removeAll()
    }
    
    public func remove() {
        response = nil
        lastDateQueryAceptapago = nil
        lastDateQueryCorresponsales = nil
    }
    
}


struct TokenResponse: Codable {
    let clientId: String
    let accessToken: String
    let expiresIn: String
    let refreshCount: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshCount = "refresh_count"
        case status = "status"
    }
}
