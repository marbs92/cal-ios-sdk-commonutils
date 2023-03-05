//
//  BAZ_AlertWarningView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Phinder on 29/04/22.
//

import UIKit


@objc public protocol BAZ_AlertWarningViewDelegate:NSObjectProtocol {
    @objc optional func alertWarningRealoadActionWithTag(tag: Int)
    @objc optional func alertWarningBackActionWithTag(tag: Int)
    @objc optional func alertWarningRealoadAction()
    @objc optional func alertWarningBackAction()
}


open class BAZ_AlertWarningView: UIViewController {
    public weak var delegate: BAZ_AlertWarningViewDelegate?
    internal var alertTitle: String?
    
    
    private lazy var navigationBar: BAZ_NavigationView = {
        let navigationController = BAZ_NavigationView(frame: .zero)
        navigationController.translatesAutoresizingMaskIntoConstraints = false
        return navigationController
    }()
    
    private lazy var cardView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var alertImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(bazNamed: "alertWarningIcon")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy public var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Algo no está bien"
        label.font = .Poppins_Semibold_18
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentView: UIScrollView = {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.bounces = false
        return scrollview
    }()
    
    lazy public var subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "La operación no se ha realizado con éxito, por favor vuelve a intentarlo"
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.font = .Poppins_Semibold_18
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var retryButton: BAZ_UpdatedButtonView = {
        let btn = BAZ_UpdatedButtonView(titleText: "Reintentar",
                                        textAlignment: .Center,
                                        showIcon: false)
        btn.addTarget(self, action: #selector(self.reloadAction(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setEnableButton(enable: true)
        return btn
    }()
    
    private lazy var backButton: BAZ_UpdatedButtonView = {
        let btn = BAZ_UpdatedButtonView(titleText: "Regresar",
                                        textAlignment: .Center,
                                        buttonBackgroundColor: .clear,
                                        buttonSecondBackgroundColor: .clear,
                                        buttonTintColor: BAZ_ColorManager.navyBlueDarkRW,
                                        showIcon: false)
        btn.addTarget(self, action: #selector(self.returnAction(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setEnableButton(enable: true)
        return btn
    }()
    

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationBar.setComponents(title: self.alertTitle ?? "baz acepta pago",
                                         navigationController: nil,
                                         hiddenBackButton: true)
        
        self.setupUIElements()
        self.setupConstraints()
    }
    
    fileprivate func setupUIElements() {
        self.view.addSubview(self.navigationBar)
        self.view.addSubview(self.cardView)
        
        self.cardView.addSubview(self.alertImage)
        self.cardView.addSubview(self.titleLabel)
        self.cardView.addSubview(self.contentView)
        
        self.contentView.addSubview(self.subtitleLabel)
        
        self.cardView.addSubview(self.retryButton)
        self.cardView.addSubview(self.backButton)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.navigationBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.cardView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor, constant: 60 * UIDevice.screenMultiplier),
            self.cardView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.70),
            self.cardView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.cardView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            self.alertImage.topAnchor.constraint(equalTo: self.cardView.topAnchor),
            self.alertImage.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor),
            self.alertImage.heightAnchor.constraint(equalToConstant: 95 * UIDevice.screenMultiplier),
            self.alertImage.widthAnchor.constraint(equalToConstant: 95 * UIDevice.screenMultiplier),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.alertImage.bottomAnchor, constant: 30 * UIDevice.screenMultiplier),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),

            self.contentView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 30 * UIDevice.screenMultiplier),
            self.contentView.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.retryButton.topAnchor, constant: -20),
            
            self.subtitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.subtitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.subtitleLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.subtitleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

            self.retryButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.retryButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.retryButton.bottomAnchor.constraint(equalTo: self.backButton.topAnchor, constant: -15),
            self.retryButton.heightAnchor.constraint(equalToConstant: 50),

            self.backButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.backButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.backButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
            self.backButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        self.navigationBar.addBorder()
    }
    
    
    @objc private func reloadAction(_ sender: UIButton){
        dismiss(animated: true, completion: {
            self.delegate?.alertWarningRealoadAction?()
            self.delegate?.alertWarningRealoadActionWithTag?(tag: self.view.tag)
        })
    }
    
    @objc private func returnAction(_ sender: UIButton){
        dismiss(animated: true, completion: {
            self.delegate?.alertWarningBackAction?()
            self.delegate?.alertWarningBackActionWithTag?(tag: self.view.tag)
        })
    }
}

