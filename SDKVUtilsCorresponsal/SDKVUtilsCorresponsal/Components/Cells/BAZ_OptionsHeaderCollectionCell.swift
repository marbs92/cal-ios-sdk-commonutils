//
//  OptionsHeaderCollectionCell.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 07/04/21.
//

import UIKit

open class BAZ_OptionsHeaderCollectionCell: UICollectionReusableView {
    
    lazy public var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.font = .Poppins_Medium_18
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUIElements()
        setupConstraints()
     }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    fileprivate func setupUIElements() {
        self.addSubview(titleLabel)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -30),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -20),
        
        ])
    }
}
