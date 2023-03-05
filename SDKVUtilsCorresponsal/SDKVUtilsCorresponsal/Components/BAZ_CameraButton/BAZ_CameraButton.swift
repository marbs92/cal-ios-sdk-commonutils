//
//  BAZ_CameraButton.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 12/04/22.
//

import Foundation
import UIKit

public enum BAZ_CameraDocumentType {
    case Identification
    case BackIdentification
    case ProofOfAddress
    
    func getTitle() -> String {
        switch self {
        case .ProofOfAddress:
            return "Comprobante de domicilio"
        case .Identification:
            return "Identificación"
        case .BackIdentification:
            return "Reverso de la Identificación"
        }
    }
}

public protocol BAZ_CameraButtonProtocol {
    func notifySuccessfulPhoto(image: UIImage, documentType: BAZ_CameraDocumentType?)
    func notifyShowProofAdressInformation()
}

open class BAZ_CameraButton: UIView {
    private var delegate: BAZ_CameraButtonProtocol?
    private var presenter: UIViewController?
    private var documentType: BAZ_CameraDocumentType?
    private var maxImageCharsLimit: Int = 4000000
    
    private let defaultCameraImage = UIImage(bazNamed: "cameraOutfilIcon")
    
    public var cameraTitle: String = "" {
        didSet {
            self.cameraButtonTitleLabel.text = self.cameraTitle
        }
    }
    
    public var decorativeCameraTitle: NSMutableAttributedString? = nil {
        didSet {
            self.cameraButtonTitleLabel.attributedText = self.decorativeCameraTitle
        }
    }
    
    public var documentImage: UIImage? = nil {
        didSet {
            DispatchQueue.main.async {
                self.documentImageView.isHidden = self.documentImage == nil
                self.documentImageView.image = self.documentImage
                self.cameraButton.setImage(self.documentImage == nil ? self.defaultCameraImage : nil, for: .normal)
            }
        }
    }
    
    lazy var cameraButtonTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var proofAdressInformationButton: UIButton = {
        let button = UIButton()
        let myString = "Comprobantes oficiales"
        let multipleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: BAZ_ColorManager.navyBlueDarkRW,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font: UIFont(name: "Poppins", size: 12.0)! ]
        let myAttrString = NSAttributedString(string: myString, attributes: multipleAttributes)
        button.setAttributedTitle(myAttrString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.proofAdressInformationButtonPressed), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    lazy var proofAdressInformationImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(bazNamed: "alertTickerIcon")
        image.tintColor = BAZ_ColorManager.whiteNavBarBackground
        image.backgroundColor = BAZ_ColorManager.purpleToolBarRW
        image.layer.borderWidth = 1
        image.layer.borderColor = BAZ_ColorManager.purpleToolBarRW.cgColor
        image.layer.cornerRadius = 7.5
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.alpha = 0
        return image
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(self.defaultCameraImage, for: UIControl.State.normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 13
        button.layer.shadowRadius = 7
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 1
        button.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1221039245)
        button.backgroundColor = BAZ_ColorManager.whiteNavBarBackground
        button.tintColor = BAZ_ColorManager.grayRW
        button.addTarget(self, action: #selector(self.cameraButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var documentImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.isHidden = true
        image.clipsToBounds = true
        image.layer.cornerRadius = 13
        return image
    }()
    
    
    
