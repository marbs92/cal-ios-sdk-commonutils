//
//  BAZ_NetworkError.swift
//  SDKCUtilsCorresponsal
//
//  Created by Luis Grano on 02/02/22.
//

import Foundation

public struct ErrorData {
    public let message: String
    public let responseCode: String?
    public let errorCode: String?
    public let invoice: String?
    
    public init(message: String = "",
                responseCode: String? = nil,
                errorCode: String? = nil,
                invoice: String? = nil){
        self.message = message
        self.responseCode = responseCode
        self.errorCode = errorCode
        self.invoice = invoice
    }
}


open class BAZ_NetworkError {
    
    /// Returns true if the provided code is not nil and between 500 and 599
    /// - Parameter responseCode: Response code received from service
    /// - Returns: Bool
    private static func isBackendError(responseCode: String?)-> Bool {
        guard let strResponseCode = (responseCode), let intResponseCode = Int(strResponseCode) else {
            return true
        }
        
        return (intResponseCode >= 500 && intResponseCode <= 599)
    }
    
    
    /// Returns model with error data
    /// - Parameters:
    ///   - error: NetworkError received from service
    ///   - frontendFailure: Closure indicating a frontend failure
    ///   - backendFailure: Closure indicating a backend failure
    public static func getErrorData(error: NetworkError?,
                                    frontendFailure: @escaping (_ frontErrorData: ErrorData) -> (),
                                    backendFailure: @escaping (_ backErrorData: ErrorData) -> ()) {
        /// Obtener respuesta de error
        guard let data = error?.genericError().dataResponse, let responseCode = error?.genericError().statusCode else {
            backendFailure(ErrorData(message: "Servicio no disponible",
                                     responseCode: error?.genericError().statusCode,
                                     errorCode: nil,
                                     invoice: nil))
            return
        }
        
        do{
            let json = try DictionaryDeserializer().deserialize(data)
            
            /// Obtener folio
            let invoice = (json["folio"] as? String)
            
            /// Obtener el código de error
            guard let wholeErrorCode = (json["codigo"] as? String) else {
                backendFailure(ErrorData(message: "No se pudo obtener una respuesta válida",
                                         responseCode: responseCode,
                                         errorCode: nil,
                                         invoice: invoice))
                return
            }
            
            let errorCode = wholeErrorCode.components(separatedBy: ".").last
            
            /// Obtener los detalles del error
            if let responseError = (json["detalles"] as? NSArray), !responseError.componentsJoined(by: ", ").isEmpty {
                let responseErrorDetails = responseError.componentsJoined(by: ", ")
                
                let errorData = ErrorData(message: responseErrorDetails,
                                          responseCode: responseCode,
                                          errorCode:  errorCode,
                                          invoice: invoice)
                
                if self.isBackendError(responseCode: responseCode) {
                    backendFailure(errorData)
                } else {
                    frontendFailure(errorData)
                }
                return
                
                /// Si no se obtuvo los detalles del error, obtener mensaje de error
            } else if let responseErrorMessage = json["mensaje"] as? String, !responseErrorMessage.isEmpty {
                let errorData = ErrorData(message:  responseErrorMessage,
                                          responseCode: responseCode,
                                          errorCode:  errorCode,
                                          invoice: invoice)
                
                if self.isBackendError(responseCode: responseCode) {
                    backendFailure(errorData)
                } else {
                    frontendFailure(errorData)
                }
                return
            } else {
                /// Si no se obtuvieron detalles de error, ni mensaje de error
                backendFailure(ErrorData(message: "No se pudo obtener una respuesta válida",
                                         responseCode: responseCode,
                                         errorCode:  errorCode,
                                         invoice: invoice))
            }
        } catch {
            /// Fallo parseo json
            backendFailure(ErrorData(message: "No se pudo obtener una respuesta válida",
                                     responseCode: responseCode,
                                     errorCode: nil,
                                     invoice: nil))
            return
        }
    }
    
    
    public static func getErrorData(error: NetworkError?) -> ErrorData {
        guard let data = error?.genericError().dataResponse, let responseCode = error?.genericError().statusCode else {
            return ErrorData(message: "Servicio no disponible",
                             responseCode: error?.genericError().statusCode,
                             errorCode: nil,
                             invoice: nil)
        }
        
        do{
            let json = try DictionaryDeserializer().deserialize(data)
            
            let invoice = (json["folio"] as? String)
            
            guard let responseError = (json["detalles"] as? NSArray), let errorCode = (json["codigo"] as? String) else {
                return ErrorData(message: "No se pudo obtener una respuesta válida",
                                 responseCode: responseCode,
                                 errorCode: nil,
                                 invoice: invoice)
            }
            
            let responseErrorDetails = responseError.componentsJoined(by: ", ")
            
            if !responseErrorDetails.isEmpty {
                return ErrorData(message: responseErrorDetails,
                                 responseCode: responseCode,
                                 errorCode:  errorCode.components(separatedBy: ".").last,
                                 invoice: invoice)
            } else {
                guard let responseErrorMessage = json["mensaje"] as? String else {
                    return ErrorData(message: "No se pudo obtener una respuesta válida",
                                     responseCode: responseCode,
                                     errorCode:  errorCode.components(separatedBy: ".").last,
                                     invoice: invoice)
                }
                return ErrorData(message:  responseErrorMessage,
                                 responseCode: responseCode,
                                 errorCode:  errorCode.components(separatedBy: ".").last,
                                 invoice: invoice)
            }
        } catch {
            return ErrorData(message: "No se pudo obtener una respuesta válida",
                             responseCode: responseCode,
                             errorCode: nil,
                             invoice: nil)
        }
    }
}
