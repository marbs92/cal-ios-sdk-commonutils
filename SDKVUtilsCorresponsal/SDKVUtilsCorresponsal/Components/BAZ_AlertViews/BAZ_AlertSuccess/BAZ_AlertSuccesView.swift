//
//  BAZ_AlertsuccesView.swift
//  Registro
//
//  Created by Phinder 2022 on 19/07/22.
//

import UIKit

@objc public protocol BAZ_AlertSuccessViewDelegate:NSObjectProtocol {
    @objc optional func alertSuccessAcceptActionWithTag(tag: Int)
    @objc optional func alertSuccessAcceptAction()
}


open class BAZ_AlertSuccessView: UIViewController {
    public weak var delegate: BAZ_AlertSuccessViewDelegate?
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
        image.image = UIImage(bazNamed: "alertSuccessIcon")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Operación Exitosa"
        label.font = .Poppins_Semibold_18
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentScroll: UIScrollView = {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.bounces = false
        return scrollview
    }()
    
    public lazy var subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "La operación se ha realizado con éxito"
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.font = .Poppins_Semibold_18
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = ""
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.font = .Poppins_Regular_15
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var acceptButton: BAZ_UpdatedButtonView = {
        let btn = BAZ_UpdatedButtonView(titleText: "Aceptar",
                                        textAlignment: .Center,
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
        self.cardView.addSubview(self.contentScroll)
        
        self.contentScroll.addSubview(self.subtitleLabel)
        self.contentScroll.addSubview(self.descriptionLabel)
        
        self.cardView.addSubview(self.acceptButton)
    }
    
    fileprivate func setupConstraints() {
        // add constraints to subviews
        NSLayoutConstraint.activate([
            self.navigationBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.cardView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor, constant: 60 * UIDevice.screenMultiplier),
            self.cardView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.70),
            self.cardView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.cardView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            self.alertImage.topAnchor.constraint(equalTo: self.cardView.topAnchor),
            self.alertImage.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor),
            self.alertImage.heightAnchor.constraint(equalToConstant: 95 * UIDevice.screenMultiplier),
            self.alertImage.widthAnchor.constraint(equalToConstant: 95 * UIDevice.screenMultiplier),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.alertImage.bottomAnchor, constant: 30 * UIDevice.screenMultiplier),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            
            self.contentScroll.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 30 * UIDevice.screenMultiplier),
            self.contentScroll.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.contentScroll.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.contentScroll.bottomAnchor.constraint(equalTo: self.acceptButton.topAnchor, constant: -20),
            
            self.subtitleLabel.topAnchor.constraint(equalTo: self.contentScroll.topAnchor),
            self.subtitleLabel.leadingAnchor.constraint(equalTo: self.contentScroll.leadingAnchor),
            self.subtitleLabel.widthAnchor.constraint(equalTo: self.contentScroll.widthAnchor),
            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.contentScroll.trailingAnchor),
            
            self.descriptionLabel.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor, constant: 20),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.contentScroll.leadingAnchor),
            self.descriptionLabel.widthAnchor.constraint(equalTo: self.contentScroll.widthAnchor),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.contentScroll.trailingAnchor),
            self.descriptionLabel.bottomAnchor.constraint(equalTo: self.contentScroll.bottomAnchor),

            self.acceptButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.acceptButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.acceptButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
            self.acceptButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        self.navigationBar.addBorder()
    }
    
    @objc private func returnAction(_ sender: UIButton){
        dismiss(animated: true, completion: {
            self.delegate?.alertSuccessAcceptAction?()
            self.delegate?.alertSuccessAcceptActionWithTag?(tag: self.view.tag)
        })
    }
}

