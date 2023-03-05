//
//  BAZ_StatusListSubItemView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 11/04/22.
//

import Foundation
import UIKit


internal class BAZ_StatusListSubItemView: UIView {
    internal var subItemData: BAZ_StatusListSubItem = BAZ_StatusListSubItem(content: "")
    
    internal lazy var contentDotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = self.subItemData.subItemColor
        view.layer.cornerRadius = (self.subItemData.subItemDotDiameter/2)
        return view
    }()
    
    internal lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.subItemData.content
        label.font = self.subItemData.contentFont
        label.textColor = self.subItemData.contentColor
        label.numberOfLines = 0
        return label
    }()

    public convenience init(subItemData: BAZ_StatusListSubItem) {
        self.init()
        
        self.subItemData = subItemData
        
        self.buildUI()
        self.setConstraints()
        
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func buildUI() {
        self.addSubview(self.contentDotView)
        self.addSubview(self.contentLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.contentDotView.topAnchor.constraint(equalTo: self.contentLabel.topAnchor, constant: 5),
            self.contentDotView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentDotView.heightAnchor.constraint(equalToConstant: self.subItemData.subItemDotDiameter),
            self.contentDotView.widthAnchor.constraint(equalToConstant: self.subItemData.subItemDotDiameter),
    
            self.contentLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentLabel.leadingAnchor.constraint(equalTo: self.contentDotView.trailingAnchor, constant: 8),
            self.contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
