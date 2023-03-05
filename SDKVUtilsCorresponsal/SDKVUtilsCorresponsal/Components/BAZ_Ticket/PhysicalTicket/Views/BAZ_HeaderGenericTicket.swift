//
//  BAZ_HeaderGenericTicket.swift
//  baz-ios-akpago-utils
//
//  Created by Gustavo Tellez on 06/09/21.
//

import UIKit

internal class BAZ_HeaderGenericTicket: UIView {
    
    private lazy var commerceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
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
    
    private var spacing: CGFloat = 0.0
    
    public init(modelData: BAZ_TicketResponse, isElectronicTicket: Bool){
        super.init(frame: CGRect.zero)
        
        self.backgroundColor                            =   UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints  =   false
        
        buildComponents(modelData: modelData, isElectronicTicket: isElectronicTicket)
        buildLayoutComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildComponents(modelData: BAZ_TicketResponse, isElectronicTicket: Bool){
        
        self.spacing = isElectronicTicket ? 15.0 : 0.0
        
        let commerceName    =   modelData.comercio?.nombre?.uppercased() ?? ""
        let street          =   modelData.comercio?.direccion?.calle?.capitalized ?? ""
        let streetNumber    =   modelData.comercio?.direccion?.numeroExterior ?? ""
        let cp              =   modelData.comercio?.direccion?.codigoPostal ?? ""
        let suburb          =   modelData.comercio?.direccion?.colonia?.capitalized ?? ""
        let city            =   modelData.comercio?.direccion?.estado ?? ""
        let idMarket        =   String(modelData.comercio?.id ?? 0909)
        let idDevice        =   modelData.comercio?.idDispositivo ?? ""
        let idOperator      =   modelData.comercio?.operacion?.idOperador ?? ""
//        let idTransaction   =   modelData.comercio?.operacion?.id ?? ""
        
        commerceLabel.text      =   commerceName
        locationText.text       =   "\(street) No. \(streetNumber)\nCol. \(suburb),\nC.P. \(cp), \(city)"
        
        for (i,x) in [["ID Comercio", idMarket],
                      ["ID Dispositivo", idDevice],
                      ["ID Operador", idOperator]].enumerated(){
            
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let title = UILabel(frame: .zero)
            title.text = x[0]
            title.textColor = UIColor.black
            title.numberOfLines = 1
            title.textAlignment = .left
            title.font = UIFont.boldSystemFont(ofSize: 16)
            title.translatesAutoresizingMaskIntoConstraints = false
            
            let description = UILabel(frame: .zero)
            description.text = x[1]
            description.textColor = UIColor.black
            description.numberOfLines = i == 2 ? 3 : 1
            description.textAlignment = .right
            description.font = UIFont.boldSystemFont(ofSize: 16)
            description.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(title)
            view.addSubview(description)
            
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
                stackView.addArrangedSubview(view)
            }
        }
        
        [commerceLabel, locationText, stackView, separatorView].forEach { component in
            self.addSubview(component)
        }
    }
    
    private func buildLayoutComponents(){
        
        NSLayoutConstraint.activate([
            
            commerceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0),
            commerceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            commerceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            
            locationText.topAnchor.constraint(equalTo: commerceLabel.bottomAnchor, constant: 20.0),
            locationText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            locationText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            
            stackView.topAnchor.constraint(equalTo: locationText.bottomAnchor, constant: 40.0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            
            separatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20.0),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func getSizeView() -> CGFloat{
        let spacingComponents : CGFloat = 100.0
        var size = spacingComponents
        size += commerceLabel.intrinsicContentSize.height
        size += locationText.intrinsicContentSize.height
        size += stackView.intrinsicContentSize.height
        size += separatorView.intrinsicContentSize.height
        
        return size
    }
}
