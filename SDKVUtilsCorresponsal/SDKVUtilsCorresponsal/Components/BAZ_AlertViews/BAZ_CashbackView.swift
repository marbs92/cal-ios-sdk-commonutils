//
//  ASAP_AlertView.swift
//  GSSAAceptaPago
//
//  Created by Luis Fernando Sánchez Palma on 19/04/22.
//

import UIKit

@objc public protocol BAZ_CashbackViewProtocol: AnyObject {
    @objc optional func notifyCashbackAccept()
    @objc optional func notifyCashbackAcceptWithTag(tag: Int)
    @objc optional func notifyCashbackCancel()
    @objc optional func notifyCashbackCancelWithTag(tag: Int)
}

open class BAZ_CashbackView: UIView {
    
    private var parentView: UIViewController?
    private var parentUIView: UIView?
    private var topAnchorCustom : NSLayoutConstraint?
    private var leadingAnchorCustom : NSLayoutConstraint?
    private var trailingAnchorCustom : NSLayoutConstraint?
    private var bottomAnchorCustom : NSLayoutConstraint?
    private var heightAnchorCustom : NSLayoutConstraint?
    private var centerxAnchorCustom : NSLayoutConstraint?
    public weak var delegate : BAZ_CashbackViewProtocol?
    private var showOptionalButton = false
    
