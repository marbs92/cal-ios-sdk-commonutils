//
//  BAZ_OptionsVerticalShimmerCollectionCell.swift
//  baz-ios-akpago-utils
//
//  Created by Dsi Soporte Tecnico on 09/09/21.
//

import UIKit

open class BAZ_OptionsVerticalShimmerCollectionCell: UICollectionViewCell {
    
    lazy var containerMain: UIView = {
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
    
    
    lazy var itemContent: BAZ_ShimmerView = {
        let imageView = BAZ_ShimmerView(frame: .zero)
        imageView.backgroundColor = UIColor(white: 0.85, alpha: 0.3)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var imageContent: BAZ_ShimmerView = {
        let imageView = BAZ_ShimmerView(frame: .zero)
        imageView.backgroundColor = UIColor(white: 0.85, alpha: 0.3)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    lazy var titleText: BAZ_ShimmerView = {
        let imageView = BAZ_ShimmerView(frame: .zero)
        imageView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var descriptionText: BAZ_ShimmerView = {
        let imageView = BAZ_ShimmerView(frame: .zero)
        imageView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
            
            titleText.centerYAnchor.constraint(equalTo: itemContent.centerYAnchor, constant: -5),
            titleText.leadingAnchor.constraint(equalTo: itemContent.trailingAnchor, constant: 20),
            titleText.trailingAnchor.constraint(equalTo: containerMain.trailingAnchor, constant: -20),
            
            descriptionText.topAnchor.constraint(equalTo: titleText.bottomAnchor),
            descriptionText.leadingAnchor.constraint(equalTo: titleText.leadingAnchor),
            descriptionText.trailingAnchor.constraint(equalTo: titleText.trailingAnchor),
        ])
    }
    
}
