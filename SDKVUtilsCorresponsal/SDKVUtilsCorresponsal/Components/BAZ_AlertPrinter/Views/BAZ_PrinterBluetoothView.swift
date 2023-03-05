//
//  BAZ_PrinterBluetoothView.swift
//  GenericPrinter
//
//  Created by Gustavo Tellez on 24/08/21.
//

import UIKit
import Lottie

internal class BAZ_PrinterBluetoothView: UIView {
    
    private lazy var animationBluetooth: AnimationView = {
        let lottie = AnimationView(animation: Animation.named("active_bluetooth", bundle: Bundle(for: BAZ_AlertPrinterViewUI.self), subdirectory: nil, animationCache: nil))
        lottie.contentMode = .scaleAspectFill//.scaleAspectFit
        lottie.clipsToBounds = false
        lottie.backgroundBehavior = .pauseAndRestore
        lottie.loopMode = LottieLoopMode.loop
        lottie.play()
        lottie.translatesAutoresizingMaskIntoConstraints = false
        return lottie
    }()
    
    private lazy var descriptionBluetoothLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Bluetooth Desactivado"
        label.textColor = BAZ_ColorManager.navyBlueDarDissablekRW
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .Raleway_Bold_16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var activeBluetoothButton: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(titleText: "Activar Bluetooth",
                                           textAlignment: .Center,
                                           showIcon: false)
        button.addTarget(self, action: #selector(self.goToActiveBluetooth), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public init(){
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints = false
        
        buildUIElements()
        buildContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUIElements(){
        self.addSubview(animationBluetooth)
        self.addSubview(descriptionBluetoothLabel)
        self.addSubview(activeBluetoothButton)
    }
    
    private func buildContraints(){
        NSLayoutConstraint.activate([
            animationBluetooth.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
            animationBluetooth.widthAnchor.constraint(equalToConstant: 150.0),  //150.0
            animationBluetooth.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            descriptionBluetoothLabel.topAnchor.constraint(equalTo: animationBluetooth.bottomAnchor),
            descriptionBluetoothLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionBluetoothLabel.heightAnchor.constraint(equalToConstant: 40.0),
            descriptionBluetoothLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            activeBluetoothButton.topAnchor.constraint(equalTo: descriptionBluetoothLabel.bottomAnchor, constant: 5.0),
            activeBluetoothButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30.0),
            activeBluetoothButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30.0),
            activeBluetoothButton.heightAnchor.constraint(equalToConstant: 50.0),
            activeBluetoothButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func goToActiveBluetooth(){
        guard let settingsURL = URL(string: "App-Prefs:root=General") else {return}
        if UIApplication.shared.canOpenURL(settingsURL){
            UIApplication.shared.open(settingsURL) { (success) in
                printDebug("Setting opened:\(success) ")
            }
        }
    }
}
