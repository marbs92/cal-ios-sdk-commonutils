//
//  ASAP_AlertView.swift
//  GSSAAceptaPago
//
//  Created by Luis Fernando Sánchez Palma on 19/04/22.
//

import UIKit

open class BAZ_RecomendationsAlert: UIView {
    
    private var parentView: UIViewController?
    private var parentUIView: UIView?
    private var topAnchorCustom : NSLayoutConstraint?
    private var leadingAnchorCustom : NSLayoutConstraint?
    private var trailingAnchorCustom : NSLayoutConstraint?
    private var bottomAnchorCustom : NSLayoutConstraint?
    private var heightAnchorCustom : NSLayoutConstraint?
    private var centerxAnchorCustom : NSLayoutConstraint?
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
        let view = BAZ_CardView(cornerRadius: 18, shadowRadius: 0, shadowColor: .clear, shadowOpacity: 0, background: .white)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.greenHightDarkRW
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.Poppins_Semibold_17
        label.text = "Recomendaciones"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 23
        button.tintColor = BAZ_ColorManager.grayDarkRW
        button.setImage(UIImage(bazNamed: "closeIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action:  #selector(self.closeAction(_:)), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var contentTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.Poppins_Regular_16
        label.text = "Para que el nombre de tu \n comercio sea legible te \n mostramos algunos ejemplos: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    inicio tabla de sugerencias
    
    private lazy var containerTableView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageU1: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(bazNamed: "closeIcon")
        imageView.tintColor = BAZ_ColorManager.redError
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var u1Label: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.Poppins_Semibold_16
        label.text = "Abarrotes"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageU2: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(bazNamed: "closeIcon")
        imageView.tintColor = BAZ_ColorManager.redError
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var u2Label: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.Poppins_Semibold_16
        label.text = "Doña Bety"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageC1: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(bazNamed: "closeIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = BAZ_ColorManager.greenDarkRW
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var c1Label: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.Poppins_Semibold_16
        label.text = "Abarrotes Doña Bety"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageU3: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(bazNamed: "closeIcon")
        imageView.tintColor = BAZ_ColorManager.redError
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var u3Label: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.Poppins_Semibold_16
        label.text = "Consultorio"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageU4: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(bazNamed: "closeIcon")
        imageView.tintColor = BAZ_ColorManager.redError
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var u4Label: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.Poppins_Semibold_16
        label.text = "San Antonio"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageC2: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(bazNamed: "closeIcon")
        imageView.tintColor = BAZ_ColorManager.greenDarkRW
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var c2Label: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.Poppins_Semibold_16
        label.text = "Consultorio Dental San \n Antonio"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
//fin de la tabla
    
    lazy var confirmButton: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(
            titleText: "Continuar",
            titleFont: .Poppins_Bold_16,
            textAlignment: .Center,
            buttonBackgroundColor: BAZ_ColorManager.greenDarkRW,
            buttonCornerRadius: 17.5,
            buttonShadowOpacity: 0,
            showIcon: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setEnableButton(enable: true)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
        
        
    }()
    
    public convenience init(parent: UIViewController?,
                            parentUIView: UIView? = nil,
                            tag: Int = 0){
        self.init(frame: UIScreen.main.bounds)
        
        self.tag = self.tag == 0 ? tag : self.tag
        
        self.alpha = 0
        
        self.parentView = parent
        self.parentUIView = parentUIView
        
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
        self.addSubview(darkenedContainerView)
        self.addSubview(containerView)
        self.containerView.addSubview(cardView)
        self.cardView.addSubview(contentTextLabel)
        self.cardView.addSubview(titleTextLabel)
//        inicio de la tabla
        self.cardView.addSubview(containerTableView)
        self.containerTableView.addSubview(imageU1)
        self.containerTableView.addSubview(u1Label)
        self.containerTableView.addSubview(imageU2)
        self.containerTableView.addSubview(u2Label)
        self.containerTableView.addSubview(imageC1)
        self.containerTableView.addSubview(c1Label)
        
        self.containerTableView.addSubview(imageU3)
        self.containerTableView.addSubview(u3Label)
        self.containerTableView.addSubview(imageU4)
        self.containerTableView.addSubview(u4Label)
        self.containerTableView.addSubview(imageC2)
        self.containerTableView.addSubview(c2Label)
//        fin de la tabla
        self.cardView.addSubview(confirmButton)
        self.cardView.addSubview(closeButton)
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
            
            self.titleTextLabel.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 20),
            self.titleTextLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            self.titleTextLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            
            self.contentTextLabel.topAnchor.constraint(equalTo: self.titleTextLabel.bottomAnchor, constant: 20),
            self.contentTextLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 15),
            self.contentTextLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -15),
            
            self.containerTableView.topAnchor.constraint(equalTo: contentTextLabel.bottomAnchor, constant: 7),
            self.containerTableView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            self.containerTableView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -15),
            
