//
//  BAZ_BodyMovementsTicket.swift
//  baz-ios-akpago-utils
//
//  Created by Gustavo Tellez on 07/09/21.
//

import UIKit

class BAZ_BodyMovementsTicket: UIView {
    
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
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackSecond: UIStackView = {
        let stackSecond = UIStackView(frame: .zero)
        stackSecond.axis = .vertical
        stackSecond.spacing = 5
        stackSecond.translatesAutoresizingMaskIntoConstraints = false
        return stackSecond
    }()
    
    private lazy var stackThird: UIStackView = {
        let stackSecond = UIStackView(frame: .zero)
        stackSecond.axis = .vertical
        stackSecond.spacing = 5
        stackSecond.translatesAutoresizingMaskIntoConstraints = false
        return stackSecond
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
    
    private var heightStacksView : CGFloat = 0.0
    private var spacing : CGFloat = 0.0
    
    public init(data: BAZ_TicketResponse, isElectronicTicket: Bool){
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints = false
        
        buildComponents(data: data, isElectronicTicket: isElectronicTicket)
        buildLayoutComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildComponents(data: BAZ_TicketResponse, isElectronicTicket: Bool){
        
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
        let movements = data.comercio?.movimientos ?? []
        
        var fullAmount = data.descripcionMontoTotal?.uppercased() ?? ""
        if fullAmount == ""{
            fullAmount = total.convertAmountToString()
        }
        
        operationDescription.text = transactionType.capitalized
        amountText.text = "(\(fullAmount.capitalized))"
        
        for (_,x) in [["#Aut. Banco", autBank],
                      ["ID Transacción",idTransaction],
                      ["#Folio Admin", folioAdmin],
                      ["\(typePay.capitalized)", lastNumbersCard],
                      ["Fecha y hora", date]].enumerated(){
            
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let title = UILabel(frame: .zero)
            title.textAlignment = .left
            title.translatesAutoresizingMaskIntoConstraints = false
            title.text = x[0]
            title.font =  UIFont.boldSystemFont(ofSize: 16)
            title.textColor = UIColor.black
            
            let description = UILabel(frame: .zero)
            description.textAlignment = .right
            description.minimumScaleFactor = 0.6
            description.adjustsFontSizeToFitWidth = true
            description.translatesAutoresizingMaskIntoConstraints = false
            description.text = x[1]
            description.font = UIFont.boldSystemFont(ofSize: 16)
            description.textColor = UIColor.black
            
            view.addSubview(title)
            view.addSubview(description)
            
            heightStacksView += description.intrinsicContentSize.height + 5.0
            
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
        
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel(frame: .zero)
        dateLabel.textAlignment = .left
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = "FECHA"
        dateLabel.font =  UIFont.boldSystemFont(ofSize: 16)
        dateLabel.textColor = UIColor.black
        
        let description = UILabel(frame: .zero)
        description.textAlignment = .center
        description.translatesAutoresizingMaskIntoConstraints = false
        description.text = "DETALLE"
        description.adjustsFontSizeToFitWidth = true
        description.minimumScaleFactor = 0.7
        description.font = UIFont.boldSystemFont(ofSize: 16)
        description.textColor = UIColor.black
        
        let importLabel = UILabel(frame: .zero)
        importLabel.textAlignment = .right
        importLabel.translatesAutoresizingMaskIntoConstraints = false
        importLabel.text = "IMPORTE"
        importLabel.adjustsFontSizeToFitWidth = true
        importLabel.minimumScaleFactor = 0.7
        importLabel.font =  UIFont.boldSystemFont(ofSize: 16)
        importLabel.textColor = UIColor.black
        
        view.addSubview(dateLabel)
        view.addSubview(description)
        view.addSubview(importLabel)
        
        heightStacksView += description.intrinsicContentSize.height + 5.0
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.topAnchor),
            dateLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            importLabel.topAnchor.constraint(equalTo: view.topAnchor),
            importLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            importLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            importLabel.topAnchor.constraint(equalTo: view.topAnchor),
            
            description.topAnchor.constraint(equalTo: view.topAnchor),
            description.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 5),
            description.trailingAnchor.constraint(equalTo: importLabel.leadingAnchor, constant: -5),
            description.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            importLabel.heightAnchor.constraint(equalTo: description.heightAnchor),
            dateLabel.heightAnchor.constraint(equalTo: description.heightAnchor),
        ])
        
