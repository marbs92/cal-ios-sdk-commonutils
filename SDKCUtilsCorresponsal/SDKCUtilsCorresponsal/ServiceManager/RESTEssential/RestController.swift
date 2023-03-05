//
//  RestController.swift
//  RestEssentials
//
//  Created by Sean Kosanovich on 6/7/15.
//  Copyright © 2017 Sean Kosanovich. All rights reserved.
//

#if os(iOS) || os(watchOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
extension URL {
    
    func appending(_ queryItem: String, value: String?) -> URL {
        
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        
        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)
        
        // Append the new query item in the existing query items array
        queryItems.append(queryItem)
        
        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems
        
        // Returns the url from new url components
        return urlComponents.url!
    }
}

/// Errors related to the networking for the `RestController`
public enum NetworkingError: Error {
    /// Indicates the server responded with an unexpected status code.
    /// - parameter Int: The status code the server respodned with.
    /// - parameter Data?: The raw returned data from the server
    case unexpectedStatusCode(Int, Data?)
    
    /// Indicates that the server responded using an unknown protocol.
    /// - parameter Data?: The raw returned data from the server
    case badResponse(Data?)
    
    /// Indicates the server's response could not be deserialized using the given Deserializer.
    /// - parameter Data: The raw returned data from the server
    case malformedResponse(Data)
    
    /// Inidcates the server did not respond to the request.
    case noResponse
}


/// Allows users to create HTTP REST networking calls that deal with JSON.
///
/// **NOTE:** If running on iOS 9.0+ then ensure to configure `App Transport Security` appropriately.
public class RestController : NSObject, URLSessionDelegate {
    
    //    fileprivate let kDefaultRequestTimeout = 60 as TimeInterval
    private static let kJsonType = "application/json"
    private static let kContentType = "Content-Type"
    private static let kAcceptKey = "Accept"
    //    private static let kDefaultStatusCode: Int? = 200
    private static var defaultSession = URLSessionConfiguration.default
    
    private let url: URL
    private var session: URLSession
    
    /// If set to *true*, then self signed SSL certificates will be accepted from the **SAME** host only.
    ///
    /// If you are making a request to *https://foo.com* and you get redirected to *https://bar.com* (where bar.com uses a self signed SSL certificate), then the request will fail; as the SSL host of *bar.com* does not match the intended host of *foo.com*.
    ///
    /// **NOTE:** If running on iOS 9.0+ then ensure to configure `App Transport Security` appropriately.
    public var acceptSelfSignedCertificate = true
    
    private init(url: URL) {
        self.url = url
        self.session = Foundation.URLSession.shared
    }
    
    /// Creates a new `RestController` for the given URL endpoint.
    ///
    /// **NOTE:** If running on iOS 9.0+ then ensure to configure `App Transport Security` appropriately for the server.
    /// - parameter urlString: The URL of the server to send requests to.
    /// - returns: If the given URL string represents a valid `URL`, then a `RestController` for the URL will be returned; it not then `nil` will be returned.
    public static func make(urlString: String) -> RestController? {
        if let validURL = URL(string: urlString) {
            return make(url: validURL)
        }
        
        return nil
    }
    