            self.imageU1.topAnchor.constraint(equalTo: containerTableView.topAnchor, constant: 13),
            self.imageU1.leadingAnchor.constraint(equalTo: containerTableView.leadingAnchor),
            self.imageU1.heightAnchor.constraint(equalToConstant: 10),
            self.imageU1.widthAnchor.constraint(equalToConstant: 10),
            
            self.u1Label.centerYAnchor.constraint(equalTo: imageU1.centerYAnchor),
            self.u1Label.leadingAnchor.constraint(equalTo: imageU1.trailingAnchor, constant: 8),
            self.u1Label.trailingAnchor.constraint(equalTo: containerTableView.trailingAnchor),
            
            self.imageU2.topAnchor.constraint(equalTo: u1Label.bottomAnchor, constant: 13),
            self.imageU2.leadingAnchor.constraint(equalTo: containerTableView.leadingAnchor),
            self.imageU2.heightAnchor.constraint(equalToConstant: 10),
            self.imageU2.widthAnchor.constraint(equalToConstant: 10),
            
            self.u2Label.centerYAnchor.constraint(equalTo: imageU2.centerYAnchor),
            self.u2Label.leadingAnchor.constraint(equalTo: u1Label.leadingAnchor),
            self.u2Label.trailingAnchor.constraint(equalTo: containerTableView.trailingAnchor),
            
            self.imageC1.topAnchor.constraint(equalTo: u2Label.bottomAnchor, constant: 13),
            self.imageC1.leadingAnchor.constraint(equalTo: containerTableView.leadingAnchor),
            self.imageC1.heightAnchor.constraint(equalToConstant: 14),
            self.imageC1.widthAnchor.constraint(equalToConstant: 14),
            
            self.c1Label.centerYAnchor.constraint(equalTo: imageC1.centerYAnchor),
            self.c1Label.leadingAnchor.constraint(equalTo: u1Label.leadingAnchor),
            self.c1Label.trailingAnchor.constraint(equalTo: containerTableView.trailingAnchor),
            
            
            self.imageU3.topAnchor.constraint(equalTo: c1Label.bottomAnchor, constant: 37.6),
            self.imageU3.leadingAnchor.constraint(equalTo: containerTableView.leadingAnchor),
            self.imageU3.heightAnchor.constraint(equalToConstant: 10),
            self.imageU3.widthAnchor.constraint(equalToConstant: 10),
            
            self.u3Label.centerYAnchor.constraint(equalTo: imageU3.centerYAnchor),
            self.u3Label.leadingAnchor.constraint(equalTo: u1Label.leadingAnchor),
            self.u3Label.trailingAnchor.constraint(equalTo: containerTableView.trailingAnchor),
            
            self.imageU4.topAnchor.constraint(equalTo: u3Label.bottomAnchor, constant: 13),
            self.imageU4.leadingAnchor.constraint(equalTo: containerTableView.leadingAnchor),
            self.imageU4.heightAnchor.constraint(equalToConstant: 10),
            self.imageU4.widthAnchor.constraint(equalToConstant: 10),
            
            self.u4Label.centerYAnchor.constraint(equalTo: imageU4.centerYAnchor),
            self.u4Label.leadingAnchor.constraint(equalTo: u1Label.leadingAnchor),
            self.u4Label.trailingAnchor.constraint(equalTo: containerTableView.trailingAnchor),
            
            self.imageC2.topAnchor.constraint(equalTo: u4Label.bottomAnchor, constant: 11),
            self.imageC2.leadingAnchor.constraint(equalTo: containerTableView.leadingAnchor),
            self.imageC2.heightAnchor.constraint(equalToConstant: 14),
            self.imageC2.widthAnchor.constraint(equalToConstant: 14),
            
            self.c2Label.topAnchor.constraint(equalTo: imageC2.topAnchor, constant: -2),
            self.c2Label.leadingAnchor.constraint(equalTo: u1Label.leadingAnchor),
            self.c2Label.trailingAnchor.constraint(equalTo: containerTableView.trailingAnchor),
            
            self.confirmButton.topAnchor.constraint(equalTo: self.imageC2.bottomAnchor, constant: 51.6),
            self.confirmButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 60),
            self.confirmButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -60),
            self.confirmButton.heightAnchor.constraint(equalToConstant: 35),
            self.confirmButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -28),
            
            self.closeButton.centerYAnchor.constraint(equalTo: self.titleTextLabel.centerYAnchor),
            self.closeButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -23),
            self.closeButton.widthAnchor.constraint(equalToConstant: 25),
            self.closeButton.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    @objc private func closeAction(_ sender: UIButton){
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