        stackSecond.addArrangedSubview(view)
        
        for movimiento in movements{
            
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let date = UILabel(frame: .zero)
            date.textAlignment = .left
            date.translatesAutoresizingMaskIntoConstraints = false
            date.text = (movimiento.fecha ?? "").addSlashes()
            date.numberOfLines = 1
            date.font =  UIFont.boldSystemFont(ofSize: 16)
            date.textColor = UIColor.black
            
            let description = UILabel(frame: .zero)
            description.textAlignment = .left
            description.translatesAutoresizingMaskIntoConstraints = false
            description.text = movimiento.detalle?.capitalized
            description.numberOfLines = 2
            description.adjustsFontSizeToFitWidth = true
            description.minimumScaleFactor = 0.7
            description.font = UIFont.boldSystemFont(ofSize: 16)
            description.textColor = UIColor.black
            
            let importLabel = UILabel(frame: .zero)
            importLabel.textAlignment = .right
            importLabel.translatesAutoresizingMaskIntoConstraints = false
            importLabel.text = movimiento.monto
            importLabel.numberOfLines = 1
            importLabel.adjustsFontSizeToFitWidth = true
            importLabel.minimumScaleFactor = 0.7
            importLabel.font =  UIFont.boldSystemFont(ofSize: 16)
            importLabel.textColor = UIColor.black
            
            view.addSubview(date)
            view.addSubview(description)
            view.addSubview(importLabel)
            
            heightStacksView += description.intrinsicContentSize.height + 5.0
            
            NSLayoutConstraint.activate([
                date.topAnchor.constraint(equalTo: view.topAnchor),
                date.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
                date.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                
                importLabel.topAnchor.constraint(equalTo: view.topAnchor),
                importLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
                importLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                importLabel.topAnchor.constraint(equalTo: view.topAnchor),
                
                description.topAnchor.constraint(equalTo: view.topAnchor),
                description.leadingAnchor.constraint(equalTo: date.trailingAnchor, constant: 5),
                description.trailingAnchor.constraint(equalTo: importLabel.leadingAnchor, constant: -5),
                description.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                importLabel.heightAnchor.constraint(equalTo: description.heightAnchor),
                date.heightAnchor.constraint(equalTo: description.heightAnchor),
            ])
            
            stackSecond.addArrangedSubview(view)
        }
        
        for (i,x) in [["Comisión", commission.priceDecorative()],
                      ["IVA Comisión", ivaCommision.priceDecorative()],
                      ["Total", total.priceDecorative()]].enumerated(){
            
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let title = UILabel(frame: .zero)
            title.textAlignment = .left
            title.translatesAutoresizingMaskIntoConstraints = false
            title.text = x[0]
            title.font =  UIFont.boldSystemFont(ofSize: i == 2 ? 24 : 16)
            title.textColor = UIColor.black
            
            let description = UILabel(frame: .zero)
            description.textAlignment = .right
            description.translatesAutoresizingMaskIntoConstraints = false
            description.text = x[1]
            description.font = UIFont.boldSystemFont(ofSize: i == 2 ? 24 : 16)
            description.textColor = UIColor.black
            
            view.addSubview(title)
            view.addSubview(description)
            
            heightStacksView += description.intrinsicContentSize.height + 5.0
            
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
                stackThird.addArrangedSubview(view)
            }
        }
        
        [titleText, operationDescription, stackFirst, separatorView, stackSecond, stackThird, amountText].forEach { component in
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
            
            separatorView.topAnchor.constraint(equalTo: stackFirst.bottomAnchor, constant: 40.0),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            
            stackSecond.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 40.0),
            stackSecond.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            stackSecond.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            
            stackThird.topAnchor.constraint(equalTo: stackSecond.bottomAnchor, constant: 40.0),
            stackThird.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            stackThird.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            
            amountText.topAnchor.constraint(equalTo: stackThird.bottomAnchor),
            amountText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            amountText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            amountText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20.0)
        ])
    }
    
    func getSizeView() -> CGFloat{
        let spacingComponents : CGFloat = 200.0
        var size = spacingComponents
        size += titleText.intrinsicContentSize.height
        size += operationDescription.intrinsicContentSize.height
        size += separatorView.intrinsicContentSize.height
        size += heightStacksView
        size += amountText.intrinsicContentSize.height

        return size
    }
}
