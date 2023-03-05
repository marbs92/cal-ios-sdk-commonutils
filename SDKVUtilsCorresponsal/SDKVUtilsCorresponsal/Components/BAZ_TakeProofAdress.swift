//
//  BAZ_TakeProofAdress.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 27/04/22.
//

import UIKit


open class BAZ_TakeProofAdressMain: NSObject {

    public static func createModule(delegate:BAZ_TakeProofAdressDelegate) -> UIViewController{
        
        let viewController  :   BAZ_TakeProofAdress?   =  BAZ_TakeProofAdress()
        if let view = viewController {
            view.delegate = delegate
            return view
        }
        return UIViewController()
    }
}


public protocol BAZ_TakeProofAdressDelegate {
    func notifySuccesfulScan(image: String)
}

open class BAZ_TakeProofAdress: UIViewController, AVCapturePhotoCaptureDelegate{
    
    var delegate: BAZ_TakeProofAdressDelegate?
    lazy var navigationBar: BAZ_NavigationView = {
        let navigationController = BAZ_NavigationView(frame: .zero)
        navigationController.translatesAutoresizingMaskIntoConstraints = false
        return navigationController
    }()
    
    let centerRect = CGRect(x: 30, y: 110, width: UIScreen.main.bounds.width - 60, height: (UIScreen.main.bounds.height - 120) * 0.7)
    lazy var focusRect: CGRect = {
        let focusRect = centerRect
        return focusRect
    }()
    
    lazy var contentView : UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonContinue: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(titleText: "Tomar foto", textAlignment: .Center, showIcon: false)
        button.frame = CGRect(x: 30, y: 120 + centerRect.height + 20, width: UIScreen.main.bounds.width - 60, height: 50)
        button.addTarget(self, action: #selector(self.didTakePhoto), for: .touchUpInside)
        button.setEnableButton(enable: true)
        return button
    }()
    
    lazy var containerImageExample : UIImageView = {
        let containerImageExample = UIImageView(frame:  centerRect)
        containerImageExample.image = UIImage(bazNamed: "documentComprobanteDomicilioIcon")
        containerImageExample.layer.cornerRadius = 30
        containerImageExample.clipsToBounds = true
        return containerImageExample
    }()
    lazy var containerImageView : UIImageView = {
        let containerImageView = UIImageView(frame:  centerRect)
        containerImageView.image = UIImage(bazNamed: "onbordingContainerProIcon")
        return containerImageView
    }()
    
    lazy var descriptionText: UILabel = {
        let label = UILabel(frame: CGRect(x: 30, y: 10, width: UIScreen.main.bounds.width - 60, height: 80))
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .Poppins_Semibold_18
        label.text = "Centra y escanea tu recibo de agua, luz, teléfono o predial."
        return label
    }()
   
    var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var stillImageOutput: AVCapturePhotoOutput!
    private var captureImageView = UIImage()
    private var currentPhoto: UIImage?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationBar.setComponents(title: "Comprobante de domicilio", navigationController: self.navigationController)
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
 
    func setupLivePreview(){
        
        let maskLayer: CAShapeLayer = CAShapeLayer()
        let path = CGMutablePath()
        let fullRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 120)
        
        path.addPath(UIBezierPath(roundedRect: focusRect, cornerRadius: 30).reversing().cgPath)
        path.addPath(UIBezierPath(rect: fullRect).cgPath)
        
        maskLayer.fillColor = UIColor.black.withAlphaComponent(0.7).cgColor
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 120)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.insertSublayer(maskLayer, above: previewLayer)
        contentView.layer.addSublayer(previewLayer)
        contentView.addSubview(descriptionText)
        contentView.addSubview(containerImageExample)
        contentView.addSubview(containerImageView)
        contentView.addSubview(buttonContinue)
        captureSession.startRunning()
    }

    
    fileprivate func setupUIElements() {
        view.addSubview(navigationBar)
        view.addSubview(contentView)
    }
    
    fileprivate func setupConstraints() {
        // add constraints to subviews
        NSLayoutConstraint.activate([
            ///NavigationBar
            self.navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            self.navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
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
        let originalSize: CGSize
        let visibleLayerFrame = centerRect
        
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
       
        self.currentPhoto = showImage(image: img).image
        self.showPreview()
    }
    
    private func showPreview() {
        let view = BAZ_ProofAdressPreviewMain.createModule(proofAdressImage: self.currentPhoto,
                                                           navigation: self.navigationController,
                                                           delegate: self)
        view.modalPresentationStyle = .overFullScreen
        self.present(view, animated: true)
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

extension BAZ_TakeProofAdress: BAZ_ProofAdressPreviewDelegate{
    public func notifyContinueFlow() {
        self.delegate?.notifySuccesfulScan(image: self.currentPhoto?.toBase64String(compress: false) ?? "")
        self.presentingViewController?.dismiss(animated: true)
    }
}
