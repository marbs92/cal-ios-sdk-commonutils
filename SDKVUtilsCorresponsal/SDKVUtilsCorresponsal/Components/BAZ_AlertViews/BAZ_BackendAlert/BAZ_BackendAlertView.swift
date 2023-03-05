//
//  BAZ_BackendAlertView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 22/11/21.
//

import UIKit

@objc public protocol BAZ_BackendAlertViewDelegate:NSObjectProtocol {
    @objc optional func realoadActionWithTag(tag: Int)
    @objc optional func backActionWithTag(tag: Int)
    @objc optional func realoadAction()
    @objc optional func backAction()
}

open class BAZ_BackendAlertView: UIViewController {
    private lazy var navigationBar: BAZ_NavigationView = {
        let navigationController = BAZ_NavigationView(frame: .zero)
        navigationController.translatesAutoresizingMaskIntoConstraints = false
        return navigationController
    }()
    
    private lazy var contentView: UIScrollView = {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    private lazy var cardView: BAZ_CardView = {
        let view = BAZ_CardView(cornerRadius: 0, shadowRadius: 0, shadowOffset: CGSize(width: 0, height: 0), shadowColor: .clear, shadowOpacity: 0, background: .clear)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageFailure: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(bazNamed: "alertErrorIcon")
        return image
    }()
    
    private lazy var contentFormViewStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var reloadAgainButton: BAZ_UpdatedButtonView = {
        let btn = BAZ_UpdatedButtonView(
            titleText: "Reintentar",
            textAlignment: .Center,
            buttonBackgroundColor: BAZ_ColorManager.whiteNavBarBackground,
            buttonSecondBackgroundColor: BAZ_ColorManager.whiteNavBarBackground,
            buttonTintColor: BAZ_ColorManager.navyBlueDarkRW,
            buttonCornerRadius: 25,
            showIcon: false)
        btn.layer.borderColor = BAZ_ColorManager.purpleToolBarRW.cgColor
        btn.layer.borderWidth = 3
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setEnableButton(enable: true)
        btn.addTarget(self, action: #selector(self.reloadAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var backButton: BAZ_UpdatedButtonView = {
        let btn = BAZ_UpdatedButtonView(
            titleText: "Regresar",
            textAlignment: .Center,
            buttonBackgroundColor: .clear,
            buttonSecondBackgroundColor: .clear,
            buttonTintColor: BAZ_ColorManager.greenDarkRW,
            buttonCornerRadius: 25,
            showIcon: false)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setEnableButton(enable: true)
        btn.addTarget(self, action: #selector(self.popNavigationAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    public weak var delegate    :   BAZ_BackendAlertViewDelegate?
    public var presenter        :   BAZ_BackendAlertPresenterProtocol?
    
    public var withTitleNav     :   String?
    public var withTitleErrorMessage : String = "Operación fallida"
    public var withErroMessage  :   [String]?
    public var withExtraErrorMessage : String = "Ocurrió un problema al realizar la operación"
    public var idTicket         :   String?
    public var rejectionTicket  :   BAZ_TicketStatusResponse?
    public var hideRetryButton  :   Bool?
    public var backButtonTitle  :   String = "Regresar"
    public var canDismissView   :   Bool = true
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BAZ_ColorManager.noneSpaceRW

        navigationBar.setComponents(title: withTitleNav ?? "",
                                    navigationController: navigationController,
                                    hiddenBackButton: !self.canDismissView,
                                    arrowIcon: "closeIcon")
        self.backButton.isHidden = !self.canDismissView
        
        navigationBar.assignCustomBackEvent(target: self, event: #selector(self.popNavigationAction(_:)), eventTrigger: .touchUpInside)
        
        setupUIElements()
        setupConstraints()
        // Do any additional setup after loading the view.
        if idTicket != nil && rejectionTicket == nil{
            presenter?.requestTicketStatus()
        }
        
        if let hideButton = hideRetryButton, hideButton == true{
            reloadAgainButton.isHidden = true
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printRejectionTicket(info: rejectionTicket)
    }

    fileprivate func setupUIElements() {
        
        backButton.setTitle(backButtonTitle, for: .normal)
        
        if idTicket != nil || rejectionTicket != nil{
            
            withErroMessage?.forEach { errorMessage in
                let label = UILabel(frame: .zero)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.numberOfLines = 0
                label.attributedText = errorMessage.decorative(color: BAZ_ColorManager.navyBlueDarkRW, font: .Poppins_Medium_18)
                label.textAlignment = .center
                self.contentFormViewStack.addArrangedSubview(label)
            }
            
        }else{
            configErrorMessages()
        }
        // arrange subviews
        view.addSubview(contentView)
        view.addSubview(navigationBar)
        contentView.addSubview(cardView)
        cardView.addSubview(imageFailure)
        cardView.addSubview(contentFormViewStack)
        cardView.addSubview(backButton)
        cardView.addSubview(reloadAgainButton)
    }
    
    fileprivate func setupConstraints() {
        // add constraints to subviews
        NSLayoutConstraint.activate([
            ///NavigationBar
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            ///ScrollView
            contentView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            ///CardView
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            imageFailure.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            imageFailure.topAnchor.constraint(equalTo: cardView.topAnchor, constant: UIScreen.main.bounds.height * 0.1 - 30),
            imageFailure.heightAnchor.constraint(equalToConstant: 150),
            imageFailure.widthAnchor.constraint(equalToConstant: 150),
            
            contentFormViewStack.topAnchor.constraint(equalTo: imageFailure.bottomAnchor, constant: 20),
            contentFormViewStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            contentFormViewStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
            backButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            backButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            backButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
            reloadAgainButton.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -20),
            reloadAgainButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            reloadAgainButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            reloadAgainButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        if(UIScreen.main.bounds.height < 660){
            NSLayoutConstraint.activate([
                self.cardView.heightAnchor.constraint(equalToConstant: 600)
            ])
        }else{
            NSLayoutConstraint.activate([
                self.cardView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -50),
            ])
        }
    }
    
    @objc private func popNavigationAction(_ sender: UIButton){
        dismiss(animated: true, completion: {
            self.delegate?.backAction?()
            self.delegate?.backActionWithTag?(tag: self.view.tag)
        })
    }
    
    @objc private func reloadAction(_ sender: UIButton){
        dismiss(animated: true, completion: {
            self.delegate?.realoadAction?()
            self.delegate?.realoadActionWithTag?(tag: self.view.tag)
        })
    }
    
    private func configErrorMessages(){
        
        var arrayOfMessages : [String] = []
        arrayOfMessages.append(withTitleErrorMessage)
        withErroMessage?.forEach { errorMessage in
            arrayOfMessages.append(errorMessage)
        }
        arrayOfMessages.append(withExtraErrorMessage)
        if withErroMessage?.count == 0{
            for (pos,ite) in arrayOfMessages.enumerated(){
                let label = UILabel(frame: .zero)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.numberOfLines = 0
                label.attributedText =
                pos == 0 ?
                ite.decorative(color: BAZ_ColorManager.redError, font: .Poppins_Bold_22) :
                ite.decorative(color: BAZ_ColorManager.navyBlueDarkRW, font: .Poppins_Medium_18)
                label.textAlignment = .center
                self.contentFormViewStack.addArrangedSubview(label)
            }
        }else{
            for (pos,ite) in arrayOfMessages.enumerated(){
                let label = UILabel(frame: .zero)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.numberOfLines = 0
                label.attributedText =
                pos == 0 ?
                ite.decorative(color: BAZ_ColorManager.redError, font: .Poppins_Bold_22) :
                pos == (arrayOfMessages.count - 1) ?
                ite.decorative(color: BAZ_ColorManager.navyBlueDarkRW, font: .Poppins_Medium_18) :
                ite.decorative(color: BAZ_ColorManager.grayRW, font: .Poppins_Medium_16)
                label.textAlignment = .center
                self.contentFormViewStack.addArrangedSubview(label)
            }
        }
    }
    
    private func printRejectionTicket(info: BAZ_TicketStatusResponse?){
        if let ticketInfo = info{
//            let rejectionTicket = BAZ_RejectionTicketView(data: ticketInfo)
//            let view = BAZ_AlertPrinterMain.createModule(infoToPrint: rejectionTicket.asImage())
//            view.modalPresentationStyle = .overFullScreen
//            present(view, animated: false, completion: nil)
        }
    }
}

extension BAZ_BackendAlertView: BAZ_BackendAlertViewProtocol{
    func showLoading() {
        BAZ_UILoaderESAN.show(parent: self.view)
    }
    
    func dissmissLoading() {
        BAZ_UILoaderESAN.remove(parent: self.view)
    }
    
    func displayFailureMessage(message: String) {
        _ = BAZ_UpdatedAlertView(parent: self, delegate: nil, title: "Información", message: message)
    }
    
    func displayTicketStatus(ticket: BAZ_TicketStatusResponse?) {
        self.printRejectionTicket(info: ticket)
    }
}
