//
//  BAZ_OptionsVerticalCollectionCell.swift
//  baz-ios-akpago-utils
//
//  Created by Dsi Soporte Tecnico on 09/09/21.
//

import UIKit

open class BAZ_OptionsVerticalCollectionCell: UICollectionViewCell {

    lazy var containerMain: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = BAZ_ColorManager.purpleToolBarRW.cgColor
        return view
    }()
    
    lazy var itemContent: UIView = {
        let view = UIView(frame: .zero)
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.backgroundColor = BAZ_ColorManager.purpleToolBarRW
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy public var imageContent: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    lazy public var titleText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.font = UIFont.Poppins_Bold_24
        label.textAlignment = .left
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy public var descriptionText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.Poppins_Medium_18
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
        setupConstraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUIElements() {
        contentView.addSubview(containerMain)
        containerMain.addSubview(itemContent)
        itemContent.addSubview(imageContent)
        containerMain.addSubview(titleText)
        containerMain.addSubview(descriptionText)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            containerMain.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerMain.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerMain.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerMain.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            itemContent.heightAnchor.constraint(equalTo: containerMain.heightAnchor),
            itemContent.widthAnchor.constraint(equalTo: itemContent.heightAnchor),
            itemContent.leadingAnchor.constraint(equalTo: containerMain.leadingAnchor),
            itemContent.topAnchor.constraint(equalTo: containerMain.topAnchor),
            itemContent.bottomAnchor.constraint(equalTo: containerMain.bottomAnchor),
            
            imageContent.centerYAnchor.constraint(equalTo: itemContent.centerYAnchor),
            imageContent.centerXAnchor.constraint(equalTo: itemContent.centerXAnchor),
            imageContent.heightAnchor.constraint(equalToConstant: 60),
            imageContent.widthAnchor.constraint(equalToConstant: 70),
            
            titleText.centerYAnchor.constraint(equalTo: itemContent.centerYAnchor, constant: -5),
            titleText.leadingAnchor.constraint(equalTo: itemContent.trailingAnchor, constant: 20),
            titleText.trailingAnchor.constraint(equalTo: containerMain.trailingAnchor, constant: -20),
            
            descriptionText.topAnchor.constraint(equalTo: titleText.bottomAnchor),
            descriptionText.leadingAnchor.constraint(equalTo: titleText.leadingAnchor),
            descriptionText.trailingAnchor.constraint(equalTo: titleText.trailingAnchor),
        ])
    }
    
}
