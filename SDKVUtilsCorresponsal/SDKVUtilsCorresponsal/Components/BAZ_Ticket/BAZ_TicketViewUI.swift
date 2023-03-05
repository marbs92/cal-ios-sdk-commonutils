//
//  BAZ_TicketViewUI.swift
//  cal-ios-sdk-deposit
//
//  Created Jorge Cruz on 03/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: BAZ_TicketViewUI Delegate -
/// BAZ_TicketViewUI Delegate
@objc public protocol BAZ_TicketViewUIDelegate {
    // Send Events to Module View, that will send events to the Presenter; which will send events to the Receiver e.g. Protocol OR Component.
    func notifyFinishTicket()
    @objc optional func notifyRePrintTicket()
    func notifyShareTicketToSMS()
}



public class BAZ_TicketViewUI: UIView {
    
    lazy var stackFirst: UIStackView = {
        let stackFirst = UIStackView(frame: .zero)
        stackFirst.axis = .vertical
        stackFirst.spacing = 5
        stackFirst.translatesAutoresizingMaskIntoConstraints = false
        return stackFirst
    }()
    lazy var stackSecond: UIStackView = {
        let stackSecond = UIStackView(frame: .zero)
        stackSecond.axis = .vertical
        stackSecond.spacing = 5
        stackSecond.translatesAutoresizingMaskIntoConstraints = false
        return stackSecond
    }()
    lazy var navigationBar: BAZ_NavigationView = {
        let navigationController = BAZ_NavigationView(frame: .zero)
        navigationController.translatesAutoresizingMaskIntoConstraints = false
        return navigationController
    }()
    lazy var contentView: UIScrollView = {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()

    lazy var cardView: BAZ_CardView = {
        let view = BAZ_CardView(cornerRadius: 0, shadowRadius: 0, shadowOffset: CGSize(width: 0, height: 0), shadowColor: .clear, shadowOpacity: 0, background: .clear)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var alertIcon: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFit
        image.image =  UIImage(bazNamed: "alertSuccessIcon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    lazy var shareActionView: BAZ_ShareActionView = {
        let shareActionView = BAZ_ShareActionView(tintColor: BAZ_ColorManager.purpleToolBarRW,
                                                  withComponents: [BAZ_ShareActionType.SMS])
        shareActionView.delegate = self
        shareActionView.isHidden = true
        shareActionView.translatesAutoresizingMaskIntoConstraints = false
        return shareActionView
    }()

    lazy var titleText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .Poppins_Bold_22
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var contentFormViewStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.spacing = 30
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var subTitleText: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        var combination = NSMutableAttributedString()
        combination.append("Banco Azteca, S.A. Institución de Banca Multiple".decorative(color: .darkGray, font: .Poppins_Medium_12))
        label.attributedText = combination
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var boxAlert: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = BAZ_ColorManager.yellowTicket
        view.layer.cornerRadius = 5
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(bazNamed: "alertTickerIcon")
        image.tintColor = BAZ_ColorManager.purpleToolBarRW
        let message = UILabel(frame: .zero)
        message.translatesAutoresizingMaskIntoConstraints = false
        message.font = .Poppins_Regular_16
        message.textColor = BAZ_ColorManager.navyBlueDarkRW
        message.numberOfLines = 0
        message.text = "Entrega el comprobante a tu cliente"
        view.addSubview(image)
        view.addSubview(message)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            image.heightAnchor.constraint(equalToConstant: 24),
            image.widthAnchor.constraint(equalToConstant: 24),
            
            message.topAnchor.constraint(equalTo: image.topAnchor),
            message.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5),
            message.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            message.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        return view
    }()
    
