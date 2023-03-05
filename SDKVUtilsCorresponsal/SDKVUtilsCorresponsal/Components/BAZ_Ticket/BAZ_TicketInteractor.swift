//
//  BAZ_TicketInteractor.swift
//  cal-ios-sdk-deposit
//
//  Created Jorge Cruz on 03/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SDKCUtilsCorresponsal

/// BAZ_Ticket Module Interactor
public class BAZ_TicketInteractor{
    public var _presenter: BAZ_TicketPresenterProtocol?
    private let ticketService = BAZ_TicketWebService()
    
    public init(){}
}

extension BAZ_TicketInteractor: BAZ_TicketInteractorProtocol {
    
    public func fetchTicketInfo() {
        ticketService.request { [weak self] (response, error) in
            
            guard let _ = response else {
                DispatchQueue.main.async {
                    guard let data = error?.genericError().dataResponse else {
                        self?._presenter?.responseFailuerTicketinfo(msg: error?.genericError().message ?? "")
                        return
                    }
                    
                    do{
                        let json = try DictionaryDeserializer().deserialize(data)
                        guard (json["detalles"] as? NSArray)?.componentsJoined(by: ", ") == "" else {
                            self?._presenter?.responseFailuerTicketinfo(msg: (json["detalles"] as? NSArray)?.componentsJoined(by: ", ") ?? "Intente mas tarde")
                            return
                        }
                        
                        self?._presenter?.responseFailuerTicketinfo(msg: (json["mensaje"] as? String ?? "Intente mas tarde"))
                        
                    }catch {
                        self?._presenter?.responseFailuerTicketinfo(msg: "No se pudo obtener una respuesta valida")
                        return
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                self?._presenter?.responseTicketInfo(response: response?.resultado?.decrypt())
            }
        }
    }
}
