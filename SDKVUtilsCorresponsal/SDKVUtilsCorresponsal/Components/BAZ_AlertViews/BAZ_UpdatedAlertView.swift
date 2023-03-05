//
//  BAZ_UpdatedAlertView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 29/11/21.
//


import UIKit

@objc public protocol BAZ_UpdatedAlertViewProtocol: AnyObject {
    @objc optional func notifyAccept()
    @objc optional func notifyAcceptWithTag(tag: Int)
    @objc optional func notifyOptionalAccept()
    @objc optional func notifyOptionalAcceptWithTag(tag: Int)
}

open class BAZ_UpdatedAlertView: UIView {
    private weak var parentView: UIViewController?
    private weak var parentUIView: UIView?
    private var topAnchorCustom : NSLayoutConstraint?
    private var leadingAnchorCustom : NSLayoutConstraint?
    private var trailingAnchorCustom : NSLayoutConstraint?
    private var bottomAnchorCustom : NSLayoutConstraint?
    private var heightAnchorCustom : NSLayoutConstraint?
    private var centerxAnchorCustom : NSLayoutConstraint?
    public weak var delegate : BAZ_UpdatedAlertViewProtocol?
    private var showOptionalButton = false
    
    private lazy var darkenedContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
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
    
    private lazy var titleTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .Poppins_Semibold_16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .Poppins_Regular_16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var confirmButton: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(titleText: "Aceptar", textAlignment: .Center, buttonShadowColor: .clear, buttonShadowOpacity: 0, showIcon: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var optionalConfirmButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 23
        button.setTitleColor(BAZ_ColorManager.greenDarkRW, for: .normal)
        button.setTitle("Cancelar", for: UIControl.State.normal)
        button.titleLabel?.font = .Poppins_Medium_14
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    public convenience init(parent: UIViewController?,
                            parentUIView: UIView? = nil,
                            delegate: BAZ_UpdatedAlertViewProtocol?,
                            title: String,
                            message: String,
                            showOptionalButton: Bool = false,
                            optionalButtonTitleText: String = "",
                            tag: Int = 0){
        self.init(frame: UIScreen.main.bounds)
        
        self.tag = self.tag == 0 ? tag : self.tag
        
        self.alpha = 0
        
        self.parentView = parent
        self.parentUIView = parentUIView
        
        if self.parentView == nil && self.parentUIView == nil {
            return
        }
        
        self.delegate = delegate
        self.titleTextLabel.text = title
        self.contentTextLabel.text = message
        
        self.optionalConfirmButton.setTitle(optionalButtonTitleText, for: UIControl.State.normal)
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
        self.cardView.addSubview(contentTextLabel)
        self.cardView.addSubview(titleTextLabel)
        self.cardView.addSubview(confirmButton)
        if self.showOptionalButton {
            self.cardView.addSubview(optionalConfirmButton)
            optionalConfirmButton.addTarget(self, action: #selector(self.optionalContinueAction(_:)), for: .touchUpInside)
        }
    }
    
    
    fileprivate func buildConstraint(){
        /*guard let parentView = parentView?.view else {
            return
        }*/
        var auxParentView: UIView? = nil
        if self.parentView != nil {
            auxParentView = self.parentView?.view
        }else if self.parentUIView != nil {
            auxParentView = self.parentUIView
        }
        
        guard let parentView = auxParentView else{
            return
        }
        topAnchorCustom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        trailingAnchorCustom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        leadingAnchorCustom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        bottomAnchorCustom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        topAnchorCustom?.isActive = true
        trailingAnchorCustom?.isActive = true
        leadingAnchorCustom?.isActive = true
        bottomAnchorCustom?.isActive = true
        
        
        centerxAnchorCustom = NSLayoutConstraint(item: containerView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
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
            
            self.titleTextLabel.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 20),
            self.titleTextLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            self.titleTextLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            
            self.contentTextLabel.topAnchor.constraint(equalTo: self.titleTextLabel.bottomAnchor, constant: 20),
            self.contentTextLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 30),
            self.contentTextLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -30),
            
            self.confirmButton.topAnchor.constraint(equalTo: self.contentTextLabel.bottomAnchor, constant: 20),
            self.confirmButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 60),
            self.confirmButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -60),
            self.confirmButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        if self.showOptionalButton {
            NSLayoutConstraint.activate([
                self.optionalConfirmButton.topAnchor.constraint(equalTo: self.confirmButton.bottomAnchor, constant: 10),
                self.optionalConfirmButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 60),
                self.optionalConfirmButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -60),
                self.optionalConfirmButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -20),
            ])
        }else {
            NSLayoutConstraint.activate([
                self.confirmButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -20)
            ])
        }
    }
    
    @objc private func continueAction(_ sender: UIButton){
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0
        } completion: { completed in
            self.delegate?.notifyAccept?()
            self.delegate?.notifyAcceptWithTag?(tag: self.tag)
            self.topAnchorCustom?.isActive = false
            self.trailingAnchorCustom?.isActive = false
            self.leadingAnchorCustom?.isActive = false
            self.bottomAnchorCustom?.isActive = false
            self.centerxAnchorCustom?.isActive = false
            self.removeFromSuperview()
        }
        
    }
    
    @objc private func optionalContinueAction(_ sender: UIButton){
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0
        } completion: { completed in
            self.delegate?.notifyOptionalAccept?()
            self.delegate?.notifyOptionalAcceptWithTag?(tag: self.tag)
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
