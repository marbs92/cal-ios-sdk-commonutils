//
//  OptionsHeaderShimmerCollectionCell.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 07/04/21.
//

import UIKit

open class BAZ_OptionsHeaderShimmerCollectionCell: UICollectionReusableView {
    
    lazy public var titleView: BAZ_ShimmerView = {
        let label = BAZ_ShimmerView(frame: .zero)
        label.backgroundColor = UIColor(white: 0.85, alpha: 0.3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUIElements()
        setupConstraints()
        titleView.startAnimating()
     }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    fileprivate func setupUIElements() {
        self.addSubview(titleView)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10),
            titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -20),
            titleView.widthAnchor.constraint(equalToConstant: 150),
            titleView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