    public convenience init(title: String = "",
                            decorativeTitle: NSMutableAttributedString? = nil,
                            titleFont: UIFont = .Poppins_Regular_14,
                            titleColor: UIColor = BAZ_ColorManager.navyBlueDarkRW,
                            delegate: BAZ_CameraButtonProtocol,
                            presenter: UIViewController,
                            documentType: BAZ_CameraDocumentType? = nil,
                            maxImageCharsLimit: Int) {
        self.init()
        
        
        if !title.isEmpty {
            self.cameraTitle = title
            self.cameraButtonTitleLabel.text = title
            self.cameraButtonTitleLabel.font = titleFont
            self.cameraButtonTitleLabel.textColor = titleColor
        } else if let decorativeTitleText = decorativeTitle, decorativeTitleText.length > 0 {
            self.decorativeCameraTitle = decorativeTitleText
            self.cameraButtonTitleLabel.attributedText = decorativeTitleText
        }
        
        self.maxImageCharsLimit = maxImageCharsLimit
        
        self.delegate = delegate
        self.presenter = presenter
        self.documentType = documentType
        
        self.buildUI()
        self.setConstraints()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func buildUI() {
        self.addSubview(self.cameraButtonTitleLabel)
        self.addSubview(self.proofAdressInformationImageView)
        self.addSubview(self.proofAdressInformationButton)
        self.addSubview(self.cameraButton)
        self.cameraButton.addSubview(self.documentImageView)
    }
    
    private func setConstraints() {
        
        if self.documentType == .ProofOfAddress {
            proofAdressInformationButton.alpha = 1
            proofAdressInformationImageView.alpha = 1
            NSLayoutConstraint.activate([
                self.cameraButtonTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
                self.cameraButtonTitleLabel.leadingAnchor.constraint(equalTo: self.cameraButton.leadingAnchor),
                self.cameraButtonTitleLabel.trailingAnchor.constraint(equalTo: self.cameraButton.trailingAnchor),
                
                proofAdressInformationImageView.heightAnchor.constraint(equalToConstant: 15),
                proofAdressInformationImageView.widthAnchor.constraint(equalToConstant: 15),
                proofAdressInformationImageView.centerYAnchor.constraint(equalTo: proofAdressInformationButton.centerYAnchor),
                proofAdressInformationImageView.leadingAnchor.constraint(equalTo: cameraButton.leadingAnchor),
                
                self.proofAdressInformationButton.topAnchor.constraint(equalTo: self.cameraButtonTitleLabel.bottomAnchor, constant: 5),
                self.proofAdressInformationButton.leadingAnchor.constraint(equalTo: self.proofAdressInformationImageView.trailingAnchor, constant: 5),
                
                self.cameraButton.topAnchor.constraint(equalTo: self.proofAdressInformationButton.bottomAnchor, constant: 20),
                self.cameraButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.cameraButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.cameraButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.cameraButton.heightAnchor.constraint(equalToConstant: 150),
                
                self.documentImageView.topAnchor.constraint(equalTo: self.cameraButton.topAnchor),
                self.documentImageView.leadingAnchor.constraint(equalTo: self.cameraButton.leadingAnchor),
                self.documentImageView.trailingAnchor.constraint(equalTo: self.cameraButton.trailingAnchor),
                self.documentImageView.widthAnchor.constraint(equalTo: self.cameraButton.widthAnchor),
                self.documentImageView.bottomAnchor.constraint(equalTo: self.cameraButton.bottomAnchor),
            ])
        }
        else {
            NSLayoutConstraint.activate([
                self.cameraButtonTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
                self.cameraButtonTitleLabel.leadingAnchor.constraint(equalTo: self.cameraButton.leadingAnchor),
                self.cameraButtonTitleLabel.trailingAnchor.constraint(equalTo: self.cameraButton.trailingAnchor),
                
                self.cameraButton.topAnchor.constraint(equalTo: self.cameraButtonTitleLabel.bottomAnchor),
                self.cameraButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.cameraButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.cameraButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.cameraButton.heightAnchor.constraint(equalToConstant: 150),
                
                self.documentImageView.topAnchor.constraint(equalTo: self.cameraButton.topAnchor),
                self.documentImageView.leadingAnchor.constraint(equalTo: self.cameraButton.leadingAnchor),
                self.documentImageView.trailingAnchor.constraint(equalTo: self.cameraButton.trailingAnchor),
                self.documentImageView.widthAnchor.constraint(equalTo: self.cameraButton.widthAnchor),
                self.documentImageView.bottomAnchor.constraint(equalTo: self.cameraButton.bottomAnchor),
            ])
        }
        
        
        
    }
    
    @objc private func cameraButtonPressed() {
        if let nonNilPresenter = self.presenter {
            if documentType == .ProofOfAddress{
                BAZ_GalleryManager.shared.showImagePicker(presenter: nonNilPresenter,
                                                          delegate: self,
                                                          documentType: self.documentType,
                                                          withImagePreview: self.documentImage?.toBase64String(compress: false),
                                                          cameraDelegate: self,
                                                          maxImageCharsLimit: self.maxImageCharsLimit)
                
            }
            if documentType == .BackIdentification{
                let baz_image = BAZ_LoadImageViewMain.createModule(
                    imageBase64String: self.documentImage?.toBase64String(compress: false) ?? "",
                    photoType:self.documentType ?? .BackIdentification,
                    delegate: nil,
                    maxImageCharsLimit: self.maxImageCharsLimit)
                baz_image.modalPresentationStyle = .overFullScreen
                nonNilPresenter.present(baz_image, animated: true, completion: nil)
                
            }
            if documentType == .Identification{
                let baz_image = BAZ_LoadImageViewMain.createModule(
                    imageBase64String: self.documentImage?.toBase64String(compress: false) ?? "",
                    photoType:self.documentType ?? .Identification,
                    delegate: nil,
                    maxImageCharsLimit: self.maxImageCharsLimit)
                baz_image.modalPresentationStyle = .overFullScreen
                nonNilPresenter.present(baz_image, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func proofAdressInformationButtonPressed() {
        delegate?.notifyShowProofAdressInformation()
    }
    
    private func showLoader() {
        DispatchQueue.main.async {
            if let view = self.presenter?.view {
                UILoader.show(parent: view)
            }
        }
    }
    
    private func dismissLoader() {
        DispatchQueue.main.async {
            if let view = self.presenter?.view {
                UILoader.remove(parent: view)
            }
        }
    }
}

extension BAZ_CameraButton: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        
        if picker.sourceType != .camera {
            let assetPath = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
            guard (assetPath?.absoluteString?.lowercased().hasSuffix("jpg") == true ||
                   assetPath?.absoluteString?.lowercased().hasSuffix("jpeg") == true ||
                   assetPath?.absoluteString?.lowercased().hasSuffix("png") == true) else{
                DispatchQueue.main.async {
                    let controller = BAZ_AlertErrorMain.createModule(title: nil, delegate: nil)
                    controller.descriptionLabel.text = "Formato de fotografía no válida, intente nuevamente o con una foto diferente en formato png, jpeg ó jpg"
                    self.presenter?.present(controller, animated: true)
                }
                return
            }
        }
        
        guard let image = info[.originalImage] as? UIImage else {
            DispatchQueue.main.async {
                let controller = BAZ_AlertErrorMain.createModule(title: nil, delegate: nil)
                controller.descriptionLabel.text = "Fotografía no válida, intente nuevamente o con una foto diferente"
                self.presenter?.present(controller, animated: true)
            }
            return
        }
        
        self.showLoader()
        image.compressToChars(maxChars: self.maxImageCharsLimit) { newImage in
            self.dismissLoader()
            DispatchQueue.main.async {
                guard let resizedImage = newImage else {
                    let controller = BAZ_AlertErrorMain.createModule(title: nil, delegate: nil)
                    controller.descriptionLabel.text = "Fotografía no válida, intente nuevamente o con una foto diferente"
                    self.presenter?.present(controller, animated: true)
                    return
                }
                self.documentImage = resizedImage
                self.delegate?.notifySuccessfulPhoto(image: resizedImage,
                                                     documentType: self.documentType)
            }
        }
    }
}


extension BAZ_CameraButton: BAZ_GalleryManagerDelegate {
    public func responseImageOnProfAddress(stringImage: String) {
        
        guard let data = Data(base64Encoded: stringImage),
              let image = UIImage(data: data) else {
            DispatchQueue.main.async {
                let controller = BAZ_AlertErrorMain.createModule(title: nil, delegate: nil)
                controller.descriptionLabel.text = "Fotografía no válida, intente nuevamente o con una foto diferente"
                self.presenter?.present(controller, animated: true)
            }
            return
        }
        
        self.showLoader()
        image.compressToChars(maxChars: self.maxImageCharsLimit) { newImage in
            self.dismissLoader()
            DispatchQueue.main.async {
                guard let resizedImage = newImage else {
                    let controller = BAZ_AlertErrorMain.createModule(title: nil, delegate: nil)
                    controller.descriptionLabel.text = "Fotografía no válida, intente nuevamente o con una foto diferente"
                    self.presenter?.present(controller, animated: true)
                    return
                }
                self.documentImage = resizedImage
                self.delegate?.notifySuccessfulPhoto(image: resizedImage,
                                                     documentType: self.documentType)
            }
        }
    }
}
