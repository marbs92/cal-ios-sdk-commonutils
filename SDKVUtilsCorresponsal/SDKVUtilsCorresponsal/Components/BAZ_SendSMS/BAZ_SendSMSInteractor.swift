//
//  BAZ_SendSMSInteractor.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 14/12/21.
//

import UIKit
import SDKCUtilsCorresponsal

class BAZ_SendSMSInteractor{
    var presenter: BAZ_SendSMSPresenterProtocol?
    let sendSMSService: BAZ_SendSMSWebService = BAZ_SendSMSWebService()
    let changeImageUrlService: BAZ_ChangeImageUrlWebService = BAZ_ChangeImageUrlWebService()
}

extension BAZ_SendSMSInteractor: BAZ_SendSMSInteractorProtocol {
    public func getCampAux() -> String {
        let length = 15
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz"
        let randomString = String((0..<length).map{ _ in letters.randomElement()! })
        return randomString
    }
    
    func postSMS(phoneNumber: Int, amount: Double, ticketImage: UIImage, ticketID: String, ticketType: SMSTicketType, customMessage: String?,flujoArchivo:Int?){
        BAZ_SendSMSServices.shared.setConfig()
        if flujoArchivo == 1 {
            let request = BAZ_ChangeImageUrlRequest(
                idDispositivo: UIDevice.current.getDeviceByPlatform(),
                idUsuario: KeychainManager.shared.getValue(forKey: UserCPKeystore.idUserOperator.rawValue) ?? "",
                comprobante: BAZ_ChangeImageUrlRequest.__Comprobante(
                    id: ticketID,
                    urlImagen: ticketID))
            
            self.changeImageUrlService.request(data: request.cipher()) { response, error in
                guard let newUrlImage = response?.resultado else {
                    DispatchQueue.main.async {
                        
                        guard let data = error?.genericError().dataResponse else {
                            self.presenter?.responseError(msg: error?.genericError().message ?? "")
                            return
                        }
                        
                        do{
                            let json = try DictionaryDeserializer().deserialize(data)
                            
                            guard (json["detalles"] as? NSArray)?.componentsJoined(by: ", ") == "" else {
                                self.presenter?.responseError(msg: (json["detalles"] as? NSArray)?.componentsJoined(by: ", ") ?? "Intente mas tarde")
                                return
                            }
                            
                            self.presenter?.responseError(msg: (json["mensaje"] as? String ?? "Intente mas tarde"))
                        }catch {
                            self.presenter?.responseError(msg: "No se pudo obtener una respuesta valida")
                            return
                        }
                    }
                    return
                }
                
                let newUrl = newUrlImage.comprobante?.urlConsulta
                let vigencia = newUrlImage.comprobante?.vigencia
                
                var message = ""
                
                if let nonNilCustomMessage = customMessage {
                    switch ticketType {
                    case .Transaction:
                        message = "\(nonNilCustomMessage)" + "\n" + " Comprobante: \(newUrl ?? "") Vigencia \(vigencia ?? "") días"
                    case .Rejection:
                        message = "\(nonNilCustomMessage)" + "\n" + "\(newUrl ?? "")"
                    }
                } else {
                    switch ticketType {
                    case .Transaction:
                        message = "Su pago por \(amount.formatAsMoney()) ha sido realizado correctamente." + "\n" + "Para visualizar su ticket de compra dé click al siguiente enlace:" + "\n" + "\(newUrl ?? "")"
                    case .Rejection:
                        message = "La transacción no fue realizada correctamente." + "\n" + "Para visualizar su ticket de rechazo dé click al siguiente enlace:" + "\n" + "\(newUrl ?? "")"
                    }
                }
                
                
                let request = BAZ_SendSMSRequest(user: "BAZTECA_CORRESP",
                                                 password: "5*GU:sDxz-",
                                                 number: "\(phoneNumber)",
                                                 message: "\(message)",
                                                 camp_aux: self.getCampAux(),
                                                 test_mode: false)
                
                self.sendSMSService.request(data: request) { response, error in
                    
                    guard let nonNilResponse = response else{
                        DispatchQueue.main.async {
                            
                            guard let data = error?.genericError().dataResponse else {
                                self.presenter?.responseError(msg: error?.genericError().message ?? "")
                                return
                            }
                            
                            do{
                                let json = try DictionaryDeserializer().deserialize(data)
                                
                                guard (json["detalles"] as? NSArray)?.componentsJoined(by: ", ") == "" else {
                                    self.presenter?.responseError(msg: (json["detalles"] as? NSArray)?.componentsJoined(by: ", ") ?? "Intente mas tarde")
                                    return
                                }
                                
                                self.presenter?.responseError(msg: (json["mensaje"] as? String ?? "Intente mas tarde"))
                            }catch {
                                self.presenter?.responseError(msg: "No se pudo obtener una respuesta valida")
                                return
                            }
                        }
                        return
                    }
                    
                    self.presenter?.responseSuccess(msg: nonNilResponse.description ?? "SMS enviado exitosamente")
                }
            }
        //folio en vez de url
        }else {
            BAZ_FirebaseManager.shared.uploadMedia(img: ticketImage, phoneNumber: String(phoneNumber), ticketID: ticketID) { response in
                guard let url = response else {
                    self.presenter?.responseError(msg: "No se pudo obtener una respuesta valida")
                    return
                }
                
                let request = BAZ_ChangeImageUrlRequest(
                    idDispositivo: UIDevice.current.getDeviceByPlatform(),
                    idUsuario: KeychainManager.shared.getValue(forKey: UserCPKeystore.idUserOperator.rawValue) ?? "",
                    comprobante: BAZ_ChangeImageUrlRequest.__Comprobante(
                        id: ticketID,
                        urlImagen: url))
                
                self.changeImageUrlService.request(data: request.cipher()) { response, error in
                    guard let newUrlImage = response?.resultado else {
                        DispatchQueue.main.async {
                            
                            guard let data = error?.genericError().dataResponse else {
                                self.presenter?.responseError(msg: error?.genericError().message ?? "")
                                return
                            }
                            
                            do{
                                let json = try DictionaryDeserializer().deserialize(data)
                                
                                guard (json["detalles"] as? NSArray)?.componentsJoined(by: ", ") == "" else {
                                    self.presenter?.responseError(msg: (json["detalles"] as? NSArray)?.componentsJoined(by: ", ") ?? "Intente mas tarde")
                                    return
                                }
                                
                                self.presenter?.responseError(msg: (json["mensaje"] as? String ?? "Intente mas tarde"))
                            }catch {
                                self.presenter?.responseError(msg: "No se pudo obtener una respuesta valida")
                                return
                            }
                        }
                        return
                    }
                    
                    let newUrl = newUrlImage.comprobante?.urlConsulta
                    let vigencia = newUrlImage.comprobante?.vigencia
                    
                    var message = ""
                    
                    if let nonNilCustomMessage = customMessage {
                        switch ticketType {
                        case .Transaction:
                            message = "\(nonNilCustomMessage)" + "\n" + " Comprobante: \(newUrl ?? "") Vigencia \(vigencia ?? "") días"
                        case .Rejection:
                            message = "\(nonNilCustomMessage)" + "\n" + "\(newUrl ?? "")"
                        }
                    } else {
                        switch ticketType {
                        case .Transaction:
                            message = "Su pago por \(amount.formatAsMoney()) ha sido realizado correctamente." + "\n" + "Para visualizar su ticket de compra dé click al siguiente enlace:" + "\n" + "\(newUrl ?? "")"
                        case .Rejection:
                            message = "La transacción no fue realizada correctamente." + "\n" + "Para visualizar su ticket de rechazo dé click al siguiente enlace:" + "\n" + "\(newUrl ?? "")"
                        }
                    }
                    
                    
                    let request = BAZ_SendSMSRequest(user: "BAZTECA_CORRESP",
                                                     password: "5*GU:sDxz-",
                                                     number: "\(phoneNumber)",
                                                     message: "\(message)",
                                                     camp_aux: self.getCampAux(),
                                                     test_mode: false)
                    
                    self.sendSMSService.request(data: request) { response, error in
                        
                        guard let nonNilResponse = response else{
                            DispatchQueue.main.async {
                                
                                guard let data = error?.genericError().dataResponse else {
                                    self.presenter?.responseError(msg: error?.genericError().message ?? "")
                                    return
                                }
                                
                                do{
                                    let json = try DictionaryDeserializer().deserialize(data)
                                    
                                    guard (json["detalles"] as? NSArray)?.componentsJoined(by: ", ") == "" else {
                                        self.presenter?.responseError(msg: (json["detalles"] as? NSArray)?.componentsJoined(by: ", ") ?? "Intente mas tarde")
                                        return
                                    }
                                    
                                    self.presenter?.responseError(msg: (json["mensaje"] as? String ?? "Intente mas tarde"))
                                }catch {
                                    self.presenter?.responseError(msg: "No se pudo obtener una respuesta valida")
                                    return
                                }
                            }
                            return
                        }
                        
                        self.presenter?.responseSuccess(msg: nonNilResponse.description ?? "SMS enviado exitosamente")
                    }
                }
                
            } failure: { error in
                self.presenter?.responseError(msg: "No se pudo obtener una respuesta valida")
            }
        }
    }
}
