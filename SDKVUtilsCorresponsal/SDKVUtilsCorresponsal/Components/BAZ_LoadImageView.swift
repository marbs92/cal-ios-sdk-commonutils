//
//  BAZ_LoadImageView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 26/04/22.
//

import UIKit


@objc public protocol BAZ_LoadImageViewProtocol {
    @objc func notifyCotinue(photo: String)
    @objc optional func notifyClose()
}

open class BAZ_LoadImageViewMain: NSObject {
    public static func createModule(imageBase64String: String,
                                    photoType: BAZ_CameraDocumentType,
                                    delegate: BAZ_LoadImageViewProtocol?,
                                    maxImageCharsLimit: Int) -> UIViewController{
        
        let viewController  :   BAZ_LoadImageView?   =  BAZ_LoadImageView()
        if let view = viewController {
            view.imageBase64String = imageBase64String
            view.photoType = photoType
            view.delegate = delegate
            view.maxImageCharsLimit = maxImageCharsLimit
            return view
        }
        return UIViewController()
    }
}


internal class BAZ_LoadImageView: UIViewController {
    var photoType: BAZ_CameraDocumentType = BAZ_CameraDocumentType.Identification
    var imageBase64String: String?
    var delegate: BAZ_LoadImageViewProtocol?
    var maxImageCharsLimit: Int = 4000000
    
    
    lazy var navigationBar: BAZ_NavigationView = {
        let navigationController = BAZ_NavigationView(frame: .zero)
        navigationController.translatesAutoresizingMaskIntoConstraints = false
        return navigationController
    }()
    
    lazy var backgroundImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if delegate != nil || photoType == .Identification || photoType == .BackIdentification  {
            imageView.image = UIImage(bazNamed: "identificationBackgroundIcon")
        }
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    lazy var identificationComponentsContainerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    

