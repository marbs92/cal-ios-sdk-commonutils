//
//  OptionsCollectionCell.swift
//  baz-ios-sdk-ecomerce
//
//  Created by Jorge Cruz on 30/03/21.
//

import UIKit

open class BAZ_OptionsCollectionCell: UICollectionViewCell {
    
    lazy var itemContent: UIView = {
        let view = UIView(frame: .zero)
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 16
//        view.layer.shadowOffset = CGSize(width: 0, height: 2)
//        view.layer.shadowOpacity = 1
//        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12)
        view.backgroundColor = BAZ_ColorManager.noneSpaceHomeRW
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy public var imageContent: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = BAZ_ColorManager.purpleToolBarRW
        return imageView
    }()
    
    lazy public var titleText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor =  BAZ_ColorManager.navyBlueDarkRW
        label.font = .Poppins_Regular_14
        label.textAlignment = .center
        label.numberOfLines = 3
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy public var descriptionText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .Poppins_Regular_14
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
        self.contentView.addSubview(itemContent)
        self.itemContent.addSubview(imageContent)
        self.itemContent.addSubview(titleText)
        self.itemContent.addSubview(descriptionText)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            itemContent.heightAnchor.constraint(equalTo: self.heightAnchor),
            itemContent.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            imageContent.centerYAnchor.constraint(equalTo: itemContent.centerYAnchor, constant: -25),
            imageContent.centerXAnchor.constraint(equalTo: itemContent.centerXAnchor),
            imageContent.heightAnchor.constraint(equalTo: itemContent.heightAnchor, multiplier: 0.3),
            imageContent.widthAnchor.constraint(equalTo: itemContent.widthAnchor, multiplier: 0.45),
            
            titleText.topAnchor.constraint(equalTo: imageContent.bottomAnchor, constant: 10),
            titleText.leadingAnchor.constraint(equalTo: itemContent.leadingAnchor, constant: 10),
            titleText.trailingAnchor.constraint(equalTo: itemContent.trailingAnchor, constant: -10),
            
            
            descriptionText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 0),
            descriptionText.leadingAnchor.constraint(equalTo: itemContent.leadingAnchor, constant: 13),
            descriptionText.trailingAnchor.constraint(equalTo: itemContent.trailingAnchor, constant: -8),
            descriptionText.bottomAnchor.constraint(equalTo: itemContent.bottomAnchor , constant: -10),
        ])
    }
    
    
}
