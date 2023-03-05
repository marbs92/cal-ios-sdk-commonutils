//
//  StepCheckCollectionCell.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 12/04/21.
//

import UIKit

open class BAZ_StepCheckCollectionCell: UICollectionViewCell {

    lazy var itemContent: UIView = {
        let view = UIView(frame: .zero)
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12)
        view.backgroundColor = BAZ_ColorManager.purpleToolBarRW
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var itemCheck: UIImageView = {
        let imageview = UIImageView(frame: .zero)
        imageview.tintColor = .white
        imageview.image = UIImage(bazNamed: "checkIcon")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var noneSpace: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
        setupConstraints()
    }
    
    public func buildCurrentStep(){
        self.itemContent.layer.cornerRadius = (self.frame.height / 2)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUIElements() {
        self.addSubview(itemContent)
        self.addSubview(noneSpace)
        self.itemContent.addSubview(itemCheck)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.itemContent.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.itemContent.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.itemContent.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.itemContent.bottomAnchor.constraint(equalTo: noneSpace.topAnchor),
           
            self.noneSpace.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.noneSpace.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.noneSpace.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),

            self.itemCheck.topAnchor.constraint(equalTo: self.itemContent.topAnchor, constant: 6),
            self.itemCheck.leadingAnchor.constraint(equalTo: self.itemContent.leadingAnchor, constant: 6),
            self.itemCheck.trailingAnchor.constraint(equalTo: self.itemContent.trailingAnchor, constant: -6),
            self.itemCheck.bottomAnchor.constraint(equalTo: self.itemContent.bottomAnchor, constant: -6)
        ])
    }
}
