//
//  BAZ_GenericTicketView.swift
//  TicketView
//
//  Created by Diego Alejandro Martinez Sanchez on 02/09/21.
//

import UIKit

public class BAZ_GenericTicketView: UIView {
    
    private var headerView      :   BAZ_HeaderGenericTicket!
    private var genericBody     :   BAZ_BodyGenericTicket!
    private var movementsBody   :   BAZ_BodyMovementsTicket!
    private var footerView      :   BAZ_FooterGenericTicket!
    
    private lazy var copyLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var ticketType                  :   Int = 0
    private var consultaMovimientosTicket   :   Int = 5
    
    public init(data: BAZ_TicketResponse, type: BAZ_OptionsMenuType, isACopy: Bool, isElectronicTicket: Bool){
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 350.0, height: 1450))
        self.backgroundColor = UIColor.white
        
        buildComponents(data: data, type: type, isACopy: isACopy, isElectronicTicket: isElectronicTicket)
        buildLayoutComponents()
        
        if ticketType == consultaMovimientosTicket{
            self.updateHeightView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildComponents(data: BAZ_TicketResponse,
                                 type: BAZ_OptionsMenuType,
                                 isACopy: Bool,
                                 isElectronicTicket: Bool){
        
        headerView = BAZ_HeaderGenericTicket(modelData: data, isElectronicTicket: isElectronicTicket)
        footerView = BAZ_FooterGenericTicket(type: data.comercio?.operacion?.idTipo,
                                             isElectronicTicket: isElectronicTicket)
        
        [headerView, copyLabel, footerView].forEach { component in
            self.addSubview(component)
        }
        
        self.ticketType = data.comercio?.operacion?.idTipo ?? 0
        
        if ticketType != consultaMovimientosTicket{
            genericBody = BAZ_BodyGenericTicket(data: data, type: type, isElectronicTicket: isElectronicTicket)
            self.addSubview(genericBody)
        }else{
            movementsBody = BAZ_BodyMovementsTicket(data: data, isElectronicTicket: isElectronicTicket)
            self.addSubview(movementsBody)
        }
    }
    
    private func buildLayoutComponents(){
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            copyLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            copyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            copyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        if ticketType != consultaMovimientosTicket{
            NSLayoutConstraint.activate([
                genericBody.topAnchor.constraint(equalTo: copyLabel.bottomAnchor),
                genericBody.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                genericBody.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                
                footerView.topAnchor.constraint(equalTo: genericBody.bottomAnchor)
            ])
        }else{
            NSLayoutConstraint.activate([
                movementsBody.topAnchor.constraint(equalTo: copyLabel.bottomAnchor),
                movementsBody.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                movementsBody.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                
                footerView.topAnchor.constraint(equalTo: movementsBody.bottomAnchor)
            ])
        }
    }
    
    private func updateHeightView(){
        var heightView  = copyLabel.intrinsicContentSize.height
        heightView += headerView.getSizeView()
        heightView += footerView.getSizeView()
        heightView += movementsBody.getSizeView()
        
        self.frame.size.height = heightView + 450.0
    }
}
