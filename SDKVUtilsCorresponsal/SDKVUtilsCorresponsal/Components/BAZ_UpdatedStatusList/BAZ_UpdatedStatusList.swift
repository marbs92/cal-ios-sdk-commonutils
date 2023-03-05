//
//  BAZ_UpdatedStatusList.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 09/05/22.
//

import Foundation
import UIKit

open class BAZ_UpdatedStatusList: UIView {
    private var sectionsViews: [BAZ_UpdatedStatusListSectionView] = []
    
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
        stack.spacing = 30
        return stack
    }()
    
    public convenience init(sections: [BAZ_UpdatedStatusListSection]) {
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
    
    private func buildList(sections: [BAZ_UpdatedStatusListSection]) {
        for section in sections {
            let sectionObject = BAZ_UpdatedStatusListSectionView(sectionData: section)
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
//                verticalLine.backgroundColor = BAZ_ColorManager.statusListGray
 
                self.containerStack.addSubview(verticalLine)
                
                NSLayoutConstraint.activate([
                    verticalLine.widthAnchor.constraint(equalToConstant: 2),
                    verticalLine.topAnchor.constraint(equalTo: self.sectionsViews[index - 1].titleDotView.bottomAnchor, constant: 2),
                    verticalLine.bottomAnchor.constraint(equalTo: self.sectionsViews[index].titleDotView.topAnchor),
                    verticalLine.centerXAnchor.constraint(equalTo: self.sectionsViews[index].titleDotView.centerXAnchor)
                ])
                verticalLine.dotted(color: BAZ_ColorManager.statusListGray,
                                    orientation: .Vertical,
                                    diameter: 2.5,
                                    separation: 5)
            }
        }
    }
    

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public  func addSection(section: BAZ_UpdatedStatusListSection) {
        DispatchQueue.main.async {
            self.buildList(sections: [section])
        }
    }
}
