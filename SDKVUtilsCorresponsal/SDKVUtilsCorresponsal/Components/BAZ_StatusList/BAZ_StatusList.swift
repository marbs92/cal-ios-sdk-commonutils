//
//  BAZ_StatusList.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 07/04/22.
//

import Foundation
import UIKit

open class BAZ_StatusList: UIView {
    private var sectionsViews: [BAZ_StatusListSectionView] = []
    
    private lazy var mainContainerView: UIView = {
       let scroll = UIView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var containerStack: UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .top
        stack.spacing = 20
        return stack
    }()
    
    public convenience init(sections: [BAZ_StatusListSection]) {
        self.init()
        
        self.buildUI()
        self.setConstraints()
        
        self.buildList(sections: sections)
    }
    
    
    private func buildUI() {
        self.addSubview(self.mainContainerView)
        self.mainContainerView.addSubview(self.containerStack)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.mainContainerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mainContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mainContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.containerStack.topAnchor.constraint(equalTo: self.mainContainerView.topAnchor),
            self.containerStack.leadingAnchor.constraint(equalTo: self.mainContainerView.leadingAnchor),
            self.containerStack.trailingAnchor.constraint(equalTo: self.mainContainerView.trailingAnchor),
            self.containerStack.bottomAnchor.constraint(equalTo: self.mainContainerView.bottomAnchor),
            self.containerStack.widthAnchor.constraint(equalTo: self.mainContainerView.widthAnchor),
        ])
    }
    
    private func buildList(sections: [BAZ_StatusListSection]) {
        for section in sections {
            let sectionObject = BAZ_StatusListSectionView(sectionData: section)
            sectionObject.translatesAutoresizingMaskIntoConstraints = false
            self.containerStack.addArrangedSubview(sectionObject)
            self.sectionsViews.append(sectionObject)
        }
        
        self.buildLines()
    }
    
    private func buildLines() {
        for index in (0..<self.sectionsViews.count).reversed() {
            if index > 0 {
                let verticalLine = UIView()
                verticalLine.translatesAutoresizingMaskIntoConstraints = false
                verticalLine.backgroundColor = self.sectionsViews[index].titleDotView.backgroundColor
 
                self.containerStack.addSubview(verticalLine)
                
                NSLayoutConstraint.activate([
                    verticalLine.widthAnchor.constraint(equalToConstant: 1.5),
                    verticalLine.topAnchor.constraint(equalTo: self.sectionsViews[index - 1].titleDotView.bottomAnchor),
                    verticalLine.bottomAnchor.constraint(equalTo: self.sectionsViews[index].titleDotView.topAnchor),
                    verticalLine.centerXAnchor.constraint(equalTo: self.sectionsViews[index].titleDotView.centerXAnchor)
                ])
            }
            let subItemsArray = self.sectionsViews[index].subItemsArray
            if !subItemsArray.isEmpty {
                for subItemIndex in (0..<subItemsArray.count).reversed() {
                    var subItemLinesColor: UIColor = self.sectionsViews[index].sectionData.dotColor
                    
                    if let color = subItemsArray[subItemIndex].subItemData.subItemColor {
                        subItemLinesColor = color
                    }
                    
                    
                    let subItemVerticalLine = UIView()
                    subItemVerticalLine.translatesAutoresizingMaskIntoConstraints = false
                    subItemVerticalLine.backgroundColor = subItemLinesColor
     
                    let subItemHorizontalLine = UIView()
                    subItemHorizontalLine.translatesAutoresizingMaskIntoConstraints = false
                    subItemHorizontalLine.backgroundColor = subItemLinesColor
     
                    self.containerStack.addSubview(subItemVerticalLine)
                    self.containerStack.addSubview(subItemHorizontalLine)
                    
                    NSLayoutConstraint.activate([
                        subItemVerticalLine.widthAnchor.constraint(equalToConstant: 1.5),
                        subItemVerticalLine.topAnchor.constraint(equalTo: self.sectionsViews[index].titleDotView.bottomAnchor),
                        subItemVerticalLine.bottomAnchor.constraint(equalTo: subItemsArray[subItemIndex].contentDotView.centerYAnchor),
                        subItemVerticalLine.centerXAnchor.constraint(equalTo: self.sectionsViews[index].titleDotView.centerXAnchor),
                        
                        subItemHorizontalLine.heightAnchor.constraint(equalToConstant: 1.5),
                        subItemHorizontalLine.leadingAnchor.constraint(equalTo: subItemVerticalLine.leadingAnchor),
                        subItemHorizontalLine.trailingAnchor.constraint(equalTo: subItemsArray[subItemIndex].contentDotView.leadingAnchor),
                        subItemHorizontalLine.centerYAnchor.constraint(equalTo: subItemsArray[subItemIndex].contentDotView.centerYAnchor)
                    ])
                }
            }
        }
    }
    

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public  func addSection(section: BAZ_StatusListSection) {
        DispatchQueue.main.async {
            self.buildList(sections: [section])
        }
    }
}
