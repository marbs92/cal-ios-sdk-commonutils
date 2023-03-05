//
//  BAZ_RejectionTicketView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 24/11/21.
//

import UIKit

class BAZ_RejectionTicketView: UIView {
    
    private lazy var lbCommerce: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lbLocation: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var separatorTopView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lbTicketType: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var separatorMiddleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lbDescription: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var separatorBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lbDate: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lbFooter: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public init(data: BAZ_RejectionTicketResponse){
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 350.0, height: 520))
        self.backgroundColor = UIColor.white
        
        buildComponents(data: data)
        buildLayoutComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildComponents(data: BAZ_RejectionTicketResponse){
        
        let locationCommerce = data.comercio?.direccion
        let location = "\(locationCommerce?.calle ?? "") NO. \(locationCommerce?.numeroExterior ?? "")\n\(locationCommerce?.colonia ?? "") C.P. \(locationCommerce?.codigoPostal ?? "")\n\(locationCommerce?.municipio ?? ""), \(locationCommerce?.estado ?? "")"
        
        lbCommerce.text = data.comercio?.nombre?.uppercased()
        lbLocation.text = location
        lbTicketType.text = "Comprobante digital"
        lbDescription.text = "\"Transacción no realizada por haber excedido su límite permitido. Acuda a una sucursal bancaria\""
        lbDate.text = data.operacion?.fechaHora
        lbFooter.text = "ESTRATEGIAS DE SERVICIOS APLICATIVOS AL NEGOCIO, S.A. DE C.V Av. FF CC de Río Frío 419, Cuchilla del Moral, Iztapalapa, Ciudad de México, C.P 09319\nRFC ESA210629K90"
        
        [lbCommerce, lbLocation, separatorTopView, lbTicketType, separatorMiddleView, lbDescription, separatorBottomView, lbDate, lbFooter].forEach { component in
            self.addSubview(component)
        }
    }
    
    private func buildLayoutComponents(){
        NSLayoutConstraint.activate([
            lbCommerce.topAnchor.constraint(equalTo: self.topAnchor, constant: 30.0),
            lbCommerce.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            lbCommerce.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0),
            
            lbLocation.topAnchor.constraint(equalTo: lbCommerce.bottomAnchor, constant: 13),
            lbLocation.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            lbLocation.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            
            separatorTopView.topAnchor.constraint(equalTo: lbLocation.bottomAnchor, constant: 26.0),
            separatorTopView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            separatorTopView.heightAnchor.constraint(equalToConstant: 2.0),
            separatorTopView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0),
            
            lbTicketType.topAnchor.constraint(equalTo: separatorTopView.bottomAnchor, constant: 16.0),
            lbTicketType.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            lbTicketType.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0),
            
            separatorMiddleView.topAnchor.constraint(equalTo: lbTicketType.bottomAnchor, constant: 16.0),
            separatorMiddleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            separatorMiddleView.heightAnchor.constraint(equalToConstant: 2.0),
            separatorMiddleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0),
            
            lbDescription.topAnchor.constraint(equalTo: separatorMiddleView.bottomAnchor, constant: 16.0),
            lbDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            lbDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0),
            
            separatorBottomView.topAnchor.constraint(equalTo: lbDescription.bottomAnchor, constant: 16.0),
            separatorBottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            separatorBottomView.heightAnchor.constraint(equalToConstant: 2.0),
            separatorBottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0),
            
            lbDate.topAnchor.constraint(equalTo: separatorBottomView.bottomAnchor, constant: 26.0),
            lbDate.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            lbDate.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0),
            
            lbFooter.topAnchor.constraint(equalTo: lbDate.bottomAnchor, constant: 10.0),
            lbFooter.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            lbFooter.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0),
        ])
    }
}
