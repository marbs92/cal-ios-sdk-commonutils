//
//  OBD_ProofAdressObdPreviewViewUI.swift
//  SDKVOnbordingBAZ
//
//  Created by Phinder on 29/12/22.
//

import UIKit

protocol BAZ_ProofAdressPreviewViewUIDelegate: AnyObject {
    func notifyTakePhoto()
    func notifyContinue()
}

class BAZ_ProofAdressPreviewViewUI: UIView{
    private weak var delegate: BAZ_ProofAdressPreviewViewUIDelegate?
    private var verticalMultiplier: CGFloat = 1.0
    
    lazy var navigationBar: BAZ_NavigationView = {
        let navigationController = BAZ_NavigationView(frame: .zero)
        navigationController.translatesAutoresizingMaskIntoConstraints = false
        return navigationController
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(bazNamed: "identificationBackgroundIcon")
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var containerScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .clear
        return scroll
    }()
    
    lazy var titleText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = BAZ_ColorManager.onboardingDark
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.text = "Revisa que la imagen sea legible, no sea mayor a 3 meses de vigencia y coincida con la dirección registrada"
        label.font = UIFont.Poppins_Bold_22
        return label
    }()
    
    lazy var subTitleText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = BAZ_ColorManager.onboardingDark
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "¿Deseas continuar?"
        label.font = UIFont.Poppins_Semibold_18
        return label
    }()
    
    lazy var proofOfAddressPreview : UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    lazy var continueButton: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(titleText: "Continuar",
                                           textAlignment: .Left,
                                           showIcon: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.continueAction), for: .touchUpInside)
        return button
    }()
    
    lazy var takeAgainButton: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(titleText: "Tomar nueva fotografía",
                                           titleFont: UIFont.Poppins_Bold_18,
                                           textAlignment: .Center,
                                           buttonBackgroundColor: .clear,
                                           buttonSecondBackgroundColor: .clear,
                                           buttonTintColor: BAZ_ColorManager.onboardingBlack,
                                           showIcon: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.takeAgainAction), for: .touchUpInside)
        return button
    }()
    
    public convenience init(navigation: UINavigationController?,
                            delegate: BAZ_ProofAdressPreviewViewUIDelegate){
        self.init()
        self.delegate = delegate
        navigationBar.setComponents(title: "Comprobante de domicilio", navigationController: navigation)
        navigationBar.assignCustomBackEvent(target: self, event: #selector(self.dismissView(_:)), eventTrigger: .touchUpInside)
        
        self.verticalMultiplier = UIScreen.main.bounds.height > 667 ? 1 : 0.70
        
        self.setUI()
        self.setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUI(){
        self.addSubview(backgroundImageView)
        
        backgroundImageView.addSubview(containerScroll)
        self.containerScroll.addSubview(self.cardView)
        
        cardView.addSubview(titleText)
        cardView.addSubview(subTitleText)
        cardView.addSubview(proofOfAddressPreview)
        cardView.addSubview(takeAgainButton)
        cardView.addSubview(continueButton)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([

            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            containerScroll.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            containerScroll.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            containerScroll.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            containerScroll.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            
            cardView.topAnchor.constraint(equalTo: containerScroll.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: containerScroll.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: containerScroll.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: containerScroll.bottomAnchor),
            cardView.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            titleText.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 50 * self.verticalMultiplier),
            titleText.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            titleText.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            
            subTitleText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 20 * self.verticalMultiplier),
            subTitleText.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            subTitleText.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            
            proofOfAddressPreview.topAnchor.constraint(equalTo: subTitleText.bottomAnchor, constant: 20 * self.verticalMultiplier),
            proofOfAddressPreview.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            proofOfAddressPreview.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            proofOfAddressPreview.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.5)),
            
            continueButton.topAnchor.constraint(equalTo: proofOfAddressPreview.bottomAnchor, constant: 20 * self.verticalMultiplier),
            continueButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            continueButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            
            takeAgainButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 10 * self.verticalMultiplier),
            takeAgainButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            takeAgainButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            takeAgainButton.heightAnchor.constraint(equalToConstant: 50),
            self.takeAgainButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -20 * self.verticalMultiplier)
        ])
    }
    
    @objc func dismissView(_ sender: UIButton){
        delegate?.notifyTakePhoto()
    }
    
    @objc func continueAction() {
        self.delegate?.notifyContinue()
    }
    
    @objc func takeAgainAction() {
        self.delegate?.notifyTakePhoto()
    }
}
