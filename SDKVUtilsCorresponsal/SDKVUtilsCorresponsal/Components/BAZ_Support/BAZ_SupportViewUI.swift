//
//  BAZ_SupportViewUI.swift
//  aceptapago-ios-sdk-login
//
//  Created by Luis Fernando Sánchez Palma on 27/10/22.
//

import UIKit
import SDKVUtilsCorresponsal

class BAZ_SupportViewUI: UIView {
    
    var navigationController: UINavigationController?
    private var whatsAppGesture: UITapGestureRecognizer!
    private var telegramGesture: UITapGestureRecognizer!
    
    lazy var navigationBar: BAZ_NavigationView = {
        let navigationController = BAZ_NavigationView(frame: .zero)
        navigationController.translatesAutoresizingMaskIntoConstraints = false
        return navigationController
    }()
    
    lazy var titleText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Comunicate con nosotros para resolver cualquier duda"
        label.font = .Poppins_Medium_16
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subTitleText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.grayDark
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Selecciona el medio de comunicación"
        label.font = .Poppins_Regular_13
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var whatsAppButton: BAZ_CardView = {
        let view = BAZ_CardView(cornerRadius: 20, shadowRadius: 4, shadowOffset: CGSize(width: 0, height: 0), background: BAZ_ColorManager.whiteNavBarBackground)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var whatsAppIconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(bazNamed: "connectivityWhatsIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    lazy var whatsAppText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "WhatsApp"
        label.font = .Poppins_Regular_14
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var telegramButton: BAZ_CardView = {
        let view = BAZ_CardView(cornerRadius: 20, shadowRadius: 4, shadowOffset: CGSize(width: 0, height: 0), background: BAZ_ColorManager.whiteNavBarBackground)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var telegramIconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(bazNamed: "connectivityTelegramIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    lazy var telegramText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Telegram"
        label.font = .Poppins_Regular_14
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public convenience init(
        navigation: UINavigationController){
            self.init()
            navigationBar.setComponents(
                title: "Soporte",
                navigationController: navigation)
            self.navigationController = navigation
            
            self.backgroundColor = BAZ_ColorManager.noneSpaceTableRW
            
            setUI()
            setConstraints()
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUI(){
        navigationBar.addBorder()
        self.addSubview(navigationBar)
        self.addSubview(titleText)
        self.addSubview(subTitleText)
        self.addSubview(whatsAppButton)
        self.addSubview(telegramButton)
        whatsAppButton.addSubview(whatsAppIconView)
        whatsAppButton.addSubview(whatsAppText)
        telegramButton.addSubview(telegramIconView)
        telegramButton.addSubview(telegramText)
        
        
        whatsAppGesture = UITapGestureRecognizer(target: self, action: #selector(goToWhatsApp))
        whatsAppGesture.numberOfTapsRequired = 1
        whatsAppGesture.delaysTouchesBegan = true
        whatsAppButton.addGestureRecognizer(whatsAppGesture)
        
        telegramGesture = UITapGestureRecognizer(target: self, action: #selector(goToTelegram))
        telegramGesture.numberOfTapsRequired = 1
        telegramGesture.delaysTouchesBegan = true
        telegramButton.addGestureRecognizer(telegramGesture)
    }
    
    func setConstraints(){
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 100),
            
            titleText.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 40),
            titleText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            titleText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            subTitleText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 40),
            subTitleText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            subTitleText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            whatsAppButton.topAnchor.constraint(equalTo: subTitleText.bottomAnchor, constant: 20),
            whatsAppButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            whatsAppButton.heightAnchor.constraint(equalToConstant: 130),
            whatsAppButton.widthAnchor.constraint(equalToConstant: 116),
            
            whatsAppIconView.centerXAnchor.constraint(equalTo: whatsAppButton.centerXAnchor),
            whatsAppIconView.topAnchor.constraint(equalTo: whatsAppButton.topAnchor, constant: 16),
            whatsAppIconView.heightAnchor.constraint(equalToConstant: 62),
            whatsAppIconView.widthAnchor.constraint(equalToConstant: 62),
            
            whatsAppText.topAnchor.constraint(equalTo: whatsAppIconView.bottomAnchor, constant: 15),
            whatsAppText.leadingAnchor.constraint(equalTo: whatsAppButton.leadingAnchor, constant: 20),
            whatsAppText.trailingAnchor.constraint(equalTo: whatsAppButton.trailingAnchor, constant: -20),
            
            telegramButton.topAnchor.constraint(equalTo: subTitleText.bottomAnchor, constant: 20),
            telegramButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            telegramButton.heightAnchor.constraint(equalToConstant: 130),
            telegramButton.widthAnchor.constraint(equalToConstant: 116),
            
            telegramIconView.centerXAnchor.constraint(equalTo: telegramButton.centerXAnchor),
            telegramIconView.topAnchor.constraint(equalTo: telegramButton.topAnchor, constant: 16),
            telegramIconView.heightAnchor.constraint(equalToConstant: 62),
            telegramIconView.widthAnchor.constraint(equalToConstant: 62),
            
            telegramText.topAnchor.constraint(equalTo: telegramIconView.bottomAnchor, constant: 15),
            telegramText.leadingAnchor.constraint(equalTo: telegramButton.leadingAnchor, constant: 20),
            telegramText.trailingAnchor.constraint(equalTo: telegramButton.trailingAnchor, constant: -20),
            
        ])
    }
    
    @objc func goToWhatsApp() {
        if let url = URL(string: "https://wa.link/bazaceptapago") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func goToTelegram() {
        if let url = URL(string: "https://t.me/baz_acepta_pago") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