    lazy var confirmButton: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(titleText: "Enviar comprobante",textAlignment: .Center, showIcon: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.finishTicketAction(_:)), for: .touchUpInside)
        button.setEnableButton(enable: true)
        return button
    }()
    
    var delegate            :   BAZ_TicketViewUIDelegate?
    var operationType       :   BAZ_OptionsMenuType?
    var operationResponse   :   BAZ_TicketEntity!
   
    public convenience init(
        navigation: UINavigationController,
        delegate: BAZ_TicketViewUIDelegate,
        operationType: BAZ_OptionsMenuType?,
        operationResponse: BAZ_TicketEntity,
        hiddenBackButton: Bool){
        
        self.init()
        self.delegate = delegate
        self.operationType = operationType
        self.operationResponse = operationResponse
        
        navigationBar.setComponents(title: operationType?.rawValue ?? "", navigationController: navigation, hiddenBackButton: hiddenBackButton)
//        shareActionView.isHidden = !(operationResponse.requirePrint ?? false)
    
        setupUIElements()
        setupConstraints()
        
        if hiddenBackButton == false{
            confirmButton.isHidden = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = BAZ_ColorManager.noneSpaceRW
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        
        self.alertIcon.alpha        = 0
        self.titleText.alpha        = 0
        self.subTitleText.alpha     = 0
        self.shareActionView.alpha  = 0
        self.confirmButton.alpha    = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn,.curveEaseInOut]) {
            self.alertIcon.alpha        = 1
            self.titleText.alpha        = 1
            self.subTitleText.alpha     = 1
            self.shareActionView.alpha  = 1
            self.confirmButton.alpha    = 1
        }
    }
    
    fileprivate func setupUIElements() {
        self.addSubview(contentView)
        self.addSubview(navigationBar)
        contentView.addSubview(cardView)
        cardView.addSubview(alertIcon)
        cardView.addSubview(titleText)
        
        buildInformation(entityBaz: operationResponse)

        contentFormViewStack.addArrangedSubview(stackFirst)
        contentFormViewStack.addArrangedSubview(stackSecond)
        contentFormViewStack.addArrangedSubview(subTitleText)
        contentFormViewStack.addArrangedSubview(boxAlert)
        cardView.addSubview(contentFormViewStack)
        cardView.addSubview(shareActionView)
        cardView.addSubview(confirmButton)
    }
    
    public func buildInformation(entityBaz: BAZ_TicketEntity){
        updateTitle()
        
        stackFirst.removeAllArrangedSubviews()
        stackSecond.removeAllArrangedSubviews()
        
        let descriptionModule = (entityBaz.moduleDescription ?? "").formattedByTicket(characterToReplace: "*")
        
        for (i,x) in [["\((entityBaz.module ?? "Referencia").capitalized):", descriptionModule],
                      ["Importe:",entityBaz.importe ?? ""],
                      ["Comisión:", entityBaz.comision ?? ""],
                      ["IVA Comisión:", entityBaz.ivaComision ?? ""],
                      ["Total:", entityBaz.total ?? ""]].enumerated(){
            let ContainerView = UIView(frame: .zero)
            ContainerView.translatesAutoresizingMaskIntoConstraints = false
            
            let lbInformation = UILabel(frame: .zero)
            lbInformation.textAlignment = .left
            lbInformation.translatesAutoresizingMaskIntoConstraints = false
            lbInformation.text = x[0] == " :" ? " " : x[0]
            lbInformation.font =  i == 0 ? .Poppins_Bold_14 : .Poppins_Medium_14
            lbInformation.textColor = i == 0 ? BAZ_ColorManager.navyBlueDarkRW : .darkGray
            
            let lbExtraInformation = UILabel(frame: .zero)
            lbExtraInformation.textAlignment = .right
            lbExtraInformation.translatesAutoresizingMaskIntoConstraints = false
            lbExtraInformation.text = (i == 0 || x[1] == " ") ? x[1] : x[1].priceDecorative()
            lbExtraInformation.font = i == 0 ? .Poppins_Bold_14 : .Poppins_Medium_14
            lbExtraInformation.textColor = i == 0 ? BAZ_ColorManager.navyBlueDarkRW : .darkGray
            
            ContainerView.addSubview(lbInformation)
            ContainerView.addSubview(lbExtraInformation)
            
            NSLayoutConstraint.activate([
                lbInformation.topAnchor.constraint(equalTo: ContainerView.topAnchor),
                lbInformation.leadingAnchor.constraint(equalTo: ContainerView.leadingAnchor),
                lbExtraInformation.topAnchor.constraint(equalTo: ContainerView.topAnchor),
                lbExtraInformation.leadingAnchor.constraint(equalTo: lbInformation.trailingAnchor, constant: 5),
                lbExtraInformation.trailingAnchor.constraint(equalTo: ContainerView.trailingAnchor),
                lbExtraInformation.bottomAnchor.constraint(equalTo: ContainerView.bottomAnchor),
                lbInformation.heightAnchor.constraint(equalTo: lbExtraInformation.heightAnchor),
                lbInformation.widthAnchor.constraint(equalTo: ContainerView.widthAnchor, multiplier: 0.4, constant: 0)
            ])
            if  x.last != "" {
                stackFirst.addArrangedSubview(ContainerView)
            }
        }
        
        for (_,x) in [["Aut. Banco", entityBaz.authorizationFolio ?? ""],
                      ["ID Transacción", entityBaz.idTransaccion ?? ""],
                      ["Folio Admin", entityBaz.folioAdmin ?? ""]].enumerated(){
            let containerView = UIView(frame: .zero)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            
            let lbInfo = UILabel(frame: .zero)
            lbInfo.textAlignment = .left
            lbInfo.translatesAutoresizingMaskIntoConstraints = false
            lbInfo.text = x[0]
            lbInfo.font = .Poppins_Medium_14
            lbInfo.textColor = .darkGray
            
            let lbExtraInfo = UILabel(frame: .zero)
            lbExtraInfo.textAlignment = .right
            lbExtraInfo.translatesAutoresizingMaskIntoConstraints = false
            lbExtraInfo.text = x[1]
            lbExtraInfo.font = .Poppins_Medium_14
            lbExtraInfo.textColor = .darkGray
            
            containerView.addSubview(lbInfo)
            containerView.addSubview(lbExtraInfo)
            
            NSLayoutConstraint.activate([
                lbInfo.topAnchor.constraint(equalTo: containerView.topAnchor),
                lbInfo.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                lbExtraInfo.topAnchor.constraint(equalTo: containerView.topAnchor),
                lbExtraInfo.leadingAnchor.constraint(equalTo: lbInfo.trailingAnchor, constant: 5),
                lbExtraInfo.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                lbExtraInfo.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                lbInfo.heightAnchor.constraint(equalTo: lbExtraInfo.heightAnchor),
                lbInfo.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6, constant: 0)
            ])
            if  x.last != "" {
                stackSecond.addArrangedSubview(containerView)
            }
        }
    }
    
    fileprivate func setupConstraints() {

        NSLayoutConstraint.activate([
            ///NavigationBar
            self.navigationBar.topAnchor.constraint(equalTo: self.topAnchor),
            self.navigationBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.navigationBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ///ScrollView
            self.contentView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            ///CardView
            self.cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.cardView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.cardView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.cardView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            self.alertIcon.topAnchor.constraint(equalTo: self.cardView.topAnchor),
            self.alertIcon.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor),
            self.alertIcon.heightAnchor.constraint(equalToConstant: 150),
            self.alertIcon.widthAnchor.constraint(equalToConstant: 150),
//
            self.titleText.topAnchor.constraint(equalTo: self.alertIcon.bottomAnchor, constant: -30),
            self.titleText.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 30),
            self.titleText.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -30),
            
            contentFormViewStack.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 40),
            contentFormViewStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            contentFormViewStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            
            self.shareActionView.topAnchor.constraint(equalTo: contentFormViewStack.bottomAnchor),
            self.shareActionView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            self.shareActionView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            
            
            self.confirmButton.topAnchor.constraint(equalTo: self.shareActionView.bottomAnchor),
            self.confirmButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 30),
            self.confirmButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -30),
            self.confirmButton.heightAnchor.constraint(equalToConstant: 50),
            self.confirmButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -20)
        ])
    }
    
    private func updateTitle(){
        switch operationType {
        case .ConsultaMovimiento,.ConsultaSaldo:
            titleText.text = "Transacción exitosa"
            break
        case .DepositCuenta, .DepositTarjeta:
            titleText.text = "Depósito exitoso"
            break
        case .PrestaPrenda, .CrediteCard, .Credite:
            titleText.text = "Pago exitoso"
            break
        case .Withdraw:
            titleText.text = "Retiro exitoso"
            break
        case .OperationHistory:
            titleText.text = ""
            break
            
        default:
            break
        }
    }
    
    @objc private func finishTicketAction(_ sender: UIButton){
        delegate?.notifyShareTicketToSMS()
    }
    
}

extension BAZ_TicketViewUI: BAZ_ShareActionViewDelegate{
    public func notifyPrintTicket() {
        delegate?.notifyRePrintTicket?()
    }
    
    public func notifyShareTicketToSMS() {
        delegate?.notifyShareTicketToSMS()
    }
}
