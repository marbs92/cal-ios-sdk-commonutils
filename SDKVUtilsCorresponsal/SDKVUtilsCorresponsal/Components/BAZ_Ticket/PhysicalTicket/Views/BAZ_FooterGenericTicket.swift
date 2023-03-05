//
//  BAZ_FooterGenericTicket.swift
//  baz-ios-akpago-utils
//
//  Created by Gustavo Tellez on 06/09/21.
//

import UIKit

internal class BAZ_FooterGenericTicket: UIView {
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var firstText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var secondText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var spacing     :   CGFloat = 0.0
    private var ticketType  :   Int?
    
    private var dynamicText : String{
        get{
            if ticketType != nil{
                
                switch ticketType {
                case 1, 2:
                    return "\"El retiro se verá reflejado en su cuenta en línea\""
                    
                case 3:
                    return "\"El depósito se verá aplicado en su cuenta en línea\""
                    
                case 6, 7, 8:
                    return "\"El pago se verá reflejado en su crédito el mismo día\""
                    
                default:
                    return ""
                }
                
            }else{
                return ""
            }
        }
    }
    
    private var electronicTicketType : String {
        get{
            if ticketType != nil{
                
                switch ticketType {
                case 5, 4, 1:
                    return "Comprobante digital\nAprobado Firma Electrónica\n\nEstimado cliente"
                    
                case 3, 6, 7, 8:
                    return "Comprobante digital\n\nEstimado cliente"
                    
                default:
                    return ""
                }
            }else{
                return ""
            }
        }
    }
    
    public init(type: Int?, isElectronicTicket: Bool){
        super.init(frame: CGRect.zero)
        
        self.backgroundColor                            =   UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints  =   false
        
        buildComponents(type: type, isElectronicTicket: isElectronicTicket)
        buildLayoutComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildComponents(type: Int?, isElectronicTicket: Bool){
        
        self.ticketType = type
        self.spacing = isElectronicTicket ? 15.0 : 0.0
        
        firstText.text = isElectronicTicket ?  "\(electronicTicketType)" : "Estimado cliente"
        
        secondText.text = "Es importante validar que los datos corresponden a la operación solicitada. Esta operacion es realizada a nombre y por cuenta de Banco Azteca, S.A. Institución de Banca Múltiple. \(dynamicText)\n\nCentro de atención a clientes Banco Azteca\nTel: 55-54478810 desde cualquier parte del país, www.bancoazteca.com.mx\n\nUnidad Especializada en atención a usuarios\nTel: 55-17207272 o al correo electrónico\nueau@bancoazteca.com.mx\n\nComisión Nacional para la Defensa de los usuarios de Servicios Financieros\nTel: 800-999-8080, www.condusef.gob.mx"
        
        locationText.text = "ESTRATEGIAS DE SERVICIOS APLICATIVOS AL NEGOCIO, S.A. DE C.V. Av. FF CC de Río Frío 419, Cuchilla del Moral, Iztapalapa, Ciudad de México, C.P. 09010\nRFC ESA210629K90"
        
        [separatorView, firstText, secondText, locationText].forEach { component in
            self.addSubview(component)
        }
    }
    
    private func buildLayoutComponents(){
        
        NSLayoutConstraint.activate([
            
            separatorView.topAnchor.constraint(equalTo: self.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            
            firstText.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 40.0),
            firstText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            firstText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            
            secondText.topAnchor.constraint(equalTo: firstText.bottomAnchor, constant: 20.0),
            secondText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            secondText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            
            locationText.topAnchor.constraint(equalTo: secondText.bottomAnchor, constant: 20.0),
            locationText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            locationText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            locationText.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func getSizeView() -> CGFloat{
        let spacingComponents : CGFloat = 80.0
        var size = spacingComponents
        size += separatorView.intrinsicContentSize.height
        size += firstText.intrinsicContentSize.height
        size += secondText.intrinsicContentSize.height
        size += locationText.intrinsicContentSize.height
        
        return size
    }
}
