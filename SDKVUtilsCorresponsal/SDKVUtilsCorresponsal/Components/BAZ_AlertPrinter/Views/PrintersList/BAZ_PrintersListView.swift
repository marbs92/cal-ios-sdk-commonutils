//
//  BAZ_PrintersListView.swift
//  baz-ios-akpago-utils
//
//  Created by Gustavo Tellez on 25/08/21.
//

import UIKit
import cal_ios_sdk_printer

internal class BAZ_PrintersListView: UIView {
    
    private lazy var containerView: BAZ_ContainerView = {
        let container = BAZ_ContainerView()
        return container
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "¿No está tu impresora?"
        label.textColor = BAZ_ColorManager.navyBlueDarDissablekRW
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .Raleway_Bold_16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addedPrintersButton: BAZ_UpdatedButtonView = {
        let button = BAZ_UpdatedButtonView(titleText: "Añadir",
                                           textAlignment: .Center,
                                           showIcon: false)
        button.addTarget(self, action: #selector(self.addedPrinters), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private weak var delegate: BAZ_AlertPrinterViewUIProtocol?
    
    public init(printersList: [UPOSPrinter], delegate: BAZ_AlertPrinterViewUIProtocol){
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints = false
        
        buildUIElements(printersList: printersList, delegate: delegate)
        buildContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUIElements(printersList: [UPOSPrinter], delegate: BAZ_AlertPrinterViewUIProtocol){
        
        if printersList.count > 0 {
            let printersView = BAZ_PrintersView(printers: printersList, delegate: delegate)
            containerView.embedView(printersView)
        }else{
            let noPrintersView = BAZ_NoPrintersView(delegate: delegate)
            containerView.embedView(noPrintersView)
        }
        
        self.addSubview(containerView)
        self.addSubview(descriptionLabel)
        self.addSubview(addedPrintersButton)
    }
    
    private func buildContraints(){
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 40.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            addedPrintersButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5.0),
            addedPrintersButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30.0),
            addedPrintersButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30.0),
            addedPrintersButton.heightAnchor.constraint(equalToConstant: 50.0),
            addedPrintersButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func addedPrinters(){
        guard let settingsURL = URL(string: "App-Prefs:root=General") else {return}
        if UIApplication.shared.canOpenURL(settingsURL){
            UIApplication.shared.open(settingsURL) { (success) in
                printDebug("Setting opened:\(success) ")
            }
        }
    }
}
