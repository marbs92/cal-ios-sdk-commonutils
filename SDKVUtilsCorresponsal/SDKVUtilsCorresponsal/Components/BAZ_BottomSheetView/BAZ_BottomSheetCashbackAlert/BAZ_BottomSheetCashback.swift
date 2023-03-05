//
//  BAZ_BottomSheetCashback.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Fernando Sánchez Palma on 10/06/22.
//

import Foundation
import UIKit

public protocol BAZ_CashbackDelegate: AnyObject{
    func notifyWithdraw()
    func notifyCancel()
}

public class BAZ_BottomSheetCashback {
    internal weak var delegate: BAZ_CashbackDelegate?
    internal var bottomSheet: BAZ_BottomSheetView?
    
    
    lazy var cardView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Retiro en efectivo"
        label.font = UIDevice.asapScreenSize == .Small ? .Poppins_Bold_18 : UIDevice.asapScreenSize == .Medium ? .Poppins_Bold_20 :  .Poppins_Bold_22
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.numberOfLines = 0
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pregunta a tu cliente si desea realizar un retiro de efectivo"
        label.font = UIDevice.asapScreenSize == .Small ? .Poppins_Regular_14 : UIDevice.asapScreenSize == .Medium ? .Poppins_Regular_16 : .Poppins_Regular_18
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.numberOfLines = 0
        return label
    }()
    
    lazy var iconView: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(bazNamed: "cashbackIcon")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    
    lazy var warningContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9490196078, blue: 0.9803921569, alpha: 1)
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var warningIconImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(bazNamed: "alertTickerIcon")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = BAZ_ColorManager.purpleToolBarRW
        return image
    }()
    
    lazy var warningLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "El retiro de efectivo únicamente se puede realizar desde una tarjeta de débito de Banco Azteca."
        label.font = UIDevice.asapScreenSize == .Small ? .Poppins_Regular_12 : UIDevice.asapScreenSize == .Medium ? .Poppins_Regular_14 : .Poppins_Regular_16
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var withdrawButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sí, retirar efectivo", for: .normal)
        button.titleLabel?.font = UIDevice.asapScreenSize == .Small ? .Poppins_Medium_12 : UIDevice.asapScreenSize == .Medium ? .Poppins_Medium_14 : .Poppins_Medium_16
        button.setTitleColor(BAZ_ColorManager.navyBlueDarkRW, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = UIDevice.asapScreenSize == .Small ? 15 : UIDevice.asapScreenSize == .Medium ? 20 : 25
        
        button.layer.borderWidth = 1
        button.layer.borderColor = BAZ_ColorManager.navyBlueDarkRW.cgColor
        button.addTarget(self, action: #selector(self.withdrawButtonTriggered), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
       let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("No, gracias", for: .normal)
        button.titleLabel?.font = UIDevice.asapScreenSize == .Small ? .Poppins_Medium_12 : UIDevice.asapScreenSize == .Medium ? .Poppins_Medium_14 : .Poppins_Medium_16
        button.setTitleColor(BAZ_ColorManager.purpleToolBarRW, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.cancelButtonTriggered), for: .touchUpInside)
        return button
    }()
    
    
    public init(delegate: BAZ_CashbackDelegate){
        self.delegate = delegate
        setupComponents()
        setupLayoutComponents()
    }
    
    public func build() -> UIViewController {
        let bottom = BAZ_BottomSheetMain.createModule(showCloseButton: false,
                                                       cardViewHeightPercentaje: 83,
                                                       contentView: self.cardView,
                                                       delegate: self)
        self.bottomSheet = bottom
        return bottom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponents(){
        self.cardView.addSubview(self.titleLabel)
        self.cardView.addSubview(self.subtitleLabel)
        self.cardView.addSubview(self.iconView)
        self.cardView.addSubview(self.warningContainerView)
        
        self.warningContainerView.addSubview(self.warningIconImage)
        self.warningContainerView.addSubview(self.warningLabel)
        
        self.cardView.addSubview(self.withdrawButton)
        self.cardView.addSubview(self.cancelButton)
    }
    
    private func setupLayoutComponents(){
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.cardView.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.subtitleLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
            
            
            self.iconView.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor,
                                               constant: UIDevice.asapScreenSize == .Small ? 10 : UIDevice.asapScreenSize == .Medium ? 20 : 30),
            self.iconView.widthAnchor.constraint(equalToConstant: UIDevice.asapScreenSize == .Small ? 100 : UIDevice.asapScreenSize == .Medium ? 150 : 200),
            self.iconView.heightAnchor.constraint(equalToConstant: UIDevice.asapScreenSize == .Small ? 100 : UIDevice.asapScreenSize == .Medium ? 150 : 200),
            self.iconView.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor),
            
            
            self.warningContainerView.topAnchor.constraint(equalTo: self.iconView.bottomAnchor,
                                                           constant: UIDevice.asapScreenSize == .Small ? 10 : UIDevice.asapScreenSize == .Medium ? 15 : 20),
            self.warningContainerView.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            self.warningContainerView.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            
            self.warningIconImage.topAnchor.constraint(equalTo: self.warningContainerView.topAnchor, constant: 20),
            self.warningIconImage.leadingAnchor.constraint(equalTo: self.warningContainerView.leadingAnchor, constant: 20),
            self.warningIconImage.widthAnchor.constraint(equalToConstant: 25),
            self.warningIconImage.heightAnchor.constraint(equalToConstant: 25),
            
            
            self.warningLabel.topAnchor.constraint(equalTo: self.warningContainerView.topAnchor, constant: 20),
            self.warningLabel.leadingAnchor.constraint(equalTo: self.warningIconImage.trailingAnchor, constant: 10),
            self.warningLabel.trailingAnchor.constraint(equalTo: self.warningContainerView.trailingAnchor, constant: -20),
            self.warningLabel.bottomAnchor.constraint(equalTo: self.warningContainerView.bottomAnchor, constant: -20),
            
            self.withdrawButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: UIDevice.asapScreenSize == .Small ? 60 : UIDevice.asapScreenSize == .Medium ? 80 : 100),
            self.withdrawButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: UIDevice.asapScreenSize == .Small ? -60 : UIDevice.asapScreenSize == .Medium ? -80 : -100),
            self.withdrawButton.heightAnchor.constraint(equalToConstant: UIDevice.asapScreenSize == .Small ? 30 : UIDevice.asapScreenSize == .Medium ? 40 : 50),
            self.withdrawButton.bottomAnchor.constraint(equalTo: self.cancelButton.topAnchor,
                                                        constant: UIDevice.asapScreenSize == .Large ? -20 : -10),
            
            self.cancelButton.leadingAnchor.constraint(equalTo: self.withdrawButton.leadingAnchor),
            self.cancelButton.trailingAnchor.constraint(equalTo: self.withdrawButton.trailingAnchor),
            self.cancelButton.heightAnchor.constraint(equalToConstant: UIDevice.asapScreenSize == .Small ? 30 : UIDevice.asapScreenSize == .Medium ? 40 : 50),
            self.cancelButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor)
        ])
    }
    
    @objc func withdrawButtonTriggered() {
        self.bottomSheet?.hide(completionHandler: {
            self.delegate?.notifyWithdraw()
        })
    }
    
    @objc func cancelButtonTriggered() {
        self.bottomSheet?.hide(completionHandler: {
            self.delegate?.notifyCancel()
        })
    }
    
    public func close(completion: (() -> Void)?) {
        self.bottomSheet?.hide(completionHandler: {
            completion?()
        })
    }
}


extension BAZ_BottomSheetCashback: BAZ_BottomSheetDelegate {
    func notifyBottomSheetClosed() {
        self.delegate?.notifyCancel()
    }
}
