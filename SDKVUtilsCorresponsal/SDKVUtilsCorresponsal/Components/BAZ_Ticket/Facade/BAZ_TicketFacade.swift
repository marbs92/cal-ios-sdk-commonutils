//
//  BAZ_TicketFacade.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 10/01/22.
//

import UIKit
import SDKCUtilsCorresponsal

open class BAZ_TicketFacade{
    
    public static let shared = BAZ_TicketFacade()
    
    private let ticketService = BAZ_TicketWebService()
    
    public func fetchTicketInfo(idTicket: String,
                                success: @escaping (_ response: BAZ_TicketResponse?) -> (),
                                failure: @escaping (_ error: String) -> ()){
        
        BAZ_Tickets.shared.entity?.idTicket = idTicket
        BAZ_Tickets.shared.setConfig()
        
        ticketService.request { (response, error) in
            
            guard let _ = response else {
                DispatchQueue.main.async {
                    guard let data = error?.genericError().dataResponse else {
                        failure(error?.genericError().message ?? "")
                        return
                    }
                    
                    do{
                        let json = try DictionaryDeserializer().deserialize(data)
                        guard (json["detalles"] as? NSArray)?.componentsJoined(by: ", ") == "" else {
                            let errorMessage = (json["detalles"] as? NSArray)?.componentsJoined(by: ", ") ?? "Intente mas tarde"
                            failure(errorMessage)
                            return
                        }
                        
                        failure(json["mensaje"] as? String ?? "Intente mas tarde")
                        
                    }catch {
                        failure("No se pudo obtener una respuesta valida")
                        return
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                success(response?.resultado?.decrypt())
            }
        }
    }
}
