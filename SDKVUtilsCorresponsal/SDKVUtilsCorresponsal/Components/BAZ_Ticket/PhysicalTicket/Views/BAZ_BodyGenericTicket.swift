//
//  BAZ_BodyGenericTicket.swift
//  baz-ios-akpago-utils
//
//  Created by Gustavo Tellez on 07/09/21.
//

import UIKit

internal class BAZ_BodyGenericTicket: UIView {
    
    private lazy var titleText: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Operación:"
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var operationDescription: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackFirst: UIStackView = {
        let stackFirst = UIStackView(frame: .zero)
        stackFirst.axis = .vertical
        stackFirst.spacing = 5
        stackFirst.translatesAutoresizingMaskIntoConstraints = false
        return stackFirst
    }()
    
    private lazy var amountText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var heightStackView : CGFloat = 0.0
    private var spacing : CGFloat = 0.0
    
    public init(data: BAZ_TicketResponse, type: BAZ_OptionsMenuType, isElectronicTicket: Bool){
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints = false
        
        buildComponents(data: data, type: type, isElectronicTicket: isElectronicTicket)
        buildLayoutComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildComponents(data: BAZ_TicketResponse, type: BAZ_OptionsMenuType, isElectronicTicket: Bool){
        
        self.spacing = isElectronicTicket ? 15.0 : 0.0
        
        let transactionType = data.comercio?.operacion?.descripcionTipo ?? ""
        let autBank = data.folioBanco ?? "##"
        let folioAdmin = data.folioAdministrador ?? "##"
        let idTransaction = data.comercio?.operacion?.id ?? ""
        let typePay = data.descripcionReferencia ?? "Referencia"
        let date = data.fechaHora ?? ""
        let lastNumbersCard = (data.numeroReferencia ?? "").formattedByTicket(characterToReplace: "*")
        let commission = data.comision?.priceUnDecorative() ?? "0.00"
        let ivaCommision = data.iva?.priceUnDecorative() ?? "0.00"
        let total = data.montoTotal?.priceUnDecorative() ?? "0.00"
        
        var fullAmount = data.descripcionMontoTotal?.uppercased() ?? ""
        if fullAmount == ""{
            fullAmount = total.convertAmountToString()
        }
        
        var importN     = ""
        var description = ""
        
        if type == .ConsultaSaldo ||
            (type == .OperationHistory &&
             transactionType.range(of: "saldo", options: .caseInsensitive) != nil){
            
            importN = data.saldo?.priceUnDecorative() ?? "0.0"
            description = "Saldo"
            
        }else{
            importN = data.monto?.priceUnDecorative() ?? "0.0"
            description = "Importe"
        }
        
        operationDescription.text = transactionType.capitalized
        amountText.text = "(\(fullAmount.capitalized))"
        
        for (i,x) in [["#Aut. Banco", autBank],
                      ["ID Transacción",idTransaction],
                      ["#Folio Admin", folioAdmin],
                      ["\(typePay.capitalized)", lastNumbersCard],
                      ["Fecha y hora", date],
                      [description, importN.priceDecorative()],
                      ["Comisión", commission.priceDecorative()],
                      ["IVA Comisión", ivaCommision.priceDecorative()],
                      ["Total", total.priceDecorative()]].enumerated(){
            
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let title = UILabel(frame: .zero)
            title.textAlignment = .left
            title.translatesAutoresizingMaskIntoConstraints = false
            title.text = x[0]
            title.font =  UIFont.boldSystemFont(ofSize: i == 8 ? 24 : 16)
            title.textColor = UIColor.black
            
            let description = UILabel(frame: .zero)
            description.textAlignment = .right
            description.minimumScaleFactor = 0.6
            description.adjustsFontSizeToFitWidth = true
            description.translatesAutoresizingMaskIntoConstraints = false
            description.text = x[1]
            description.font = UIFont.boldSystemFont(ofSize: i == 8 ? 24 : 16)
            description.textColor = UIColor.black
            
            view.addSubview(title)
            view.addSubview(description)
            
            heightStackView += description.intrinsicContentSize.height + 5.0
            
            NSLayoutConstraint.activate([
                title.topAnchor.constraint(equalTo: view.topAnchor),
                title.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                description.topAnchor.constraint(equalTo: view.topAnchor),
                description.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 5),
                description.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                description.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                title.heightAnchor.constraint(equalTo: description.heightAnchor),
                title.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4, constant: 0)
            ])
            if  x.last != "" {
                stackFirst.addArrangedSubview(view)
            }
        }
        
        [titleText, operationDescription, stackFirst, amountText].forEach { component in
            self.addSubview(component)
        }
    }
    
    private func buildLayoutComponents(){
        NSLayoutConstraint.activate([
            titleText.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0),
            titleText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            titleText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            
            operationDescription.topAnchor.constraint(equalTo: titleText.bottomAnchor),
            operationDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            operationDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            
            stackFirst.topAnchor.constraint(equalTo: operationDescription.bottomAnchor, constant: 40.0),
            stackFirst.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            stackFirst.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            
            amountText.topAnchor.constraint(equalTo: stackFirst.bottomAnchor),
            amountText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            amountText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            amountText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20.0)
        ])
    }
    
    func getSizeView() -> CGFloat{
        let spacingComponents : CGFloat = 80.0
        var size = spacingComponents
        size += titleText.intrinsicContentSize.height
        size += operationDescription.intrinsicContentSize.height
        size += heightStackView
        size += amountText.intrinsicContentSize.height
        
        return size
    }
}