    private lazy var darkenedContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.7831427191, green: 0.7831427191, blue: 0.7831427191, alpha: 0.5)
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var cardView: BAZ_CardView = {
        let view = BAZ_CardView(cornerRadius: 13, shadowRadius: 0, shadowColor: .clear, shadowOpacity: 0, background: .white)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(bazNamed: "ticketCoinIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.Poppins_Semibold_16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.Poppins_Regular_14
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.8980392157, blue: 0.937254902, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var secondSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.8980392157, blue: 0.937254902, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 23
        button.setTitleColor(BAZ_ColorManager.blue1, for: .normal)
        button.setTitle("Aceptar", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.Poppins_Medium_14
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var optionalConfirmButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 23
        button.setTitleColor(BAZ_ColorManager.blue1, for: .normal)
        button.setTitle("Cancelar", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.Poppins_Medium_14
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    public convenience init(parent: UIViewController?,
                            parentUIView: UIView? = nil,
                            delegate: BAZ_CashbackViewProtocol?,
                            title: String,
                            message: String,
                            showOptionalButton: Bool = false,
                            optionalButtonTitleText: String = "",
                            secondOptionalButtonTitleText: String = "",
                            tag: Int = 0){
        self.init(frame: UIScreen.main.bounds)
        
        self.tag = self.tag == 0 ? tag : self.tag
        
        self.alpha = 0
        
        self.alpha = 0
        
        self.parentView = parent
        self.parentUIView = parentUIView
        
        if self.parentView == nil && self.parentUIView == nil {
            return
        }
        
        self.delegate = delegate
        self.titleTextLabel.text = title
        self.contentTextLabel.text = message
        
        self.confirmButton.setTitle(optionalButtonTitleText, for: UIControl.State.normal)
        
        self.optionalConfirmButton.setTitle(secondOptionalButtonTitleText, for: UIControl.State.normal)
        self.showOptionalButton = showOptionalButton
        
        self.buildUI()
        self.buildConstraint()
        parentView?.dismissKeyboard()
        endEditing(true)
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController{
            rootViewController.view.endEditing(true)
            rootViewController.dismissKeyboard()
        }
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func buildUI(){
        if self.parentView != nil {
            self.parentView?.view.addSubview(self)
        }else if self.parentUIView != nil {
            self.parentUIView?.addSubview(self)
        }else {
            return
        }
        self.confirmButton.addTarget(self, action: #selector(self.continueAction(_:)), for: .touchUpInside)
        self.addSubview(darkenedContainerView)
        self.addSubview(containerView)
        self.containerView.addSubview(cardView)
        self.cardView.addSubview(imageView)
        self.cardView.addSubview(contentTextLabel)
        self.cardView.addSubview(titleTextLabel)
        self.cardView.addSubview(separatorView)
        self.cardView.addSubview(confirmButton)
        if self.showOptionalButton {
            self.cardView.addSubview(secondSeparatorView)
            self.cardView.addSubview(optionalConfirmButton)
            optionalConfirmButton.addTarget(self, action: #selector(self.optionalCancelAction(_:)), for: .touchUpInside)
        }
    }
    
    
    fileprivate func buildConstraint(){
        
        var auxParentView: UIView? = nil
        if self.parentView != nil {
            auxParentView = self.parentView?.view
        }else if self.parentUIView != nil {
            auxParentView = self.parentUIView
        }
        
        guard let parentView = auxParentView else{
            return
        }
        
        topAnchorCustom = self.topAnchor.constraint(equalTo: parentView.topAnchor)
        trailingAnchorCustom = self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        leadingAnchorCustom = self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor)
        bottomAnchorCustom = self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        centerxAnchorCustom = containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        topAnchorCustom?.isActive = true
        trailingAnchorCustom?.isActive = true
        leadingAnchorCustom?.isActive = true
        bottomAnchorCustom?.isActive = true
        centerxAnchorCustom?.isActive = true
        
        NSLayoutConstraint.activate([
            
            self.darkenedContainerView.topAnchor.constraint(equalTo: topAnchor),
            self.darkenedContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.darkenedContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.darkenedContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            self.containerView.topAnchor.constraint(equalTo: topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            self.cardView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 40),
            self.cardView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -40),
            self.cardView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.cardView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            
            self.imageView.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 20),
            self.imageView.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: 100),
            
            self.titleTextLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20),
            self.titleTextLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            self.titleTextLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            
            self.contentTextLabel.topAnchor.constraint(equalTo: self.titleTextLabel.bottomAnchor, constant: 20),
            self.contentTextLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 15),
            self.contentTextLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -15),
            
            self.separatorView.topAnchor.constraint(equalTo: self.contentTextLabel.bottomAnchor, constant: 20),
            self.separatorView.heightAnchor.constraint(equalToConstant: 1),
            self.separatorView.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.separatorView.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            
        ])
        
        if self.showOptionalButton {
            NSLayoutConstraint.activate([
                self.secondSeparatorView.topAnchor.constraint(equalTo: self.separatorView.bottomAnchor),
                self.secondSeparatorView.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
                self.secondSeparatorView.widthAnchor.constraint(equalToConstant: 1),
                self.secondSeparatorView.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor),
                
                self.confirmButton.topAnchor.constraint(equalTo: self.separatorView.bottomAnchor),
                self.confirmButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
                self.confirmButton.trailingAnchor.constraint(equalTo: self.secondSeparatorView.trailingAnchor),
                self.confirmButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
                self.confirmButton.heightAnchor.constraint(equalToConstant: 50),
                
                self.optionalConfirmButton.topAnchor.constraint(equalTo: self.separatorView.bottomAnchor),
                self.optionalConfirmButton.leadingAnchor.constraint(equalTo: self.secondSeparatorView.leadingAnchor),
                self.optionalConfirmButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
                self.optionalConfirmButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
                self.optionalConfirmButton.heightAnchor.constraint(equalToConstant: 50),
            ])
        }else {
            NSLayoutConstraint.activate([
                self.confirmButton.topAnchor.constraint(equalTo: self.separatorView.bottomAnchor, constant: 5),
                self.confirmButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 60),
                self.confirmButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -60),
                self.confirmButton.heightAnchor.constraint(equalToConstant: 50),
                self.confirmButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -5)
            ])
        }
    }
    
    @objc private func continueAction(_ sender: UIButton){
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0
        } completion: { completed in
            self.delegate?.notifyCashbackAccept?()
            self.delegate?.notifyCashbackAcceptWithTag?(tag: self.tag)
            self.topAnchorCustom?.isActive = false
            self.trailingAnchorCustom?.isActive = false
            self.leadingAnchorCustom?.isActive = false
            self.bottomAnchorCustom?.isActive = false
            self.centerxAnchorCustom?.isActive = false
            self.removeFromSuperview()
        }
        
    }
    
    @objc private func optionalCancelAction(_ sender: UIButton){
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0
        } completion: { completed in
            self.delegate?.notifyCashbackCancel?()
            self.delegate?.notifyCashbackCancelWithTag?(tag: self.tag)
            self.topAnchorCustom?.isActive = false
            self.trailingAnchorCustom?.isActive = false
            self.leadingAnchorCustom?.isActive = false
            self.bottomAnchorCustom?.isActive = false
            self.centerxAnchorCustom?.isActive = false
            self.removeFromSuperview()
        }
    }
    
    public func updateMessage(_ msg: String){
        titleTextLabel.text = msg
    }
}

