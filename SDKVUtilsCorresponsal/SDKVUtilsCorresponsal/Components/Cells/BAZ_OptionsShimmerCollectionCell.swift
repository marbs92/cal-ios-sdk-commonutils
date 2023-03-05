//
//  OptionsShimmerCollectionCell.swift
//  baz-ios-sdk-ecomerce
//
//  Created by Jorge Cruz on 05/04/21.
//

import UIKit

open class BAZ_OptionsShimmerCollectionCell: UICollectionViewCell {
    lazy var itemContent: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 7
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageContent: BAZ_ShimmerView = {
        let imageView = BAZ_ShimmerView(frame: .zero)
        imageView.backgroundColor = UIColor(white: 0.85, alpha: 0.3)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleText: BAZ_ShimmerView = {
        let label = BAZ_ShimmerView(frame: .zero)
        label.backgroundColor = UIColor(white: 0.85, alpha: 0.3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var descriptionText: BAZ_ShimmerView = {
        let label = BAZ_ShimmerView(frame: .zero)
        label.backgroundColor = UIColor(white: 0.85, alpha: 0.3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
        setupConstraints()
        imageContent.startAnimating()
        titleText.startAnimating()
        descriptionText.startAnimating()
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
            
            imageContent.topAnchor.constraint(equalTo: itemContent.topAnchor, constant: 8),
            imageContent.leadingAnchor.constraint(equalTo: itemContent.leadingAnchor, constant: 15),
            imageContent.heightAnchor.constraint(equalTo: itemContent.heightAnchor, multiplier: 0.4, constant: 0),
            imageContent.widthAnchor.constraint(equalTo: itemContent.widthAnchor, multiplier: 0.4, constant: 0),
            
            titleText.topAnchor.constraint(equalTo: imageContent.bottomAnchor, constant: 10),
            titleText.leadingAnchor.constraint(equalTo: itemContent.leadingAnchor, constant: 15),
            titleText.trailingAnchor.constraint(equalTo: itemContent.trailingAnchor, constant: -10),
            titleText.heightAnchor.constraint(equalToConstant: 14),
            
            descriptionText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 2),
            descriptionText.leadingAnchor.constraint(equalTo: itemContent.leadingAnchor, constant: 15),
            descriptionText.trailingAnchor.constraint(equalTo: itemContent.trailingAnchor, constant: -10),
            descriptionText.heightAnchor.constraint(equalToConstant: 14),
        ])
    }
    
    
}
