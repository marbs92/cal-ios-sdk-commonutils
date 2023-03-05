//
//  BAZ_StatusListItemView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Juan on 11/04/22.
//

import Foundation
import UIKit

internal class BAZ_StatusListItemView: UIView {

    public convenience init(data: BAZ_StatusListSection) {
        self.init()
        
        self.buildUI()
        self.setConstraints()
        
        self.buildList(sections: sections)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func buildUI() {
        self.addSubview(self.containerScroll)
        self.containerScroll.addSubview(self.containerStack)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.containerScroll.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerScroll.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.containerScroll.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.containerScroll.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.containerStack.topAnchor.constraint(equalTo: self.containerScroll.topAnchor),
            self.containerStack.leadingAnchor.constraint(equalTo: self.containerScroll.leadingAnchor),
            self.containerStack.trailingAnchor.constraint(equalTo: self.containerScroll.trailingAnchor),
            self.containerStack.bottomAnchor.constraint(equalTo: self.containerScroll.bottomAnchor),
            self.containerStack.widthAnchor.constraint(equalTo: self.containerScroll.widthAnchor),
        ])
    }
    
    private func buildList(sections: [BAZ_StatusListSection]) {
        for index in 0..<sections.count {
            let section = sections[index]
            
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            
            let circleDiameter: CGFloat = 15
            let circle = UIView()
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.backgroundColor = section.item.itemColor
            circle.layer.cornerRadius = (circleDiameter/2)
            
            self.circleArray.append(circle)
            
            let titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = section.item.title
            titleLabel.font = section.item.titleFont
            titleLabel.textColor = section.item.titleColor
            
            let contentLabel = UILabel()
            contentLabel.translatesAutoresizingMaskIntoConstraints = false
            contentLabel.text = section.item.content
            contentLabel.font = section.item.contentFont
            contentLabel.textColor = section.item.contentColor
            
            container.addSubview(circle)
            container.addSubview(titleLabel)
            container.addSubview(contentLabel)
            
            NSLayoutConstraint.activate([
                circle.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                circle.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                circle.heightAnchor.constraint(equalToConstant: circleDiameter),
                circle.widthAnchor.constraint(equalToConstant: circleDiameter),
            
                titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 15),
                titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                
                contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            ])
            
            if let subItems = section.subItem {
                let subItemsContainerView = UIView()
                subItemsContainerView.translatesAutoresizingMaskIntoConstraints = false
                
                let subItemsScroll = UIScrollView()
                subItemsScroll.translatesAutoresizingMaskIntoConstraints = false
                
                let subItemsStack = UIStackView()
                subItemsStack.translatesAutoresizingMaskIntoConstraints = false
                subItemsStack.axis = .vertical
                subItemsStack.distribution = .fill
                subItemsStack.alignment = .top
                subItemsStack.spacing = 10
                
                container.addSubview(subItemsContainerView)
                subItemsContainerView.addSubview(subItemsScroll)
                subItemsScroll.addSubview(subItemsStack)
                
                NSLayoutConstraint.activate([
                    subItemsContainerView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 20),
                    subItemsContainerView.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor, constant: 20),
                    subItemsContainerView.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor),
                    subItemsContainerView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                    subItemsContainerView.heightAnchor.constraint(equalToConstant: CGFloat(subItems.count * 50)),
                    
                    subItemsScroll.topAnchor.constraint(equalTo: subItemsContainerView.topAnchor),
                    subItemsScroll.leadingAnchor.constraint(equalTo: subItemsContainerView.leadingAnchor),
                    subItemsScroll.trailingAnchor.constraint(equalTo: subItemsContainerView.trailingAnchor),
                    subItemsScroll.bottomAnchor.constraint(equalTo: subItemsContainerView.bottomAnchor),
                    
                    subItemsStack.topAnchor.constraint(equalTo: subItemsScroll.topAnchor),
                    subItemsStack.leadingAnchor.constraint(equalTo: subItemsScroll.leadingAnchor),
                    subItemsStack.trailingAnchor.constraint(equalTo: subItemsScroll.trailingAnchor),
                    subItemsStack.bottomAnchor.constraint(equalTo: subItemsScroll.bottomAnchor),
                    subItemsStack.widthAnchor.constraint(equalTo: subItemsScroll.widthAnchor),
                ])
                
                for subItemIndex in 0..<subItems.count {
                    
                    let subItemContainer = UIView()
                    subItemContainer.translatesAutoresizingMaskIntoConstraints = false
                    
                    let subItemCircleDiameter: CGFloat = 10
                    let subItemCircle = UIView()
                    subItemCircle.translatesAutoresizingMaskIntoConstraints = false
                    subItemCircle.backgroundColor = section.item.itemColor
                    subItemCircle.layer.cornerRadius = (subItemCircleDiameter/2)
                    
                    self.subItemCircleArray.append(subItemCircle)
                    
                    
                    let subItemContentLabel = UILabel()
                    subItemContentLabel.translatesAutoresizingMaskIntoConstraints = false
                    subItemContentLabel.text = subItems[subItemIndex].content
                    subItemContentLabel.font =  subItems[subItemIndex].contentFont
                    subItemContentLabel.textColor =  subItems[subItemIndex].contentColor
                    subItemContentLabel.numberOfLines = 2
                    subItemContentLabel.adjustsFontSizeToFitWidth = true
                    
                    subItemContainer.addSubview(subItemCircle)
                    subItemContainer.addSubview(subItemContentLabel)
                    
                    NSLayoutConstraint.activate([
                        subItemCircle.topAnchor.constraint(equalTo: subItemContentLabel.topAnchor, constant: 5),
                        subItemCircle.leadingAnchor.constraint(equalTo: subItemContainer.leadingAnchor),
                        subItemCircle.heightAnchor.constraint(equalToConstant: subItemCircleDiameter),
                        subItemCircle.widthAnchor.constraint(equalToConstant: subItemCircleDiameter),
                
                        subItemContentLabel.topAnchor.constraint(equalTo: subItemContainer.topAnchor),
                        subItemContentLabel.leadingAnchor.constraint(equalTo: subItemCircle.trailingAnchor, constant: 8),
                        subItemContentLabel.trailingAnchor.constraint(equalTo: subItemContainer.trailingAnchor),
                        subItemContentLabel.bottomAnchor.constraint(equalTo: subItemContainer.bottomAnchor),
                    ])
                    subItemsStack.addArrangedSubview(subItemContainer)
                }
            } else {
                NSLayoutConstraint.activate([
                    contentLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                ])
            }
            
            self.containerStack.addArrangedSubview(container)
            
            if index > 0{
                let line = UIView()
                line.backgroundColor = section.item.itemColor
                line.translatesAutoresizingMaskIntoConstraints = false
                self.containerStack.addSubview(line)
                NSLayoutConstraint.activate([
                    line.widthAnchor.constraint(equalToConstant: 1.5),
                    line.bottomAnchor.constraint(equalTo: self.circleArray[index].topAnchor),
                    line.topAnchor.constraint(equalTo: self.circleArray[index - 1].bottomAnchor),
                    line.centerXAnchor.constraint(equalTo: self.circleArray[index].centerXAnchor)
                ])
            }
        }
    
}
