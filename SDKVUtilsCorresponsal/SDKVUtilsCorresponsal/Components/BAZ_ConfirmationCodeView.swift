//
//  BAZ_ConfirmationCodeView.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 12/04/21.
//

import UIKit


public protocol BAZ_ConfirmationCodeViewProtocol:class {
    func notifyContinue(code: String, tag: Int)
    func notifyRequestRefreshCode()
}

open class BAZ_ConfirmationCodeView: UIView {
    
    var context: UIViewController?
    private var topAnchorCustom : NSLayoutConstraint?
    private var leadingAnchorCustom : NSLayoutConstraint?
    private var trailingAnchorCustom : NSLayoutConstraint?
    private var bottomAnchorCustom : NSLayoutConstraint?
    private var centerxAnchorCustom : NSLayoutConstraint?
    public weak var delegate : BAZ_ConfirmationCodeViewProtocol?
    private var codeToValidate: String?
    
    lazy var containerBlurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blur)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var cardView: BAZ_CardView = {
        let view = BAZ_CardView(background: .white)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.greenDarkRW
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.Poppins_Semibold_26
        label.text = "Código de confirmación"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.Poppins_Regular_16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var subtitleText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.Poppins_Semibold_16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var containerStack = UIStackView(frame: .zero)
    
    public lazy var codeComponent: BAZ_TextFieldsNipView = {
        let codeView = BAZ_TextFieldsNipView(typeViewTextField: "", numOfComponents: 6, fontSize: 30)
        codeView.translatesAutoresizingMaskIntoConstraints = false
        return codeView
    }()
    
    lazy var timerComponent: BAZ_TimerView = {
        let timerView = BAZ_TimerView(cooldown: 300, startOnTypeText: "5:00")
        timerView.translatesAutoresizingMaskIntoConstraints = false
        return timerView
    }()
    
    lazy var buttonIcon: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(
            titleText: "Continuar",
            textAlignment: .Center,
            buttonBackgroundColor : BAZ_ColorManager.greenDarkRW,
            buttonCornerRadius: 25,
            buttonDisabledBackgroundColor: BAZ_ColorManager.dissableButtonRW,
            buttonDisabledTintColor: .white)
        button.addTarget(self, action: #selector(self.continueAction(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setEnableButton(enable: false)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .white
        button.setTitleColor(BAZ_ColorManager.greenDarkRW, for: .normal)
        button.setTitle("Cancelar", for: .normal)
        button.titleLabel?.font = UIFont.Poppins_Bold_16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.cancelAction(_:)), for: .touchUpInside)
        return button
    }()
    
    
    public func initCustom(
        context:UIViewController,
        message: String,
        subtitle: String){
        self.context = context
        self.descriptionText.text = message
        self.subtitleText.text = subtitle
        buildUI()
        buildConstraint()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func buildUI(){
        containerStack.axis = .vertical
        containerStack.distribution = .fill
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerBlurView)
        self.addSubview(containerView)
        self.containerView.addSubview(cardView)
        self.cardView.addSubview(titleText)
        self.cardView.addSubview(descriptionText)
        self.cardView.addSubview(subtitleText)
        self.cardView.addSubview(containerStack)
        self.containerStack.addArrangedSubview(codeComponent)
        self.containerStack.addArrangedSubview(timerComponent)
        self.cardView.addSubview(cancelButton)
        self.cardView.addSubview(buttonIcon)
        codeComponent.delegate = self
        timerComponent.delegate = self
        timerComponent.startTimerCode()
    }
    
    
    fileprivate func buildConstraint(){
        topAnchorCustom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: context?.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        trailingAnchorCustom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: context?.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        leadingAnchorCustom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: context?.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        bottomAnchorCustom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: context?.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        topAnchorCustom?.isActive = true
        trailingAnchorCustom?.isActive = true
        leadingAnchorCustom?.isActive = true
        bottomAnchorCustom?.isActive = true
        
        
        centerxAnchorCustom = NSLayoutConstraint(item: containerView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        centerxAnchorCustom?.isActive = true
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            cardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            cardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            cardView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        
            titleText.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30),
            titleText.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            titleText.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.9, constant: 0),
            
            descriptionText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 20),
            descriptionText.leadingAnchor.constraint(equalTo: titleText.leadingAnchor, constant: 20),
            descriptionText.trailingAnchor.constraint(equalTo: titleText.trailingAnchor,constant: -20),
            
            subtitleText.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 0),
            subtitleText.leadingAnchor.constraint(equalTo: descriptionText.leadingAnchor),
            subtitleText.trailingAnchor.constraint(equalTo: descriptionText.trailingAnchor),
            
            cancelButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.8, constant: 0),
            cancelButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            
            buttonIcon.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10),
            buttonIcon.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 30),
            buttonIcon.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -30),
            buttonIcon.heightAnchor.constraint(equalToConstant: 50),
            
            containerStack.topAnchor.constraint(equalTo: subtitleText.bottomAnchor, constant: 40),
            containerStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            containerStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            containerStack.bottomAnchor.constraint(equalTo: buttonIcon.topAnchor, constant: -10)
        ])
        
        if(UIScreen.main.bounds.height < 700){
            NSLayoutConstraint.activate([
                cardView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.8, constant: 0),
            ])
        }else{
            NSLayoutConstraint.activate([
                cardView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.6, constant: 0),
            ])
        }
        
        titleText.setContentHuggingPriority(UILayoutPriority(rawValue: 290), for: .vertical)
        descriptionText.setContentHuggingPriority(UILayoutPriority(rawValue: 289), for: .vertical)
        subtitleText.setContentHuggingPriority(UILayoutPriority(rawValue: 288), for: .vertical)
        cancelButton.setContentHuggingPriority(UILayoutPriority(290), for: .vertical)
        
    }

    public func dissmisComponent(){
        self.isHidden = true
        self.topAnchorCustom?.isActive = false
        self.trailingAnchorCustom?.isActive = false
        self.leadingAnchorCustom?.isActive = false
        self.bottomAnchorCustom?.isActive = false
        self.centerxAnchorCustom?.isActive = false
        self.removeFromSuperview()
    }

    @objc func cancelAction(_ sender: UIButton){
        timerComponent.stopTimerCode()
        self.dissmisComponent()
    }
    
    @objc func continueAction(_ sender: UIButton){
        delegate?.notifyContinue(code: codeToValidate ?? "", tag: self.tag)
    }
}


