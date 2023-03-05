//
//  BAZ_GalleryManager.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 17/02/22.
//

import UIKit


public protocol BAZ_GalleryManagerDelegate{
    func responseImageOnProfAddress(stringImage: String)
}

extension BAZ_GalleryManager: BAZ_TakeProofAdressDelegate{
    public func notifySuccesfulScan(image: String) {
        dataSource?.responseImageOnProfAddress(stringImage: image)
    }
}

open class BAZ_GalleryManager: NSObject {

    public static let shared = BAZ_GalleryManager()
    private var dataSource : BAZ_GalleryManagerDelegate?
    
    public func showImagePickerProof(presenter: UIViewController,
                                     dataSource: BAZ_GalleryManagerDelegate,
                                     delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate,
                                     withImagePreview: String = "",
                                     maxImageCharsLimit: Int) {
        self.dataSource = dataSource
        let alert = UIAlertController(title: "Selecciona", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { _ in
            let prof = BAZ_TakeProofAdressMain.createModule(delegate: self)
            prof.modalPresentationStyle = .overFullScreen
            presenter.present(prof, animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Galería", style: .default, handler: { _ in
            self.openGallery(presenter: presenter,
                             delegate: delegate)
        }))
        if withImagePreview != ""{
            alert.addAction(UIAlertAction(title: "Visualizar", style: .default, handler: { _ in
                let baz_image = BAZ_LoadImageViewMain.createModule(imageBase64String: withImagePreview,
                                                                   photoType: .ProofOfAddress,
                                                                   delegate: self,
                                                                   maxImageCharsLimit: maxImageCharsLimit)
                baz_image.modalPresentationStyle = .overFullScreen
                presenter.present(baz_image, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction.init(title: "Cancelar", style: .cancel, handler: nil))

        presenter.present(alert, animated: true, completion: nil)
    }
    
    
    public func showImagePicker(presenter: UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate,
                                withImagePreview: String = "",
                                maxImageCharsLimit: Int) {
        self.showImagePicker(presenter: presenter,
                             delegate: presenter,
                             withImagePreview: withImagePreview,
                             maxImageCharsLimit: maxImageCharsLimit)
    }
    
    public func showImagePicker(presenter: UIViewController,
                                delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate,
                                documentType: BAZ_CameraDocumentType?,
                                withImagePreview: String?,
                                cameraDelegate: BAZ_GalleryManagerDelegate?,
                                maxImageCharsLimit: Int) {
        self.dataSource = cameraDelegate
        let alert = UIAlertController(title: "Selecciona", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { _ in
            switch documentType {
            case .Identification:
                let prof = BAZ_TakeIdentificationMain.createModule(delegate: self)
                prof.modalPresentationStyle = .overFullScreen
                presenter.present(prof, animated: true, completion: nil)
            case .BackIdentification:
                let prof = BAZ_TakeIdentificationMain.createModule(delegate: self)
                prof.modalPresentationStyle = .overFullScreen
                presenter.present(prof, animated: true, completion: nil)
            case .ProofOfAddress:
                let prof = BAZ_TakeProofAdressMain.createModule(delegate: self)
                prof.modalPresentationStyle = .overFullScreen
                presenter.present(prof, animated: true, completion: nil)
            default:
                self.openCamera(presenter: presenter,
                                delegate: delegate)
            }
        }))

        alert.addAction(UIAlertAction(title: "Galería", style: .default, handler: { _ in
            self.openGallery(presenter: presenter,
                             delegate: delegate)
        }))
        if let nonNilImage = withImagePreview, cameraDelegate != nil, let type = documentType {
            alert.addAction(UIAlertAction(title: "Visualizar", style: .default, handler: { _ in
                let baz_image = BAZ_LoadImageViewMain.createModule(imageBase64String: nonNilImage,
                                                                   photoType: type,
                                                                   delegate: nil,
                                                                   maxImageCharsLimit: maxImageCharsLimit)
                baz_image.modalPresentationStyle = .overFullScreen
                presenter.present(baz_image, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction.init(title: "Cancelar", style: .cancel, handler: nil))

        presenter.present(alert, animated: true, completion: nil)
    }
    
    public func showImagePicker(presenter: UIViewController,
                                delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate,
                                withImagePreview: String = "",
                                maxImageCharsLimit: Int) {
        let alert = UIAlertController(title: "Selecciona", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { _ in
            self.openCamera(presenter: presenter,
                            delegate: delegate)
        }))

        alert.addAction(UIAlertAction(title: "Galería", style: .default, handler: { _ in
            self.openGallery(presenter: presenter,
                             delegate: delegate)
        }))
        if withImagePreview != ""{
            alert.addAction(UIAlertAction(title: "Visualizar", style: .default, handler: { _ in
                let baz_image = BAZ_LoadImageViewMain.createModule(imageBase64String: withImagePreview,
                                                                   photoType: .Identification,
                                                                   delegate: self,
                                                                   maxImageCharsLimit: maxImageCharsLimit)
                baz_image.modalPresentationStyle = .overFullScreen
                presenter.present(baz_image, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction.init(title: "Cancelar", style: .cancel, handler: nil))

        presenter.present(alert, animated: true, completion: nil)
    }
    
  
    private func openCamera(presenter: UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        self.openCamera(presenter: presenter,
                        delegate: presenter)
    }
    
    private func openCamera(presenter: UIViewController,
                            delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = delegate
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            presenter.present(imagePicker, animated: true)
        } else {
            let alert  = UIAlertController(title: "Alerta", message: "No cuentas con cámara", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            presenter.present(alert, animated: true)
        }
    }
    
    private func openGallery(presenter: UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        self.openGallery(presenter: presenter,
                         delegate: presenter)
    }
    
    private func openGallery(presenter: UIViewController,
                             delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = delegate
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .overFullScreen
            presenter.present(imagePicker, animated: true)
        } else {
            let alert  = UIAlertController(title: "Alerta", message: "La aplicación no tiene permisos para acceder a la galería.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            presenter.present(alert, animated: true)
        }
    }
}
extension BAZ_GalleryManager: BAZ_LoadImageViewProtocol {
    public func notifyCotinue(photo: String) {
        self.dataSource?.responseImageOnProfAddress(stringImage: photo)
    }
}


extension BAZ_GalleryManager: BAZ_TakeIdentificationDelegate{
    public func notifyIdentificationPhoto(image: String) {
        dataSource?.responseImageOnProfAddress(stringImage: image)
    }
}
