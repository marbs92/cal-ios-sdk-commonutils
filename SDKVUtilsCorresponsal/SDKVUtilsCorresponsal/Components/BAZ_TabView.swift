//
//  BAZ_TabView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 12/02/22.
//

import UIKit

public enum BAZ_TabViewStatus{
    case Selected
    case Deselected
}

public class BAZ_TabView: UIView {
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var imgTab: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var imgContainer: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lbTitle: UILabel = {
        let  lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private var contentColorEnabled     :   UIColor?
    private var contentColorDisabled    :   UIColor?
    private var backgroundColorEnabled  :   UIColor?
    private var backgroundColorDisabled :   UIColor?
    
    private var isShowingIcon : Bool = false

    public init(title: String,
                titleFont: UIFont = UIFont.Poppins_Regular_14,
                icon: UIImage? = nil,
                contentColorEnabled: UIColor = UIColor.white,
                contentColorDisabled: UIColor = BAZ_ColorManager.navyBlueDarkRW,
                backgroundColorEnabled: UIColor = UIColor.black,
                backgroundColorDisabled: UIColor = UIColor.white,
                shadowOpacity: Float = 0.2,
                radius: CGFloat = 8.0,
                height: CGFloat = 40.0,
                status: BAZ_TabViewStatus = .Deselected){
        
        super.init(frame: CGRect.zero)
        
        self.applyStyle(radius: radius, shadowOpacity: shadowOpacity)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.buildUIElements(title: title,
                             titleFont: titleFont,
                             icon: icon,
                             contentColorEnabled: contentColorEnabled,
                             contentColorDisabled: contentColorDisabled,
                             backgroundColorEnabled: backgroundColorEnabled,
                             backgroundColorDisabled: backgroundColorDisabled)
        self.buildContraints(height: height)
        self.setTabStatus(status)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUIElements(title: String,
                                 titleFont: UIFont,
                                 icon: UIImage?,
                                 contentColorEnabled: UIColor,
                                 contentColorDisabled: UIColor,
                                 backgroundColorEnabled: UIColor,
                                 backgroundColorDisabled: UIColor){
        
        self.contentColorEnabled        =   contentColorEnabled
        self.contentColorDisabled       =   contentColorDisabled
        self.backgroundColorEnabled     =   backgroundColorEnabled
        self.backgroundColorDisabled    =   backgroundColorDisabled
        
        lbTitle.text = title
        lbTitle.font = titleFont
        
        if icon != nil{
            imgTab.image = icon
            imgContainer.isHidden = false
            isShowingIcon = true
            imgContainer.addSubview(imgTab)
            stackView.addArrangedSubview(imgContainer)
        }
        
        stackView.addArrangedSubview(lbTitle)
        self.addSubview(stackView)
    }
    
    private func buildContraints(height: CGFloat){
        
        let lbTitleWidth = lbTitle.intrinsicContentSize.width
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height),
            
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.0),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15.0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            lbTitle.widthAnchor.constraint(equalToConstant: lbTitleWidth)
        ])
        
        if isShowingIcon{
            NSLayoutConstraint.activate([
                imgTab.centerYAnchor.constraint(equalTo: imgContainer.centerYAnchor),
                imgTab.leadingAnchor.constraint(equalTo: imgContainer.leadingAnchor),
                imgTab.heightAnchor.constraint(equalToConstant: 15.0),
                imgTab.widthAnchor.constraint(equalToConstant: 15.0),
                imgTab.trailingAnchor.constraint(equalTo: imgContainer.trailingAnchor)
            ])
        }
    }
    
    private func applyStyle(radius: CGFloat, shadowOpacity: Float) {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = 1.5
        self.layer.cornerRadius = radius
        self.layer.shadowOffset = .zero
    }
    
    public func setTabStatus(_ status: BAZ_TabViewStatus){
        self.lbTitle.textColor = status == .Selected ? self.contentColorEnabled : self.contentColorDisabled
        self.backgroundColor = status == .Selected ? self.backgroundColorEnabled : self.backgroundColorDisabled
        
        if isShowingIcon{
            self.imgTab.tintColor = status == .Selected ? self.contentColorEnabled : self.contentColorDisabled
        }
    }
}
