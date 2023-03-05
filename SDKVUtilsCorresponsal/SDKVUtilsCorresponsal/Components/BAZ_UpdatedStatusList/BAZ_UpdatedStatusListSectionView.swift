//
//  BAZ_UpdatedStatusListSectionView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 09/05/22.
//

import Foundation
import UIKit


internal class BAZ_UpdatedStatusListSectionView: UIView {
    internal var sectionData = BAZ_UpdatedStatusListSection(title: "",
                                                            sectionStatus: .Pending)

    
    internal lazy var titleDotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = self.sectionData.sectionStatus.getOutterColor()
        
        if self.sectionData.sectionStatus == .Pending {
            view.layer.borderWidth = 1
            view.layer.borderColor = self.sectionData.sectionStatus.getOutterColor().cgColor
            view.backgroundColor = self.sectionData.sectionStatus.getCenterColor()
        } else {
            let centerView = UIView()
            centerView.translatesAutoresizingMaskIntoConstraints = false
            centerView.backgroundColor = self.sectionData.sectionStatus.getCenterColor()
            centerView.layer.cornerRadius = (self.sectionData.dotDiameter/4)
            
            let animateCenterView = UIView()
            animateCenterView.translatesAutoresizingMaskIntoConstraints = false
            animateCenterView.backgroundColor = self.sectionData.sectionStatus.getCenterColor()
            animateCenterView.layer.cornerRadius = (self.sectionData.dotDiameter/4)
            
            
            view.addSubview(animateCenterView)
            view.addSubview(centerView)
            
            let heightCenterViewAnimate = animateCenterView.heightAnchor.constraint(equalToConstant: (self.sectionData.dotDiameter/2))
            let widthCenterViewAnimate = animateCenterView.widthAnchor.constraint(equalToConstant: (self.sectionData.dotDiameter/2))
            
            NSLayoutConstraint.activate([
                centerView.heightAnchor.constraint(equalToConstant: (self.sectionData.dotDiameter/2)),
                centerView.widthAnchor.constraint(equalToConstant: (self.sectionData.dotDiameter/2)),
                centerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                centerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                heightCenterViewAnimate,
                widthCenterViewAnimate,
                animateCenterView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                animateCenterView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
            DispatchQueue.main.async {
                if self.sectionData.animateCircle {
                    animate()
                    func animate() {
                        UIView.animate(withDuration: 1, delay: 0.2) {
                            heightCenterViewAnimate.constant = self.sectionData.dotDiameter
                            widthCenterViewAnimate.constant = self.sectionData.dotDiameter
                            animateCenterView.layer.cornerRadius = (self.sectionData.dotDiameter/2)
                            animateCenterView.backgroundColor = self.sectionData.sectionStatus.getOutterColor()
                            self.layoutIfNeeded()
                        } completion: { _ in
                            UIView.animate(withDuration: 0.3) {
                                animateCenterView.backgroundColor = self.sectionData.sectionStatus.getOutterColor().withAlphaComponent(0)
                                self.layoutIfNeeded()
                            } completion: { _ in
                                heightCenterViewAnimate.constant = (self.sectionData.dotDiameter/2)
                                widthCenterViewAnimate.constant = (self.sectionData.dotDiameter/2)
                                animateCenterView.layer.cornerRadius = (self.sectionData.dotDiameter/4)
                                animateCenterView.backgroundColor = self.sectionData.sectionStatus.getCenterColor()
                                self.layoutIfNeeded()
                                animate()
                            }
                        }
                    }
                }
            }
        }
        
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
        
        if !self.sectionData.content.isEmpty {
            label.text = self.sectionData.content
            label.font = self.sectionData.contentFont
            label.textColor = self.sectionData.contentColor
        } else if let attributedText = self.sectionData.attributedContent, attributedText.length > 0 {
            label.attributedText = attributedText
        }
        
        label.numberOfLines = 0
        return label
    }()

    public convenience init(sectionData: BAZ_UpdatedStatusListSection) {
        self.init()
        
        self.sectionData = sectionData
        
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
        self.addSubview(self.titleDotView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.contentLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.titleDotView.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            self.titleDotView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleDotView.heightAnchor.constraint(equalToConstant: self.sectionData.dotDiameter),
            self.titleDotView.widthAnchor.constraint(equalToConstant: self.sectionData.dotDiameter),
        
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.titleDotView.trailingAnchor, constant: 15),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.contentLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5),
            self.contentLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.contentLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
            self.contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