    /// Creates a new `RestController` for the given URL endpoint.
    ///
    /// **NOTE:** If running on iOS 9.0+ then ensure to configure `App Transport Security` appropriately for the server.
    /// - parameter url: The URL of the server to send requests to.
    /// - returns: A `RestController` for the given URL.
    public static func make(url: URL) -> RestController {
        let restController = RestController(url: url)
        restController.session = Foundation.URLSession(configuration: defaultSession, delegate: restController, delegateQueue: nil)
        return restController
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        //        let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        //        completionHandler(.useCredential, credential);
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust), let serverTrust = challenge.protectionSpace.serverTrust {
            var secresult = SecTrustResultType.invalid
            let status = SecTrustEvaluate(serverTrust, &secresult)
            
            if (errSecSuccess == status) , let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                let serverCertificateData = SecCertificateCopyData(serverCertificate)
                let data = CFDataGetBytePtr(serverCertificateData);
                let size = CFDataGetLength(serverCertificateData);
                let cert1 = NSData(bytes: data, length: size)

                let file_der =
                
                
                [ NSData(contentsOfFile:Bundle.init(for: ApiWsManager.self).path(forResource: "prod.bancoazteca.com", ofType: "der") ?? ""),
                  NSData(contentsOfFile:Bundle.init(for: ApiWsManager.self).path(forResource: "aztecadev.directo.com", ofType: "der") ?? ""),
                  NSData(contentsOfFile:Bundle.init(for: ApiWsManager.self).path(forResource: "pre.qa-aceptapagobaz.com", ofType: "der") ?? ""),
                  NSData(contentsOfFile:Bundle.init(for: ApiWsManager.self).path(forResource: "dev.aws.com", ofType: "der") ?? ""),
                  NSData(contentsOfFile:Bundle.init(for: ApiWsManager.self).path(forResource: "Prod.apigeebaz.com", ofType: "der") ?? ""),
                  //falta qaaztecaimagen
                  NSData(contentsOfFile:Bundle.init(for: ApiWsManager.self).path(forResource: "qa.aztecasms.com", ofType: "der") ?? ""),
                  NSData(contentsOfFile:Bundle.init(for: ApiWsManager.self).path(forResource: "prod.apibaz.com", ofType: "der") ?? ""),
                  NSData(contentsOfFile:Bundle.init(for: ApiWsManager.self).path(forResource: "qa.apibaz.com", ofType: "der") ?? ""),
                  NSData(contentsOfFile:Bundle.init(for: ApiWsManager.self).path(forResource: "bancoazteca.com", ofType: "der") ?? ""),
                ]
                
                if file_der.contains(where: { $0 == cert1 }) {
                    completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
                    return
                }
                completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
            }
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        }
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
    

    private func evaluateURLRequest (relativeURL: String) -> URL? {
        let host = SettingServiceManager.shared.host ?? ""
        
        guard let url = (URL(string: host)?.appendingPathComponent(relativeURL)) else {
            return nil
        }
        
        return url
    }

    private func dataTask(relativePath: String?, httpMethod: String, accept: String, payload: Data?, options: RequestOptions, module: TokenMiddlewareType = .CORRESPONSALES, callback: @escaping (Result<(Data, HTTPURLResponse), NetworkError>) -> ()) {
        var restURL: URL;
        if let relativeURL = relativePath {
            guard let nonNilURL = evaluateURLRequest(relativeURL: relativeURL) else {
                callback(.failure(NetworkError.badURL))
                return
            }

            restURL = nonNilURL
            
            
        } else {
            restURL = url
        }
        for item in options.queryParams {
            restURL = restURL.appending(item.key, value: "\(item.value)")
        }

        var request = URLRequest(url: restURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData , timeoutInterval: options.requestTimeoutSeconds)
        request.httpMethod = httpMethod
        
        request.setValue(accept, forHTTPHeaderField: RestController.kAcceptKey)
        if let customHeaders = options.httpHeaders {
            for (httpHeaderKey, httpHeaderValue) in customHeaders {
                request.setValue(httpHeaderValue, forHTTPHeaderField: httpHeaderKey)
            }
        }
        
        if let payloadToSend = payload {
            if request.allHTTPHeaderFields?[RestController.kContentType] == nil {
                request.setValue(RestController.kJsonType, forHTTPHeaderField: RestController.kContentType)
            }
            request.httpBody = payloadToSend
        }

        #if os(iOS)
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        #endif

        #if DEBUG
            RestController.log(request: request)
        #endif
        if #available(iOS 13.0, *) {
            session.configuration.tlsMinimumSupportedProtocolVersion = .DTLSv12
        } else {
            session.configuration.tlsMinimumSupportedProtocol = .tlsProtocol12
        }
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierListeningResetTimeOut"), object: nil)
        session.configuration.urlCache = nil
        session.dataTask(with: request) { (data, response, error) -> Void in
            #if os(iOS)
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            #endif

            #if DEBUG
            if let responseURL = response as? HTTPURLResponse {
                RestController.log(data: data, response: responseURL, error: error)
            }
            #endif

            if let _ = error {
                callback(.failure(NetworkError.badResponse(data)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                callback(.failure(NetworkError.badResponse(data)))
                return
            }

            if httpResponse.statusCode != 200 && httpResponse.statusCode != 201 {
                callback(.failure(NetworkError.unexpectedStatusCode(httpResponse.statusCode, data)))
                return
            }

            guard let returnedData = data else {
                callback(.failure(NetworkError.noResponse))
                return
            }
            
            callback(.success((returnedData, httpResponse)))
        }.resume()
    }
    
    public func makeCall<T: Deserializer>(_ relativePath: String? = nil, httpMethod: String, payload: Data?, responseDeserializer: T, options: RequestOptions, module: TokenMiddlewareType = .CORRESPONSALES, callback: @escaping (Result<(T.ResponseType, HTTPURLResponse), NetworkError>) -> ()) {
        
        dataTask(relativePath: relativePath, httpMethod: httpMethod, accept: responseDeserializer.acceptHeader, payload: payload, options: options, module: module) { result in
            switch result {
            case .success(let data, let urlResponse):
                guard let transformedResponse = try? responseDeserializer.deserialize(data) else {
                    callback(.failure(NetworkError.malformedResponse(data)))
                    return
                }
                callback(.success((transformedResponse, urlResponse)))
            case .failure(let error):
                callback(.failure(error))
            }
        }
        
    }
    
    public func makeCall<T: Deserializer>(_ relativePath: String? = nil, httpMethod: String, requestSerializer: Serializer, responseDeserializer: T, options: RequestOptions, module: TokenMiddlewareType = .CORRESPONSALES, callback: @escaping (Result<(T.ResponseType, HTTPURLResponse), NetworkError>) -> ()) {
        let payload = requestSerializer.serialize()
        self.makeCall(relativePath, httpMethod: httpMethod, payload: payload, responseDeserializer: responseDeserializer, options: options, module: module) { (result) in
            callback(result)
        }
    }
    
    public func cancelAllTasks() {
        session.getAllTasks { (tasks) in
            for task in tasks {
                task.cancel()
            }
        }
    }
    
    private class func log(request: URLRequest){

        let urlString = request.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)

        let method = request.httpMethod != nil ? "\(request.httpMethod!)": ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"

        var requestLog = "\n---------- REQUEST ---------->\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = request.httpBody{
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
            requestLog += "\n\(bodyString)\n"
        }

        requestLog += "\n------------------------->\n";
        printService(requestLog)
    }

    private class func log(data: Data?, response: HTTPURLResponse?, error: Error?){

        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")

        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"

        var responseLog = "\n<---------- RESPONSE ----------\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }

        if let statusCode =  response?.statusCode{
            responseLog += "HTTP \(statusCode) \(path)?\(query)\n"
        }
        if let host = components?.host{
            responseLog += "Host: \(host)\n"
        }
        for (key,value) in response?.allHeaderFields ?? [:] {
            responseLog += "\(key): \(value)\n"
        }
        if let body = data{
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
            responseLog += "\n\(bodyString)\n"
        }
        if let error = error{
            responseLog += "\nError: \(error.localizedDescription)\n"
        }

        responseLog += "<------------------------\n";
        printService(responseLog)
    }
}
