//
//  ApiWsManager.swift
//  AceptaPagoBaz
//
//  Created by David on 14/05/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation

public protocol MiddlewareProtocol {
    var header: [String: String] { get set }
    func excute(module:TokenMiddlewareType, completion: @escaping (NetworkError?) -> Void)
    func remove()
}

open class ApiWsManager {
    public var middleware: MiddlewareProtocol?
    public var restController: RestController?
    public static let shared = ApiWsManager()
    
    private init() {
        guard let baseUrl = SettingServiceManager.shared.base, let makeRestController = RestController.make(urlString: baseUrl) else {
            //"No se pudo iniciar el conttrolador")
            return
        }
        middleware = TokenMiddleware()
        restController = makeRestController
    }
    
    private func evaluateURLRequest (relativeURL: String)->MiddlewareProtocol{
        return middleware!
    }
    
    
    public func makeCall<RESPONSE: Deserializer>(method: EnumRequest, endPoint: String, requestData: EnumType? = nil, responseData: RESPONSE, options: RequestOptions? = nil, module: TokenMiddlewareType = .CORRESPONSALES, isOnboardingKeysService: Bool = false, completion: @escaping (Result<(RESPONSE.ResponseType, HTTPURLResponse), NetworkError>) -> ()) {
        
        var requestOptions: RequestOptions = options != nil ? options! : RequestOptions()
        
        middleware?.excute(module: module) { [weak self] (error) in
            
            // ToDo: GenericError

            if let hasErrorMiddleware = error {
                completion(.failure(hasErrorMiddleware))
            }
            
            guard let strongSelf = self else {return}
            
            
            if let additionalHeaders = self?.evaluateURLRequest(relativeURL: endPoint).header {
                requestOptions.httpHeaders = requestOptions.httpHeaders == nil ? additionalHeaders : requestOptions.httpHeaders!.merging(additionalHeaders) { (current, _) in current }
            }
                        
            switch method {
            case .get, .delete:
                strongSelf.restController?.makeCall(endPoint, httpMethod: method.rawValue, payload: nil, responseDeserializer: responseData, options: requestOptions, module: module) { (result) in
                    completion(result)
                }
            case .post, .put:
                if let getSerializer = requestData?.serializer {
                    strongSelf.restController?.makeCall(endPoint, httpMethod: method.rawValue, requestSerializer: getSerializer, responseDeserializer: responseData, options: requestOptions, module: module) { (result) in
                        completion(result)
                    }
                } else {
                    //"Error serialize data")
                }
            }
        }
        
    }
    
    public func cancelAll() {
        restController?.cancelAllTasks()
    }
    
}
