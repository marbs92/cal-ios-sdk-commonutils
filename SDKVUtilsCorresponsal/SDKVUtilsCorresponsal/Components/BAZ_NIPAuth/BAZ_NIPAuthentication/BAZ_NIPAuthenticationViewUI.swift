//
//  BAZ_NIPAuthenticationViewUI.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 05/10/22.
//

import Foundation
import UIKit


internal protocol BAZ_NIPAuthenticationViewUIDelegate {
    func notifyForgotNIP()
    func notifyValidateNIP(nip: String)
    func notifyExit()
}


internal class BAZ_NIPAuthenticationViewUI: UIView{
    internal var delegate: BAZ_NIPAuthenticationViewUIDelegate?
    
    private let numberOfDigits = 6
    private var currentNIP = ""
    
    
    lazy var navigationBar: BAZ_NavigationView = {
        let navigationController = BAZ_NavigationView(frame: .zero)
        navigationController.translatesAutoresizingMaskIntoConstraints = false
        return navigationController
    }()

    lazy var cardView: BAZ_CardView = {
        let view = BAZ_CardView(cornerRadius: 0, shadowRadius: 0, shadowOffset: CGSize(width: 0, height: 0), shadowColor: .clear, shadowOpacity: 0, background: .clear)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = BAZ_ColorManager.greenDarkRW
        label.font = .Poppins_Medium_16
        label.text = "Ingresa tu clave de seguridad"
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var nipComponent: BAZ_TextFieldsNipView = {
        let nip = BAZ_TextFieldsNipView(numOfComponents: self.numberOfDigits, fontSize: 30, isWithMaxSecurity: true)
        nip.translatesAutoresizingMaskIntoConstraints = false
        nip.delegate = self
        
        return nip
    }()
    
    lazy var forgotNIPButton: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forgotNIPButtonTriggered))
        tapGesture.numberOfTapsRequired = 1
        
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonTitleLabel.textColor = BAZ_ColorManager.mediumPurple
        buttonTitleLabel.font = .Poppins_Regular_16
        buttonTitleLabel.numberOfLines = 1
        buttonTitleLabel.adjustsFontSizeToFitWidth = true
        buttonTitleLabel.textAlignment = .center
        buttonTitleLabel.text = "Olvidé mi clave de seguridad"
        
        let arrowImage = UIImageView()
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.tintColor = BAZ_ColorManager.mediumPurple
        arrowImage.image = UIImage(bazNamed: "arrowRightIcon")
        arrowImage.contentMode = .scaleAspectFit
        
        view.addSubview(buttonTitleLabel)
        view.addSubview(arrowImage)
        
        NSLayoutConstraint.activate([
            buttonTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonTitleLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor),
            buttonTitleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            buttonTitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            arrowImage.topAnchor.constraint(equalTo: view.topAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            arrowImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arrowImage.heightAnchor.constraint(equalToConstant: 25),
            arrowImage.widthAnchor.constraint(equalToConstant: 20),
        ])
        
        return view
    }()
    
    lazy var validateNIPButton: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(titleText: "Continuar", textAlignment: .Center, showIcon: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.validateNIPButtonTriggered), for: .touchUpInside)
        button.setEnableButton(enable: false)
        
        return button
    }()
    
    
    public convenience init(delegate: BAZ_NIPAuthenticationViewUIDelegate){
        self.init()
        self.delegate = delegate
        
        self.navigationBar.setComponents(title: "Clave de seguridad",
                                         navigationController: nil,
                                         backgroundColor: .white)
        
        self.navigationBar.assignCustomBackEvent(target: self,
                                                 event: #selector(self.exitActionTriggered),
                                                 eventTrigger: .touchUpInside)
        
        self.setUI()
        self.setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func setUI(){
        self.addSubview(self.navigationBar)
        self.addSubview(self.cardView)
        self.cardView.addSubview(self.titleLabel)
        self.cardView.addSubview(self.nipComponent)
        self.cardView.addSubview(self.forgotNIPButton)
        self.cardView.addSubview(self.validateNIPButton)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            self.navigationBar.topAnchor.constraint(equalTo: self.topAnchor),
            self.navigationBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.navigationBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.cardView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor),
            self.cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            self.cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            self.cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 25),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            
            self.nipComponent.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 40),
            self.nipComponent.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.nipComponent.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            
            self.forgotNIPButton.topAnchor.constraint(equalTo: self.nipComponent.bottomAnchor, constant: 30),
            self.forgotNIPButton.leadingAnchor.constraint(greaterThanOrEqualTo: self.cardView.leadingAnchor),
            self.forgotNIPButton.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor),
            self.forgotNIPButton.trailingAnchor.constraint(lessThanOrEqualTo: self.cardView.trailingAnchor),
            
            self.validateNIPButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.validateNIPButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.validateNIPButton.bottomAnchor.constraint(equalTo: self.cardView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.validateNIPButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.navigationBar.addBorder()
    }
    
    
    @objc func exitActionTriggered() {
        self.delegate?.notifyExit()
    }
    
    @objc func forgotNIPButtonTriggered() {
        self.delegate?.notifyForgotNIP()
    }
    
    @objc func validateNIPButtonTriggered() {
        if self.currentNIP.count == self.numberOfDigits {
            self.delegate?.notifyValidateNIP(nip: self.currentNIP)
        }
    }
    
    
    internal func notifyWrongCredential() {
        self.nipComponent.failureUI(withText: "Clave incorrecta",
                                    textColor: BAZ_ColorManager.redError,
                                    textFont: .Poppins_Regular_14,
                                    textAlignment: .center,
                                    borderColor: BAZ_ColorManager.redError,
                                    borderWidth: 1)
        self.validateNIPButton.setEnableButton(enable: false)
    }
}


extension BAZ_NIPAuthenticationViewUI: BAZ_TextFieldsNipProtocol {
    func responseInputText(componentText: String, tag : Int) {
        self.nipComponent.setDefaultBorder()
        
        if componentText.count == self.numberOfDigits {
            self.validateNIPButton.setEnableButton(enable: true)
            self.currentNIP = componentText
        } else {
            self.validateNIPButton.setEnableButton(enable: false)
            self.currentNIP = ""
        }
    }
}
