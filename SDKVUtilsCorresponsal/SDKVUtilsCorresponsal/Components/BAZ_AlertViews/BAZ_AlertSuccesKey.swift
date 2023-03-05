//
//  BAZ_AlertSuccesKey.swift
//  SDKVUtilsCorresponsal
//
//  Created by Phinder on 08/12/22.
//

import UIKit

@objc public protocol BAZ_AlertSuccesKeyViewProtocol: AnyObject {
    @objc optional func notifyConfirmedAccepted()
}

open class BAZ_AlertSuccesKey: UIView {
    
    private var parentView: UIViewController?
    private var parentUIView: UIView?
    private var topAnchorCustom : NSLayoutConstraint?
    private var leadingAnchorCustom : NSLayoutConstraint?
    private var trailingAnchorCustom : NSLayoutConstraint?
    private var bottomAnchorCustom : NSLayoutConstraint?
    private var heightAnchorCustom : NSLayoutConstraint?
    private var centerxAnchorCustom : NSLayoutConstraint?
    public weak var delegate : BAZ_AlertSuccesKeyViewProtocol?
    
    private lazy var darkenedContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.75)
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
    
    private lazy var firstImageContent: UIButton = {
            let button = UIButton(frame: .zero)
            let image = UIImage(bazNamed: "closeIcon")
            button.setImage(image, for: UIControl.State.normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            button.tintColor = BAZ_ColorManager.grayDarkRW
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(self.optionalCancelAction(_:)), for: .touchUpInside)
            return button
        }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(bazNamed: "alertSuccessIcon")
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
        label.font = UIFont.Poppins_Regular_16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 16
        button.setTitleColor(BAZ_ColorManager.noneSpaceRW, for: .normal)
        button.setTitle("Continuar", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.Poppins_Bold_16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = BAZ_ColorManager.greenDarkRW
        return button
    }()
    
    public convenience init(parent: UIViewController?,
                            parentUIView: UIView? = nil,
                            delegate: BAZ_AlertSuccesKeyViewProtocol?,
                            title: String,
                            message: String){
        self.init(frame: UIScreen.main.bounds)
        
        self.tag = self.tag == 0 ? tag : self.tag
        
        self.backgroundColor = .clear
        self.alpha = 0
        
        self.parentView = parent
        self.parentUIView = parentUIView
        
        if self.parentView == nil && self.parentUIView == nil {
            return
        }
              
        self.delegate = delegate
        self.titleTextLabel.text = title
        self.contentTextLabel.text = message
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
        self.cardView.addSubview(firstImageContent)
        self.cardView.addSubview(imageView)
        self.cardView.addSubview(contentTextLabel)
        self.cardView.addSubview(titleTextLabel)
        self.cardView.addSubview(confirmButton)
      
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
            
            self.firstImageContent.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 10),
            self.firstImageContent.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            self.firstImageContent.heightAnchor.constraint(equalToConstant: 30),
            
            self.imageView.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 20),
            self.imageView.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: 100),
            
            self.titleTextLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 10),
            self.titleTextLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            self.titleTextLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            
            self.contentTextLabel.topAnchor.constraint(equalTo: self.titleTextLabel.bottomAnchor, constant: 10),
            self.contentTextLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            self.contentTextLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            
            self.confirmButton.topAnchor.constraint(equalTo: self.contentTextLabel.bottomAnchor, constant: 20),
            self.confirmButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -50),
            self.confirmButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.6),
            self.confirmButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ])
    }
    
    @objc private func continueAction(_ sender: UIButton){
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0
        } completion: { completed in
            self.delegate?.notifyConfirmedAccepted?()
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