extension BAZ_ConfirmationCodeView: BAZ_TimerViewProtocol{
    
    public func notifyTimeOver() {
        (containerStack.arrangedSubviews.first as? BAZ_TextFieldsNipView)?.arrayInputs.forEach({ (uITextField) in
            uITextField.autocorrectionType = .no
            uITextField.isUserInteractionEnabled = false
        })
        (containerStack.arrangedSubviews.first as? BAZ_TextFieldsNipView)?.failureUI(withText: "Código de confirmación caducado")
        buttonIcon.setEnableButton(enable: false)
    }
    
    public func notifyRefreshCode() {
        (containerStack.arrangedSubviews.first as? BAZ_TextFieldsNipView)?.arrayInputs.forEach({ (uITextField) in
            uITextField.text = ""
            uITextField.autocorrectionType = .no
            uITextField.isUserInteractionEnabled = true
        })
        (containerStack.arrangedSubviews.first as? BAZ_TextFieldsNipView)?.successUI()
        buttonIcon.setEnableButton(enable: false)
        delegate?.notifyRequestRefreshCode()
    }
}

extension BAZ_ConfirmationCodeView: BAZ_TextFieldsNipProtocol{
    public func responseInputText(componentText: String, tag : Int) {
        codeToValidate = componentText
        guard componentText.count == 6 else {
            buttonIcon.setEnableButton(enable: false)
            return
        }
        buttonIcon.setEnableButton(enable: true)
    }
}
