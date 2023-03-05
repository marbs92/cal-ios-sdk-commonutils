//
//  BAZ_RejectionTicketAlertViewUI.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 09/02/22.
//

import Foundation
import UIKit

protocol BAZ_RejectionTicketAlertViewUIDelegate {
    func notifyShareRejectionTicket()
    func notifyExit()
}

class BAZ_RejectionTicketAlertViewUI: UIView{
    var delegate: BAZ_RejectionTicketAlertViewUIDelegate?
    
    private var customMessage: [String]?
    
    private var shareButtonHeightAnchor = NSLayoutConstraint()
    
    public var withErroMessage  :   [String]?
    public var rejectionTicket  :   BAZ_TicketStatusResponse?
    public var backButtonTitle  :   String = "Regresar"
    
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
    
    private lazy var contentFormViewScroll: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentFormViewStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var shareActionView: BAZ_ShareActionView = {
        let shareActionView = BAZ_ShareActionView(tintColor: BAZ_ColorManager.purpleToolBarRW,
                                                  withComponents: [BAZ_ShareActionType.SMS])
        shareActionView.delegate = self
        shareActionView.translatesAutoresizingMaskIntoConstraints = false
        shareActionView.isHidden = true
        return shareActionView
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
    
    public convenience init(
        delegate: BAZ_RejectionTicketAlertViewUIDelegate,
        alertTitle: String,
        customMessage: [String]?){
            self.init()
            self.delegate = delegate
            
            self.backgroundColor = BAZ_ColorManager.noneSpaceRW
            
            navigationBar.setComponents(title: alertTitle, navigationController: nil, arrowIcon: "closeIcon")
            navigationBar.assignCustomBackEvent(target: self, event: #selector(self.popNavigationAction(_:)), eventTrigger: .touchUpInside)
            
            self.customMessage = customMessage
            
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
        backButton.setTitle(backButtonTitle, for: .normal)

        // arrange subviews
        self.addSubview(contentView)
        self.addSubview(navigationBar)
        contentView.addSubview(cardView)
        cardView.addSubview(imageFailure)
        cardView.addSubview(contentFormViewScroll)
        
        contentFormViewScroll.addSubview(contentFormViewStack)
        
        cardView.addSubview(shareActionView)
        cardView.addSubview(backButton)
    }
    
    func setConstraints(){
        self.shareButtonHeightAnchor = shareActionView.heightAnchor.constraint(equalToConstant: 140)
        // add constraints to subviews
        NSLayoutConstraint.activate([
            ///NavigationBar
            navigationBar.topAnchor.constraint(equalTo: self.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            ///ScrollView
            contentView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
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
            
            contentFormViewScroll.topAnchor.constraint(equalTo: imageFailure.bottomAnchor, constant: 20),
            contentFormViewScroll.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            contentFormViewScroll.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            contentFormViewScroll.bottomAnchor.constraint(equalTo: shareActionView.topAnchor, constant: -20),
            
            contentFormViewStack.topAnchor.constraint(equalTo: contentFormViewScroll.topAnchor),
            contentFormViewStack.leadingAnchor.constraint(equalTo: contentFormViewScroll.leadingAnchor),
            contentFormViewStack.trailingAnchor.constraint(equalTo: contentFormViewScroll.trailingAnchor),
            contentFormViewStack.bottomAnchor.constraint(equalTo: contentFormViewScroll.bottomAnchor),
            contentFormViewStack.widthAnchor.constraint(equalTo: contentFormViewScroll.widthAnchor),
            
            shareActionView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -20),
            shareActionView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            shareActionView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            self.shareButtonHeightAnchor,
            
            backButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            backButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            backButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            backButton.heightAnchor.constraint(equalToConstant: 50),
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
        self.delegate?.notifyExit()
    }
    
    internal func setBackErrorMessage(msg: [String]){
        self.shareButtonHeightAnchor.constant = 0
        
        var arrayOfMessages : [String] = []
        arrayOfMessages.append("Operación fallida")
        msg.forEach { errorMessage in
            arrayOfMessages.append(errorMessage)
        }
        arrayOfMessages.append("Ocurrió un problema al realizar la operación")
        if msg.count == 0{
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
    
    internal func setRejectionTicketMessage(msg: [String]){
        var rejectionMessage: [String] = []
        if let customMessage = self.customMessage {
            rejectionMessage = customMessage
        } else {
            rejectionMessage = msg
        }
        rejectionMessage.forEach { errorMessage in
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.attributedText = errorMessage.decorative(color: BAZ_ColorManager.navyBlueDarkRW, font: .Poppins_Medium_18)
            label.textAlignment = .center
            self.contentFormViewStack.addArrangedSubview(label)
        }
        self.shareActionView.isHidden = false
    }
}

extension BAZ_RejectionTicketAlertViewUI: BAZ_ShareActionViewDelegate {
    func notifyShareTicketToSMS(){
        self.delegate?.notifyShareRejectionTicket()
    }
}
