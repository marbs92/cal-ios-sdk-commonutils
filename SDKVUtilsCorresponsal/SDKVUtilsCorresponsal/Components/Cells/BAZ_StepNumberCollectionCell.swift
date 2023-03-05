//
//  StepNumberCollectionCell.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 12/04/21.
//

import UIKit

open class BAZ_StepNumberCollectionCell: UICollectionViewCell {

    lazy var itemContent: UIView = {
        let view = UIView(frame: .zero)
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var itemNumber: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .Poppins_Bold_16
        label.numberOfLines = 1
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleSection: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = BAZ_ColorManager.purpleToolBarRW
        lable.font = .Poppins_Bold_16
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
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
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func buildCurrentStep(){
        self.itemContent.backgroundColor = BAZ_ColorManager.purpleToolBarRW
    }
    
    public func buildNextStep(){
        self.itemContent.backgroundColor = BAZ_ColorManager.dissableButtonRW
       
    }
    
    fileprivate func setupUIElements() {
        self.addSubview(itemContent)
        self.addSubview(titleSection)
        self.addSubview(noneSpace)
        self.itemContent.addSubview(itemNumber)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.itemContent.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.itemContent.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.itemContent.bottomAnchor.constraint(equalTo: noneSpace.topAnchor),
            self.itemContent.heightAnchor.constraint(equalToConstant: 36),
            self.itemContent.widthAnchor.constraint(equalToConstant: 36),
            
            self.titleSection.leadingAnchor.constraint(equalTo: itemContent.trailingAnchor,constant: 8),
            self.titleSection.centerYAnchor.constraint(equalTo: itemContent.centerYAnchor),
            self.titleSection.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.noneSpace.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.noneSpace.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.noneSpace.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.itemNumber.centerYAnchor.constraint(equalTo: self.itemContent.centerYAnchor),
            self.itemNumber.centerXAnchor.constraint(equalTo: self.itemContent.centerXAnchor),
            
        ])
    }
}
