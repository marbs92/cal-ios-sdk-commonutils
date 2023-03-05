//
//  BAZ_BackendAlertInteractor.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 24/11/21.
//

import Foundation
import SDKCUtilsCorresponsal

public class BAZ_BackendAlertInteractor{
    public weak var presenter: BAZ_BackendAlertPresenterProtocol?
    private let ticketStatusService = BAZ_TicketStatusWebService()
}

extension BAZ_BackendAlertInteractor: BAZ_BackendAlertInteractorProtocol{
    
    func fetchTicketStatus() {
        ticketStatusService.request { [weak self] (response, error) in
            
            guard let _ = response else {
                DispatchQueue.main.async {
                    guard let data = error?.genericError().dataResponse else {
                        self?.presenter?.responseFailuerTicketStatus(msg: error?.genericError().message ?? "")
                        return
                    }
                    
                    do{
                        let json = try DictionaryDeserializer().deserialize(data)
                        guard (json["detalles"] as? NSArray)?.componentsJoined(by: ", ") == "" else {
                            self?.presenter?.responseFailuerTicketStatus(msg: (json["detalles"] as? NSArray)?.componentsJoined(by: ", ") ?? "Intente mas tarde")
                            return
                        }
                        
                        self?.presenter?.responseFailuerTicketStatus(msg: (json["mensaje"] as? String ?? "Intente mas tarde"))
                        
                    }catch {
                        self?.presenter?.responseFailuerTicketStatus(msg: "No se pudo obtener una respuesta valida")
                        return
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.presenter?.responseTicketStatus(response: response?.resultado?.decrypt())
            }
        }
    }
}
