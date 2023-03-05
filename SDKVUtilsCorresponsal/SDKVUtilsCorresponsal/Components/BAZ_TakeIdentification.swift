//
//  BAZ_TakeIdentification.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 27/04/22.
//

import Foundation
import UIKit


open class BAZ_TakeIdentificationMain: NSObject {

    public static func createModule(delegate:BAZ_TakeIdentificationDelegate) -> UIViewController{
        
        let viewController  :   BAZ_TakeIdentification?   =  BAZ_TakeIdentification()
        if let view = viewController {
            view.delegate = delegate
            return view
        }
        return UIViewController()
    }
}


public protocol BAZ_TakeIdentificationDelegate {
    func notifyIdentificationPhoto(image: String)
}

open class BAZ_TakeIdentification: UIViewController, AVCapturePhotoCaptureDelegate{
    var delegate: BAZ_TakeIdentificationDelegate?
    
    var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var stillImageOutput: AVCapturePhotoOutput!
    private var captureImageView = UIImage()
    var visibleLayerFrame: CGRect? = nil
    
    
    lazy var navigationBar: BAZ_NavigationView = {
        let navigationController = BAZ_NavigationView(frame: .zero)
        navigationController.translatesAutoresizingMaskIntoConstraints = false
        return navigationController
    }()
    
