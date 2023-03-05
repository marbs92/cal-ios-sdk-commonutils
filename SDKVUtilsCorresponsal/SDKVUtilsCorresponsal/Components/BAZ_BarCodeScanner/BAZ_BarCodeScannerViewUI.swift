//
//  BAZ_BarCodeScannerViewUI.swift
//  baz-ios-akpago-utils
//
//  Created Jorge Cruz on 17/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: BAZ_BarCodeScannerViewUI Delegate -
/// BAZ_BarCodeScannerViewUI Delegate
protocol BAZ_BarCodeScannerViewUIDelegate {
    // Send Events to Module View, that will send events to the Presenter; which will send events to the Receiver e.g. Protocol OR Component.
    func notifySuccesfullScan(barcode: String)
    func notifyDissmissView()
    
}

class BAZ_BarCodeScannerViewUI: UIView, AVCaptureMetadataOutputObjectsDelegate {
    var delegate: BAZ_BarCodeScannerViewUIDelegate?
    
    var captureSession: AVCaptureSession!
    var payServiceType: BAZ_OptionsMenuType?
    private var fromWhere: BAZ_ScannBarCodeFromWhere = .PayCredit
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    lazy var navigationBar: BAZ_NavigationView = {
        let navigationController = BAZ_NavigationView(frame: .zero)
        navigationController.translatesAutoresizingMaskIntoConstraints = false
        //        navigationController.backgroundColor = .clear
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(bazNamed: "arrowLeftIcon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 17.25, left: 16, bottom: 17.25, right: 16)
        button.tintColor = BAZ_ColorManager.purpleToolBarRW
        button.addTarget(self, action: #selector(self.dissmissView), for: .touchUpInside)
        navigationController.addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 48),
            button.widthAnchor.constraint(equalToConstant: 48),
            button.leadingAnchor.constraint(equalTo: navigationController.containerBezel.leadingAnchor, constant: 15),
            button.centerYAnchor.constraint(equalTo: navigationController.containerBezel.centerYAnchor, constant: 10),
        ])
        return navigationController
    }()
    
    lazy var contentView: UIScrollView = {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    lazy var cardView: BAZ_CardView = {
        let view = BAZ_CardView(shadowOffset: .zero, shadowOpacity: 0, background: .clear)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.Poppins_Bold_20
        label.text = self.fromWhere.getSubtitle()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionBottomText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.Poppins_Medium_16
        label.text = self.fromWhere.getInstructions()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var barCodeContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton(frame: .zero)
        let style = NSMutableParagraphStyle()
        style.alignment = .right
        style.lineBreakMode = .byWordWrapping
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: BAZ_ColorManager.greenDarkRW,
            NSAttributedString.Key.font : UIFont.Poppins_Medium_20 as UIFont ,
            NSAttributedString.Key.paragraphStyle : style
        ]
        let stringAttribute = NSMutableAttributedString(string: "Ingresar Manualmente", attributes: attributes)
        button.setAttributedTitle(stringAttribute, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    public convenience init(
        delegate: BAZ_BarCodeScannerViewUIDelegate,
        fromWhere: BAZ_ScannBarCodeFromWhere){
            self.init()
            self.delegate = delegate
            
            self.fromWhere = fromWhere
            
            setupUIElements()
            setupConstraints()
            
            navigationBar.setComponents(title: self.fromWhere.getTitle(), navigationController: nil, hiddenBackButton: true, backgroundColor: .black, titleSectionColor: .white)
            
            
            
            captureSession = AVCaptureSession()
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                // failed();
                return
            }
            let videoInput: AVCaptureDeviceInput
            
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }
            
            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                // failed()
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            let scanSize = CGRect(x: 35, y: (UIScreen.main.bounds.height / 2 - 100), width: UIScreen.main.bounds.width - 70, height: 200)
            
            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.code128,.code39,.code93]
            } else {
                //  failed()
                return
            }
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer?.frame = CGRect(x: 0, y: 0, width:  UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            barCodeContainer.layer.addSublayer(previewLayer!)
            let containerImageView = UIImageView(frame:  CGRect(x: 30, y: (UIScreen.main.bounds.width / 2), width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.width - 250))
            
            containerImageView.image = UIImage(bazNamed: "onbordingContainerIcon")
            
            let maskLayer: CAShapeLayer = CAShapeLayer()
            let path = CGMutablePath()
            let fullRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            let focusRect = CGRect(x: 30, y: (UIScreen.main.bounds.width / 2), width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.width - 250)
            
            path.addPath(UIBezierPath(roundedRect: focusRect, cornerRadius: 25).reversing().cgPath)
            path.addPath(UIBezierPath(rect: fullRect).cgPath)
            
            maskLayer.fillColor = UIColor.black.withAlphaComponent(0.7).cgColor
            maskLayer.path = path
            maskLayer.fillRule = .evenOdd
            
            previewLayer?.insertSublayer(maskLayer, above: previewLayer)
            barCodeContainer.addSubview(containerImageView)
            
            captureSession?.startRunning()
            metadataOutput.rectOfInterest = (previewLayer?.metadataOutputRectConverted(fromLayerRect: CGRect(x: 30, y: UIScreen.main.bounds.width / 2, width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.width - 250)))!
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
    }
    
    
    fileprivate func setupUIElements() {
        // arrange subviews
        self.continueButton.addTarget(self, action: #selector(self.dissmissView), for: .touchUpInside)
        self.addSubview(contentView)
        self.addSubview(navigationBar)
        self.contentView.addSubview(cardView)
        self.cardView.addSubview(barCodeContainer)
        self.cardView.addSubview(titleText)
        self.cardView.addSubview(descriptionBottomText)
        self.cardView.addSubview(continueButton)
    }
    
    
    fileprivate func setupConstraints() {
        // add constraints to subviews
        NSLayoutConstraint.activate([
            ///NavigationBar
            self.navigationBar.topAnchor.constraint(equalTo: self.topAnchor),
            self.navigationBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.navigationBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            ///ScrollView
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            ///CardView
            self.cardView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.cardView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.cardView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.cardView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            self.barCodeContainer.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.barCodeContainer.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.barCodeContainer.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 80),
            self.barCodeContainer.bottomAnchor.constraint(equalTo: self.titleText.topAnchor, constant: -20),
            
            
            self.titleText.bottomAnchor.constraint(equalTo: self.descriptionBottomText.topAnchor,constant: -20),
            self.titleText.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 30),
            self.titleText.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -30),
            
            self.descriptionBottomText.bottomAnchor.constraint(equalTo: self.continueButton.topAnchor,constant: -20),
            self.descriptionBottomText.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 50),
            self.descriptionBottomText.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -50),
            
            self.continueButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
            self.continueButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 10),
            self.continueButton.trailingAnchor.constraint(equalTo: self.self.cardView.trailingAnchor, constant: -10),
            self.continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        if(UIScreen.main.bounds.height < 700){
            NSLayoutConstraint.activate([
                self.cardView.heightAnchor.constraint(equalToConstant: 600)
            ])
        }else{
            NSLayoutConstraint.activate([
                self.cardView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -60),
            ])
        }
    }
    
    
    @objc private func dissmissView(){
        delegate?.notifyDissmissView()
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
    private func found(code: String) {
        delegate?.notifySuccesfullScan(barcode: code)
        delegate?.notifyDissmissView()
    }
    
    func convertRectOfInterest(rect: CGRect) -> CGRect {
        let screenRect = self.frame
        let screenWidth = screenRect.width
        let screenHeight = screenRect.height
        let newX = 1 / (screenWidth / rect.minX)
        let newY = 1 / (screenHeight / rect.minY)
        let newWidth = 1 / (screenWidth / rect.width)
        let newHeight = 1 / (screenHeight / rect.height)
        return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }
}
