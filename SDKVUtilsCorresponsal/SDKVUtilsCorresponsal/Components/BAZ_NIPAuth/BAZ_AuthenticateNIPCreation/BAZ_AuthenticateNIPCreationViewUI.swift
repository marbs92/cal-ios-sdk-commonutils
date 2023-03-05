//
//  BAZ_AuthenticateNIPCreationViewUI.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 05/10/22.
//

import Foundation
import UIKit


internal protocol BAZ_AuthenticateNIPCreationViewUIDelegate {
    func notifyValidateCredential(credential: String)
    func notifyExit()
}

internal class BAZ_AuthenticateNIPCreationViewUI: UIView{
    internal var delegate: BAZ_AuthenticateNIPCreationViewUIDelegate?
    
    
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
        label.text = "Ingresa tu contraseña de inicio de sesión, para crear tu nueva clave de seguridad"
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var credentialInput: BAZ_TextFieldView = {
        let inputBaz = BAZ_TextFieldView(
            baz_form: BAZ_TextFieldNormalEntity(
                defaultKey: "credential",
                titleTop: "Contraseña",
                isRequired: true,
                typeKeyBoard: .asciiCapable,
                withSecurityEntry: true,
                maxLenght: 16,
                inputValidation: .ASCII,
                showToggleSecureEntry: true),
            textFieldInputHeight: 45,
            tintColor: BAZ_ColorManager.navyBlueDarkRW,
            backgrounColor: BAZ_ColorManager.whiteNavBarBackground,
            placeHolderFont: .Poppins_Medium_16,
            widthShadow: false,
            textFieldInputTopMargin: 5)

        inputBaz.getBazForm().delegate = self
        inputBaz.translatesAutoresizingMaskIntoConstraints = false
        return inputBaz
    }()
    
    private lazy var mainButton: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(titleText: "Confirmar", textAlignment: .Center, showIcon: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.confirmButtonTriggered), for: .touchUpInside)
        button.setEnableButton(enable: false)
        
        return button
    }()
    
    
    public convenience init(delegate: BAZ_AuthenticateNIPCreationViewUIDelegate){
        self.init()
        self.delegate = delegate
        
        self.navigationBar.setComponents(title: "Crear clave de seguridad",
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
        self.cardView.addSubview(self.credentialInput)
        self.cardView.addSubview(self.mainButton)
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
            
            self.credentialInput.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 25),
            self.credentialInput.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.credentialInput.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            
            self.mainButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.mainButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.mainButton.bottomAnchor.constraint(equalTo: self.cardView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.mainButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.navigationBar.addBorder()
    }
    
    
    @objc func exitActionTriggered() {
        self.delegate?.notifyExit()
    }
    
    @objc func confirmButtonTriggered(){
        if !self.credentialInput.getBazForm().getCurrentValue().isEmpty {
            self.delegate?.notifyValidateCredential(credential: self.credentialInput.getBazForm().getCurrentValue())
        }
    }
    
    internal func notifyWrongCredential() {
        self.credentialInput.setErrorUI()
        self.mainButton.setEnableButton(enable: false)
    }
    
    internal func resetCredentialField() {
        self.credentialInput.textFieldInput.text = ""
        self.credentialInput.getBazForm().setCurrentValue(value: "")
    }
}


extension BAZ_AuthenticateNIPCreationViewUI: BAZ_TextFieldEntityProtocol {
    func notifyDidChange(element: String, defaultKey: String) {
        self.credentialInput.setSuccessUI()
        self.mainButton.setEnableButton(enable: !element.isEmpty)
    }
    
    func notifyDoneButtonTapped(tag: Int) {
        self.confirmButtonTriggered()
    }
}
