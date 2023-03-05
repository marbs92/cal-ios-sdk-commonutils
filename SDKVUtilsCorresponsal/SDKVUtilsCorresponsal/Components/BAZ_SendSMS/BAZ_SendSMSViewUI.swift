//
//  BAZ_SendSMSViewUI.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 14/12/21.
//

import Foundation
import UIKit

protocol BAZ_SendSMSViewUIDelegate {
    func notifyReturn()
    func notifySendSMS(phoneNumer: Int)
}

class BAZ_SendSMSViewUI: UIView{
    var delegate: BAZ_SendSMSViewUIDelegate?
    var navigationController: UINavigationController?

    var confirmButtonBottomAnchor: NSLayoutConstraint = NSLayoutConstraint()
    public var email: String = ""
    public var paymentId: Int?
    
    lazy var navBar: BAZ_NavigationView = {
        let view = BAZ_NavigationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var border: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.8980392157, blue: 0.937254902, alpha: 1)
        return view
    }()
    
    lazy var contentView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.bounces = false
        scroll.backgroundColor = .clear
        return scroll
    }()
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var instructionsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.text = "Ingrese el número telefónico al que se le enviará el SMS"
        return label
    }()

    lazy var phoneNumberTextField: BAZ_TextFieldView = {
        let inputBaz = BAZ_TextFieldView(
            baz_form: BAZ_TextFieldNormalEntity(
                defaultKey: "numeroTelefonico",
                titleTop: "Número de teléfono",
                isRequired: true,
                typeKeyBoard: .asciiCapableNumberPad ,
                withMask: .Phone,
                maxLenght: 10),
            textFieldInputHeight: 50,
            tintColor: BAZ_ColorManager.navyBlueDarkRW,
            backgrounColor: BAZ_ColorManager.whiteNavBarBackground,
            placeHolderFont: .Poppins_Regular_15,
            widthShadow: false
        )
        inputBaz.getBazForm().delegate = self
        inputBaz.translatesAutoresizingMaskIntoConstraints = false
        return inputBaz
    }()
    

    lazy var confirmButton: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(titleText: "Finalizar", textAlignment: .Left)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendSMSButtonTriggered), for: .touchUpInside)
        button.setEnableButton(enable: false)
        return button
    }()
    
    public convenience init(
        delegate: BAZ_SendSMSViewUIDelegate){
            self.init()
            self.delegate = delegate
            
            navBar.setComponents(
                title: "Envío de SMS",
                navigationController: nil,
                hiddenBackButton: true)
            navBar.assignCustomBackEvent(target: self, event: #selector(returnButtonTriggered), eventTrigger: UIControl.Event.touchUpInside)
            self.confirmButton.addTarget(self, action: #selector(sendSMSButtonTriggered), for: UIControl.Event.touchUpInside)
            setUI()
            setConstraints()
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = BAZ_ColorManager.noneSpaceRW
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUI(){
        self.addSubview(navBar)
        self.addSubview(border)
        self.addSubview(contentView)
        
        self.contentView.addSubview(cardView)
        
        self.cardView.addSubview(instructionsTitleLabel)
        //self.cardView.addSubview(emailTextFieldTitleLabel)
        self.cardView.addSubview(phoneNumberTextField)
        self.cardView.addSubview(confirmButton)
    }
    
    func setConstraints(){
        self.confirmButtonBottomAnchor = confirmButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -25)
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: self.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            border.topAnchor.constraint(equalTo: self.navBar.bottomAnchor),
            border.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            border.heightAnchor.constraint(equalToConstant: 1),
            
            contentView.topAnchor.constraint(equalTo: self.border.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            cardView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 25),
            cardView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -25),
            cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            cardView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            cardView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            
            instructionsTitleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            instructionsTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            instructionsTitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            
            phoneNumberTextField.topAnchor.constraint(equalTo: instructionsTitleLabel.bottomAnchor, constant: 30),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            //phoneNumberTextField.heightAnchor.constraint(equalToConstant: 50),
            
            confirmButtonBottomAnchor,
            confirmButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    
    func setKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // Este método es llamado en el view
    func deleteKeyboardObservers(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Abrir teclado
    @objc func keyboardWillShow(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        UIView.animate(withDuration: 0.4){
            self.confirmButtonBottomAnchor.constant = -CGFloat(keyboardRect.height) - 20
            self.layoutIfNeeded()
        }
        
    }
    
    // Cerrar teclado
    @objc func keyboardWillHide(){
        UIView.animate(withDuration: 0.4){
            self.confirmButtonBottomAnchor.constant = -25
            self.layoutIfNeeded()
        }
        
    }
    
    @objc func sendSMSButtonTriggered(){
        phoneNumberTextField.textFieldInput.resignFirstResponder()
        let stringPhoneNumber = phoneNumberTextField.getBazForm().getCurrentValue().replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if  stringPhoneNumber.count == 10, let phoneNumber = Int(stringPhoneNumber){
            self.delegate?.notifySendSMS(phoneNumer: phoneNumber)
        }
    }
    
    
    @objc func returnButtonTriggered(){
        self.delegate?.notifyReturn()
    }

}

extension BAZ_SendSMSViewUI: BAZ_TextFieldEntityProtocol {
    func notifyDidChange(element: String, defaultKey: String) {
        let phoneNumber = phoneNumberTextField.getBazForm().getCurrentValue().replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: "")
        if let _ = Int(phoneNumber) {
            confirmButton.setEnableButton(enable: phoneNumber.count == 10)
        }else {
            confirmButton.setEnableButton(enable: false)
        }
    }
}
