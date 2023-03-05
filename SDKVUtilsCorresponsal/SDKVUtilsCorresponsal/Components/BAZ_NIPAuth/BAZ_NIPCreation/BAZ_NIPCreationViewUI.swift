//
//  BAZ_NIPCreationViewUI.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 05/10/22.
//

import Foundation
import UIKit


internal protocol BAZ_NIPCreationViewUIDelegate {
    func notifyCreateNIP(nip: String)
    func notifyExit()
}

internal class BAZ_NIPCreationViewUI: UIView{
    internal var delegate: BAZ_NIPCreationViewUIDelegate?
    
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
        label.text = "Crea tu clave de seguridad"
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var nipComponent: BAZ_TextFieldsNipView = {
       let nip = BAZ_TextFieldsNipView(numOfComponents: 6, fontSize: 30, isWithMaxSecurity: true)
        nip.translatesAutoresizingMaskIntoConstraints = false
        nip.delegate = self
        
        return nip
    }()
    
    lazy var validationListComponent: BAZ_CheckList = {
        let view = BAZ_CheckList(title: ["\(self.numberOfDigits) dígitos",
                                         "Sin números consecutivos",
                                         "Sin números repetidos"],
                                 stackSpacing: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var mainButton: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(titleText: "Continuar", textAlignment: .Center, showIcon: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.continueButtonTriggered), for: .touchUpInside)
        button.setEnableButton(enable: false)
        
        return button
    }()
    
    
    public convenience init(delegate: BAZ_NIPCreationViewUIDelegate,
                            isExitEnabled: Bool){
        self.init()
        self.delegate = delegate
        
        self.navigationBar.setComponents(title: "Crear clave de seguridad",
                                         navigationController: nil,
                                         hiddenBackButton: !isExitEnabled,
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
        self.cardView.addSubview(self.validationListComponent)
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
            
            self.nipComponent.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 40),
            self.nipComponent.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.nipComponent.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            
            self.validationListComponent.topAnchor.constraint(equalTo: self.nipComponent.bottomAnchor, constant: 30),
            self.validationListComponent.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 15),
            self.validationListComponent.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -15),
            
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
    
    @objc func continueButtonTriggered() {
        if self.validateCoditions() {
            self.delegate?.notifyCreateNIP(nip: self.currentNIP)
        }
    }
    
    
    private func validateCoditions(nip: String? = nil) -> Bool {
        let nipText = (nip != nil ? nip : self.currentNIP) ?? ""
        let digitsCountCondition = (nipText.count == self.numberOfDigits)
        let consecutiveDigitsCondition = !(nipText.hasConsecutiveNumers() ?? true)
        let repeatedDigitsCondition = !(nipText.hasRepeatedCharacters())
        
        self.validationListComponent.setElementsCheckedStatus(checked: [digitsCountCondition,
                                                                        consecutiveDigitsCondition,
                                                                        repeatedDigitsCondition])
        
        return (digitsCountCondition && consecutiveDigitsCondition && repeatedDigitsCondition)
    }
}


extension BAZ_NIPCreationViewUI: BAZ_TextFieldsNipProtocol {
    func responseInputText(componentText: String, tag : Int) {
        _ = self.validateCoditions(nip: componentText)
        
        if (componentText.count == self.numberOfDigits){
            if self.validationListComponent.allConditionsHaveMet() {
                self.nipComponent.successUI(borderColor: BAZ_ColorManager.greenDarkRW,
                                            borderWidth: 1)
                self.mainButton.setEnableButton(enable: true)
                self.currentNIP = componentText
            } else {
                self.nipComponent.failureUI(withText: "",
                                            borderColor: BAZ_ColorManager.redError,
                                            borderWidth: 1)
                self.mainButton.setEnableButton(enable: false)
                self.currentNIP = ""
            }
        } else {
            self.nipComponent.setDefaultBorder()
            self.currentNIP = ""
            self.mainButton.setEnableButton(enable: false)
        }
    }
}
