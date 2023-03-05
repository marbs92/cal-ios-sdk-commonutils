//
//  BAZ_StepNumberOnbordingCollectionCell.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 13/08/21.
//

import UIKit

open class BAZ_StepNumberOnbordingCollectionCell: UICollectionViewCell {

    lazy var itemContent: UIView = {
        let view = UIView(frame: .zero)
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var itemNumber: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Poppins_Regular_14
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        self.itemContent.backgroundColor = .white
        self.itemContent.layer.borderColor = BAZ_ColorManager.greenDarkRW.cgColor
        self.itemContent.layer.borderWidth = 2
        self.itemNumber.textColor = BAZ_ColorManager.greenDarkRW
        self.itemContent.layer.cornerRadius = (self.frame.height / 2)
    }
    
    public func buildNextStep(){
        self.itemContent.backgroundColor = .lightGray
        self.itemContent.layer.borderColor = nil
        self.itemContent.layer.borderWidth = 0
        self.itemNumber.textColor = .white
        self.itemContent.layer.cornerRadius = (self.frame.height / 2)
    }
    
    fileprivate func setupUIElements() {
        self.addSubview(itemContent)
        self.addSubview(noneSpace)
        self.itemContent.addSubview(itemNumber)
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
            
            self.itemNumber.centerYAnchor.constraint(equalTo: self.itemContent.centerYAnchor),
            self.itemNumber.centerXAnchor.constraint(equalTo: self.itemContent.centerXAnchor),
        ])
    }
}
