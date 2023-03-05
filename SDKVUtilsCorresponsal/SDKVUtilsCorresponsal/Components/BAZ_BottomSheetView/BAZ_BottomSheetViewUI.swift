//
//  BAZ_BottomSheetViewUI.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Fernando Sánchez Palma on 10/06/22.
//

import Foundation
import UIKit


internal protocol BAZ_BottomSheetViewUIDelegate {
    func notifyClose()
}

internal class BAZ_BottomSheetViewUI: UIView{
    internal var delegate: BAZ_BottomSheetViewUIDelegate?
    
    private var cardViewHeightPercentaje: CGFloat = 100
    internal var cardViewTopAnchor: NSLayoutConstraint = NSLayoutConstraint()
    
    private var showCloseButton = false
    
    private var contentView: UIView = UIView()
    
    private lazy var darkBackgroundView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(self.closeButtonTriggered))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        
        return view
    }()
    
    private lazy var cardView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 27
        return view
    }()
    
    private lazy var componentsContainerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(bazNamed: "closeIcon"), for: .normal)
        button.tintColor = BAZ_ColorManager.purpleToolBarRW
        button.addTarget(self, action: #selector(self.closeButtonTriggered), for: .touchUpInside)
        button.isHidden = !self.showCloseButton
        return button
    }()
    
    
    public convenience init(delegate: BAZ_BottomSheetViewUIDelegate,
                            showCloseButton: Bool,
                            cardViewHeightPercentaje: CGFloat,
                            contentView: UIView){
        self.init()
        self.delegate = delegate
        
        self.showCloseButton = showCloseButton
        self.cardViewHeightPercentaje = cardViewHeightPercentaje.clamp(lowerLimit: 0, upperLimit: 100)
        self.contentView = contentView
        
        self.setUI()
        self.setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func setUI(){
        self.addSubview(self.darkBackgroundView)
        self.addSubview(self.cardView)
        
        self.cardView.addSubview(self.componentsContainerView)
        
        self.componentsContainerView.addSubview(self.closeButton)
        self.componentsContainerView.addSubview(self.contentView)
    }
    
    private func setConstraints(){
        self.cardViewTopAnchor = self.cardView.topAnchor.constraint(equalTo: self.topAnchor,
                                                                    constant: UIScreen.main.bounds.height)
        
        NSLayoutConstraint.activate([
            self.darkBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            self.darkBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.darkBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.darkBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.cardViewTopAnchor,
            self.cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.cardView.heightAnchor.constraint(equalTo: self.heightAnchor,
                                                  multiplier: (self.cardViewHeightPercentaje / 100.0)),
            
            
            self.componentsContainerView.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 20),
            self.componentsContainerView.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.componentsContainerView.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.componentsContainerView.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor,
                                                                 constant: UIDevice.asapScreenSize == .Large ? -70 : -60),
            
            self.closeButton.heightAnchor.constraint(equalToConstant: 40),
            self.closeButton.widthAnchor.constraint(equalToConstant: 40),
            self.closeButton.topAnchor.constraint(equalTo: self.componentsContainerView.topAnchor),
            self.closeButton.trailingAnchor.constraint(equalTo: self.componentsContainerView.trailingAnchor, constant: -20),
            
            self.contentView.topAnchor.constraint(equalTo: self.componentsContainerView.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.componentsContainerView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.componentsContainerView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.componentsContainerView.bottomAnchor),
        ])
    }
    
    
    @objc func closeButtonTriggered() {
        self.isUserInteractionEnabled = false
        self.delegate?.notifyClose()
    }
}
