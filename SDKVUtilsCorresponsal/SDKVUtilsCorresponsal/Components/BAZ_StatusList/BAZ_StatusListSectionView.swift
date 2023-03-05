//
//  BAZ_StatusListItemView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 11/04/22.
//

import Foundation
import UIKit


internal class BAZ_StatusListSectionView: UIView {
    internal var sectionData = BAZ_StatusListSection(title: "",
                                                     content: "",
                                                     dotColor: BAZ_ColorManager.purpleToolBarRW)
    
    internal var subItemsArray: [BAZ_StatusListSubItemView] = []
    
    internal lazy var titleDotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = self.sectionData.dotColor
        view.layer.cornerRadius = (self.sectionData.dotDiameter/2)
        return view
    }()
    
    internal lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.sectionData.title
        label.font = self.sectionData.titleFont
        label.textColor = self.sectionData.titleColor
        label.numberOfLines = 0
        return label
    }()
    
    internal lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.sectionData.content
        label.font = self.sectionData.contentFont
        label.textColor = self.sectionData.contentColor
        label.numberOfLines = 0
        return label
    }()

    public convenience init(sectionData: BAZ_StatusListSection) {
        self.init()
        
        self.sectionData = sectionData
        
        self.buildUI()
        self.setConstraints()
        
        self.buildSubItems()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func buildUI() {
        self.addSubview(self.titleDotView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.contentLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.titleDotView.topAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: 5),
            self.titleDotView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleDotView.heightAnchor.constraint(equalToConstant: self.sectionData.dotDiameter),
            self.titleDotView.widthAnchor.constraint(equalToConstant: self.sectionData.dotDiameter),
        
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.titleDotView.trailingAnchor, constant: 15),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.contentLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.contentLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.contentLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
        ])
        if self.sectionData.subItems == nil {
            NSLayoutConstraint.activate([
                self.contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
        }
    }
    
    private func buildSubItems() {
        if let subItems = self.sectionData.subItems {
            let subItemsContainerView = UIView()
            subItemsContainerView.translatesAutoresizingMaskIntoConstraints = false
            
            let subItemsStack = UIStackView()
            subItemsStack.translatesAutoresizingMaskIntoConstraints = false
            subItemsStack.axis = .vertical
            subItemsStack.distribution = .fill
            subItemsStack.alignment = .top
            subItemsStack.spacing = 10
            
            self.addSubview(subItemsContainerView)
            subItemsContainerView.addSubview(subItemsStack)
            
            NSLayoutConstraint.activate([
                subItemsContainerView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 20),
                subItemsContainerView.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor, constant: 20),
                subItemsContainerView.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor),
                subItemsContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

                subItemsStack.topAnchor.constraint(equalTo: subItemsContainerView.topAnchor),
                subItemsStack.leadingAnchor.constraint(equalTo: subItemsContainerView.leadingAnchor),
                subItemsStack.trailingAnchor.constraint(equalTo: subItemsContainerView.trailingAnchor),
                subItemsStack.bottomAnchor.constraint(equalTo: subItemsContainerView.bottomAnchor),
                subItemsStack.widthAnchor.constraint(equalTo: subItemsContainerView.widthAnchor),
            ])
            
            for subItem in subItems {
                let subItemData = BAZ_StatusListSubItem(subItemColor: subItem.subItemColor ?? self.sectionData.dotColor,
                                                        subItemDotDiameter: subItem.subItemDotDiameter,
                                                        content: subItem.content,
                                                        contentColor: subItem.contentColor,
                                                        contentFont: subItem.contentFont)
                let subItemObject = BAZ_StatusListSubItemView(subItemData: subItemData)
                subItemObject.translatesAutoresizingMaskIntoConstraints = false
                subItemsStack.addArrangedSubview(subItemObject)
                self.subItemsArray.append(subItemObject)
            }
        }
    }
}
