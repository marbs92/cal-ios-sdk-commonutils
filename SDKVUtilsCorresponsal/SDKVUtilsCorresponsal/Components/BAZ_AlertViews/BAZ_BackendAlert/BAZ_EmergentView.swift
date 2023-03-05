//
//  BAZ_EmergentView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Phinder on 07/12/22.
//

import UIKit



open class BAZ_EmergentView: UIView {
    
    private var parentView: UIViewController?
    private var parentUIView: UIView?
    private var buttonInfoReference: UIButton?
    private var topAnchorCustom : NSLayoutConstraint?
    private var leadingAnchorCustom : NSLayoutConstraint?
    private var trailingAnchorCustom : NSLayoutConstraint?
    private var bottomAnchorCustom : NSLayoutConstraint?
    private var heightAnchorCustom : NSLayoutConstraint?
    private var centerxAnchorCustom : NSLayoutConstraint?
    
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 17
        view.layer.shadowOffset = CGSize(width: 0.1, height: 3)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.backgroundColor = BAZ_ColorManager.yellowTicket
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.Poppins_Semibold_14
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public convenience init(parent: UIViewController?,
                            parentUIView: UIView? = nil,
                            buttonInfoReference: UIButton,
                            title: String){
        self.init(frame: UIScreen.main.bounds)
        
        self.tag = self.tag == 0 ? tag : self.tag
        
        self.alpha = 0
        
        self.alpha = 0
        
        self.parentView = parent
        self.parentUIView = parentUIView
        self.titleTextLabel.text = title
        self.buttonInfoReference = buttonInfoReference
        
        if self.parentView == nil && self.parentUIView == nil {
            return
        }
        
        
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
        let tap = UITapGestureRecognizer(target: self, action:  #selector(optionalCancelAction(_:)))
        self.addGestureRecognizer(tap)
        
        self.addSubview(containerView)
        self.containerView.addSubview(cardView)
   
        self.cardView.addSubview(titleTextLabel)
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
            
            self.containerView.topAnchor.constraint(equalTo: topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            self.cardView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 140),
            self.cardView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -25),
            self.cardView.bottomAnchor.constraint(equalTo: self.buttonInfoReference?.topAnchor ?? self.centerYAnchor, constant: -10),
            self.cardView.heightAnchor.constraint(equalToConstant: 70),
            
            self.titleTextLabel.topAnchor.constraint(equalTo: self.cardView.topAnchor),
            self.titleTextLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.titleTextLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.titleTextLabel.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
            
        ])
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

