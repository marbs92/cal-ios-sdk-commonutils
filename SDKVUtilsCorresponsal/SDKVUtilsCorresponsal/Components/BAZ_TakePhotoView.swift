//
//  BAZ_TakePhotoView.swift
//  cal-ios-sdk-commonutils
//
//  Created by Dsi Soporte Tecnico on 18/10/21.
//

import UIKit

public protocol BAZ_TakePhotoViewDelegate: class{
    func notifyImageWasTap()
}

open class BAZ_TakePhotoView: UIView {
    public weak var delegate: BAZ_TakePhotoViewDelegate?
    lazy var imageRef: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = BAZ_ColorManager.grayRW
        return image
    }()
    
    lazy var titleRef: UILabel = {
        let title = UILabel(frame: .zero)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .Poppins_Regular_16
        title.textAlignment = .center
        title.textColor = BAZ_ColorManager.grayRW
        return title
    }()
    
    lazy var buttonGesture: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.onTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    public init(imageReference : String,
                titleReference : String,
                delegate: BAZ_TakePhotoViewDelegate) {
        super.init(frame: .zero)
        imageRef.image = UIImage(bazNamed: "cameraOutfilIcon")
        titleRef.text = titleReference
        self.delegate = delegate
        buildUI()
        buildConstraint()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func buildUI(){
        layer.cornerRadius = 10
        layer.shadowRadius =  7
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1221039245)
        layer.backgroundColor = BAZ_ColorManager.whiteNavBarBackground.cgColor
        layer.shadowOpacity = 1
        addSubview(imageRef)
        addSubview(titleRef)
        addSubview(buttonGesture)
    }
    
    
    fileprivate func buildConstraint(){
        NSLayoutConstraint.activate([
            titleRef.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleRef.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleRef.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleRef.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            imageRef.bottomAnchor.constraint(equalTo: titleRef.topAnchor, constant: -5),
            imageRef.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageRef.heightAnchor.constraint(equalToConstant: 30),
            imageRef.widthAnchor.constraint(equalToConstant: 30),
            
            buttonGesture.topAnchor.constraint(equalTo: topAnchor),
            buttonGesture.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonGesture.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonGesture.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    
    @objc private func onTapButton(_ sender: UIButton){
        delegate?.notifyImageWasTap()
    }
}