    lazy var titleText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = BAZ_ColorManager.onboardingDark
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "La identificación se capturó con éxito."
        label.font = .Poppins_Bold_20
        return label
    }()
    
    lazy var subTitleText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = BAZ_ColorManager.onboardingDark
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "¿Desea continuar?"
        label.font = .Poppins_Semibold_18
        return label
    }()
    
    lazy var identificationPreview : UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    lazy var descriptionText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = BAZ_ColorManager.onboardingDark
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Parte delantera"
        label.font = UIFont.Poppins_Medium_18
        return label
    }()
    

    
    lazy var genericImagePreview : UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var continueButton: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(titleText: "Continuar",
                                           textAlignment: .Left,
                                           showIcon: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.continueAction), for: .touchUpInside)
        button.isHidden = delegate == nil ? true : false
        return button
    }()
    
    lazy var takeAgainButton: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(titleText: "Tomar nueva fotografía",
                                           titleFont: .Poppins_Bold_18,
                                           textAlignment: .Center,
                                           buttonBackgroundColor: .clear,
                                           buttonSecondBackgroundColor: .clear,
                                           buttonTintColor: BAZ_ColorManager.onboardingBlack,
                                           showIcon: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.takeAgainAction), for: .touchUpInside)
        button.isHidden = delegate == nil ? true : false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setComponents(title: self.photoType.getTitle(),
                                    navigationController: navigationController)
        
        navigationBar.assignCustomBackEvent(target: self,
                                            event: #selector(self.dismissView(_:)),
                                            eventTrigger: .touchUpInside)
        view.backgroundColor = UIColor.black
        setUI()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let imageb64 = Data(base64Encoded: imageBase64String ?? ""), let nonNilImage = UIImage(data: imageb64){
            self.showLoader()
            nonNilImage.compressToChars(maxChars: self.maxImageCharsLimit) { compressedImage in
                self.dismissLoader()
                DispatchQueue.main.async {
                    guard let nonNilCompressedImage = compressedImage else {
                        return
                    }
                    self.genericImagePreview.image = nonNilCompressedImage
                    self.identificationPreview.image = nonNilCompressedImage
                }
                
            }
        }
    }
    
    @objc func dismissView(_ sender: UIButton){
        self.delegate?.notifyClose?()
        dismiss(animated: true, completion: nil)
    }
    
    func setUI(){
        view.addSubview(navigationBar)
        view.addSubview(backgroundImageView)
        
        
        backgroundImageView.addSubview(identificationComponentsContainerView)
        identificationComponentsContainerView.addSubview(titleText)
        identificationComponentsContainerView.addSubview(subTitleText)
        identificationComponentsContainerView.addSubview(identificationPreview)
        identificationComponentsContainerView.addSubview(descriptionText)
        
        backgroundImageView.addSubview(genericImagePreview)
        
        backgroundImageView.addSubview(takeAgainButton)
        backgroundImageView.addSubview(continueButton)
        
        

        if self.photoType == .Identification || self.photoType == .BackIdentification {
            self.genericImagePreview.isHidden = true
            if self.delegate == nil {
                self.titleText.isHidden = true
                self.subTitleText.isHidden = true
                self.descriptionText.isHidden = true
            }
        } else if self.photoType == .ProofOfAddress {
            self.identificationComponentsContainerView.isHidden = true
        }
    }
    
    func setConstraints(){
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backgroundImageView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            identificationComponentsContainerView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            identificationComponentsContainerView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            identificationComponentsContainerView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            identificationComponentsContainerView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20),
            
            
            titleText.bottomAnchor.constraint(equalTo: subTitleText.topAnchor, constant: -20),
            titleText.leadingAnchor.constraint(equalTo: identificationComponentsContainerView.leadingAnchor, constant: 30),
            titleText.trailingAnchor.constraint(equalTo: identificationComponentsContainerView.trailingAnchor, constant: -30),
            
            subTitleText.bottomAnchor.constraint(equalTo: identificationPreview.topAnchor, constant: -20),
            subTitleText.leadingAnchor.constraint(equalTo: identificationComponentsContainerView.leadingAnchor, constant: 30),
            subTitleText.trailingAnchor.constraint(equalTo: identificationComponentsContainerView.trailingAnchor, constant: -30),
            
            
            genericImagePreview.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            genericImagePreview.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),
            genericImagePreview.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 30),
            genericImagePreview.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -30),
            genericImagePreview.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5),
             
            
            identificationPreview.leadingAnchor.constraint(equalTo: identificationComponentsContainerView.leadingAnchor, constant: 30),
            identificationPreview.trailingAnchor.constraint(equalTo: identificationComponentsContainerView.trailingAnchor, constant: -30),
            identificationPreview.centerYAnchor.constraint(equalTo: identificationComponentsContainerView.centerYAnchor, constant: 50),
            identificationPreview.heightAnchor.constraint(equalToConstant: 220),

            
            descriptionText.topAnchor.constraint(equalTo: identificationPreview.bottomAnchor, constant: 20),
            descriptionText.leadingAnchor.constraint(equalTo: identificationComponentsContainerView.leadingAnchor, constant: 30),
            descriptionText.trailingAnchor.constraint(equalTo: identificationComponentsContainerView.trailingAnchor, constant: -30),
            
            
            continueButton.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 30),
            continueButton.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -30),
            continueButton.bottomAnchor.constraint(equalTo: takeAgainButton.topAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            
            takeAgainButton.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 30),
            takeAgainButton.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -30),
            takeAgainButton.bottomAnchor.constraint(equalTo: backgroundImageView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            takeAgainButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func continueAction() {
        if let photo = self.imageBase64String {
            self.delegate?.notifyCotinue(photo: photo)
            dismiss(animated: true)
        }
    }
    
    @objc func takeAgainAction() {
        switch self.photoType {
        case .ProofOfAddress:
            let viewController = BAZ_TakeProofAdressMain.createModule(delegate: self)
            viewController.modalPresentationStyle = .overFullScreen
            present(viewController, animated: true)
        case .Identification:
            let viewController = BAZ_TakeIdentificationMain.createModule(delegate: self)
            viewController.modalPresentationStyle = .overFullScreen
            present(viewController, animated: true)
        case .BackIdentification:
            let viewController = BAZ_TakeIdentificationMain.createModule(delegate: self)
            viewController.modalPresentationStyle = .overFullScreen
            present(viewController, animated: true)
        }
    }
    
    private func showLoader() {
        DispatchQueue.main.async {
            UILoader.show(parent: self.view)
        }
    }
    
    private func dismissLoader() {
        DispatchQueue.main.async {
            UILoader.remove(parent: self.view)
        }
    }
}

extension BAZ_LoadImageView: BAZ_TakeIdentificationDelegate {
    func notifyIdentificationPhoto(image: String) {
        self.imageBase64String = image
        if let imageData = Data(base64Encoded: image), let nonNilImage = UIImage(data: imageData){
            self.showLoader()
            nonNilImage.compressToChars(maxChars: self.maxImageCharsLimit) { compressedImage in
                self.dismissLoader()
                DispatchQueue.main.async {
                    guard let nonNilCompressedImage = compressedImage else {
                        return
                    }
                    if self.photoType == .Identification {
                        self.identificationPreview.image = nonNilCompressedImage
                    } else {
                        self.genericImagePreview.image = nonNilCompressedImage
                    }
                }
            }
        }
    }
}

extension BAZ_LoadImageView: BAZ_TakeProofAdressDelegate {
    func notifySuccesfulScan(image: String) {
        self.imageBase64String = image
        if let imageData = Data(base64Encoded: image), let nonNilImage = UIImage(data: imageData){
            self.showLoader()
            nonNilImage.compressToChars(maxChars: self.maxImageCharsLimit) { compressedImage in
                self.dismissLoader()
                DispatchQueue.main.async {
                    guard let nonNilCompressedImage = compressedImage else {
                        return
                    }
                    if self.photoType == .Identification {
                        self.identificationPreview.image = nonNilCompressedImage
                    } else {
                        self.genericImagePreview.image = nonNilCompressedImage
                    }
                }
            }
        }
    }
}