    lazy var contentView : UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var descriptionText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = BAZ_ColorManager.whiteNavBarBackground
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .Poppins_Bold_22
        label.text = "INE ó IFE\nParte Delantera"
        return label
    }()
    
    lazy var containerImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(bazNamed: "onbordingContainerIcon")
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    lazy var containerImageExample: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.image = UIImage(bazNamed: "documentIneFrontIcon")
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    lazy var buttonContainerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var buttonContinue: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(titleText: "Tomar foto", textAlignment: .Center, showIcon: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.didTakePhoto), for: .touchUpInside)
        button.setEnableButton(enable: true)
        return button
    }()
   
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationBar.setComponents(title: "Identificación", navigationController: self.navigationController)
        navigationBar.assignCustomBackEvent(target: self, event: #selector(self.dismissView(_:)), eventTrigger: .touchUpInside)
        setupUIElements()
        setupConstraints()

        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            failed();
            return
        }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: backCamera)
        } catch {
            return
        }

        stillImageOutput = AVCapturePhotoOutput()

        if (captureSession.canAddInput(videoInput) &&
                captureSession.canAddOutput(stillImageOutput)) {
            captureSession.addInput(videoInput)
            captureSession.addOutput(stillImageOutput)
            setupLivePreview()
            
        } else {
            failed()
            return
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 3.0, options: [.curveEaseInOut, .curveEaseOut]) {
                self.containerImageExample.alpha = 0
                self.containerImageExample.layoutIfNeeded()
            } completion: { finish in
                self.containerImageExample.isHidden = true
            }
        }
    }
    
    
    fileprivate func setupUIElements() {
        view.addSubview(navigationBar)
        view.addSubview(contentView)
        view.addSubview(descriptionText)
        view.addSubview(containerImageView)
        view.addSubview(containerImageExample)
        view.addSubview(buttonContainerView)
        buttonContainerView.addSubview(buttonContinue)
    }
    
    fileprivate func setupConstraints() {
        // add constraints to subviews
        NSLayoutConstraint.activate([
            self.navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            self.navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            descriptionText.bottomAnchor.constraint(equalTo: containerImageView.topAnchor, constant: -30),
            descriptionText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        
            containerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            containerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            containerImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerImageView.heightAnchor.constraint(equalToConstant: 220),
            
            containerImageExample.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            containerImageExample.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            containerImageExample.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerImageExample.heightAnchor.constraint(equalToConstant: 220),
            
            buttonContainerView.topAnchor.constraint(equalTo: containerImageView.bottomAnchor),
            buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            buttonContinue.centerYAnchor.constraint(equalTo: buttonContainerView.centerYAnchor),
            buttonContinue.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 30),
            buttonContinue.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -30),
            buttonContinue.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
 
    
    func setupLivePreview(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let maskLayer: CAShapeLayer = CAShapeLayer()
            let path = CGMutablePath()
        
            let fullRect = self.contentView.bounds
            
            let containerFrame = self.containerImageView.frame
            let correctCGRect = CGRect(x: containerFrame.minX,
                                       y: ((self.contentView.bounds.height/2)) - (containerFrame.height/2),
                                       width: containerFrame.width,
                                       height: containerFrame.height)
            
            path.addPath(UIBezierPath(roundedRect: correctCGRect, cornerRadius: 30).reversing().cgPath)
            path.addPath(UIBezierPath(rect: fullRect).cgPath)
            
            maskLayer.fillColor = UIColor.black.withAlphaComponent(0.7).cgColor
            maskLayer.path = path
            maskLayer.fillRule = .evenOdd
            
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.previewLayer.connection?.videoOrientation = .portrait
            self.previewLayer.frame = self.contentView.bounds
            self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.previewLayer?.insertSublayer(maskLayer, above: self.previewLayer)
            
            self.contentView.layer.addSublayer(self.previewLayer)
            
            self.captureSession.startRunning()
        }
    }

    


    fileprivate func failed() {
//        let ac = UIAlertController(title: "Escaneo no disponible", message: "Tu dispositivo no soporta el escaneo de código QR de un artículo. Por favor usa un dispositivo con cámara", preferredStyle: .alert)
//
//        let action = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive) { [weak self] UIAlertAction in
//            self?._presenter?.cancelNext(toRoot: true)
//        }
//        ac.addAction(action)
//        present(ac, animated: true)
        captureSession = nil
    }
    
    func cropImage(image: UIImage) -> UIImage? {
        let croppedRect = calculateRect(image: image)
        guard let imgRet = image.cgImage?.cropping(to: croppedRect) else {
            return nil
        }
        return UIImage(cgImage: imgRet, scale: 1.0, orientation: .right)
    }
    
    func calculateRect(image: UIImage) -> CGRect {
        if self.visibleLayerFrame == nil || self.visibleLayerFrame?.width == 0 {
            let containerFrame = self.containerImageView.frame
            self.visibleLayerFrame = CGRect(x: containerFrame.minX,
                                       y: ((self.contentView.bounds.height/2)) - (containerFrame.height/2),
                                       width: containerFrame.width,
                                       height: containerFrame.height)
            
        }
        
        if let visibleLayerFrame = visibleLayerFrame {
            let originalSize: CGSize
            
            // Calculate the rect from the rectangleview to translate to the image
            let metaRect = (self.previewLayer.metadataOutputRectConverted(fromLayerRect: visibleLayerFrame))
            if (image.imageOrientation == UIImage.Orientation.left || image.imageOrientation == UIImage.Orientation.right) {
                originalSize = CGSize(width: image.size.height, height: image.size.width)
            } else {
                originalSize = image.size
            }
            
            let cropRect: CGRect = CGRect(x: metaRect.origin.x * originalSize.width, y: metaRect.origin.y * originalSize.height, width: metaRect.size.width * originalSize.width, height: metaRect.size.height * originalSize.height).integral
            return cropRect
        }
        return .zero
    }
    
    func showImage(image: UIImage)->UIImageView {
        let takenImage = UIImageView(image: image)
        takenImage.frame = .zero
        takenImage.contentMode = .scaleAspectFit
        return takenImage
    }
    
    @available(iOS 11.0, *)
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imgData = photo.fileDataRepresentation(), let uiImg = UIImage(data: imgData), let cgImg = uiImg.cgImage else {
            return
        }
        print("Original image size: ", uiImg.size, "\nCGHeight: ", cgImg.height, " width: ", cgImg.width)
        print("Orientation: ", uiImg.imageOrientation.rawValue)
        guard let img = cropImage(image: uiImg) else {
            return
        }
        let image = showImage(image: img).image
        self.delegate?.notifyIdentificationPhoto(image: image?.toBase64String(compress: false) ?? "")
        dismiss(animated: true)
    }
    
    @objc func didTakePhoto(_ sender: Any) {
        takePhoto()
    }
    
    private func takePhoto(){
        if #available(iOS 11.0, *) {
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
        } else {
            // Fallback on earlier versions
        }
    }
    @objc func dismissView(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}
