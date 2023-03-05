//
//  NavigationCustomView.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 05/04/21.
//

import UIKit
public extension UIDevice {
    /// Returns `true` if the device has a notch
    public var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}
open class BAZ_NavigationView: UIView {

    var navigationbar: UINavigationController?
    var arrowIcon: String = "arrowLeftIcon"
    public lazy var containerBezel: UIView = {
        let view = UIView(frame: .zero)
        view.layer.shadowRadius = 7
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1221039245)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(bazNamed: "arrowLeftIcon"), for: .normal)
        button.setImage(UIImage(bazNamed: "arrowLeftIcon"), for: .highlighted)
        button.imageEdgeInsets = UIEdgeInsets(top: 17.25, left: 16, bottom: 17.25, right: 16)
        return button
    }()
    
    lazy var titleSection: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    lazy var imageLogoNavBar: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.image = UIImage(bazNamed: "logoColorfullIcon")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var withAnimation :Bool?
    private var titleCenterYAnchor: NSLayoutConstraint?
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        buildUI()
        buildConstraint()
    }
    
    public func setComponents(
        title: String,
        navigationController: UINavigationController?,
        withAnimation: Bool = true,
        hiddenBackButton: Bool = false,
        backgroundColor: UIColor = .white,
        withShadows: Bool = false,
        withLogo: Bool = false,
        fontStyle: UIFont  = .Poppins_Medium_18,
        cornerRadius: Int = 0,
        titleCenterY: Int = 0,
        titleSectionColor: UIColor = BAZ_ColorManager.navyBlueDarkRW,
        backTintColor: UIColor = BAZ_ColorManager.purpleToolBarRW,
        arrowIcon: String = "arrowLeftIcon"){
        self.titleSection.text = title
        self.titleSection.font = fontStyle
        self.titleSection.textColor = titleSectionColor
        self.backButton.tintColor = backTintColor
        self.backButton.isHidden = hiddenBackButton
        self.containerBezel.backgroundColor = backgroundColor
        self.containerBezel.clipsToBounds = !withShadows
        self.containerBezel.layer.cornerRadius = CGFloat(cornerRadius)
        self.imageLogoNavBar.isHidden = !withLogo
        self.navigationbar = navigationController
        self.withAnimation = withAnimation
        self.titleCenterYAnchor?.constant = CGFloat(titleCenterY)
        self.arrowIcon = arrowIcon
        self.backButton.setImage(
            UIImage(bazNamed: self.arrowIcon)
            ??
            UIImage(bazNamed: "arrowLeftIcon"),
            for: .normal)
        self.backButton.setImage(
            UIImage(bazNamed: self.arrowIcon)
            ??
            UIImage(bazNamed: "arrowLeftIcon"),
            for: .highlighted)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func buildUI(){
        self.backButton.addTarget(self, action: #selector(self.popNavigationController), for: .touchUpInside)
        self.backgroundColor = .clear
        self.addSubview(containerBezel)
        containerBezel.addSubview(backButton)
        containerBezel.addSubview(titleSection)
        containerBezel.addSubview(imageLogoNavBar)
    }
    
    
    fileprivate func buildConstraint(){
       //hasNotch if UIDevice.hasNotch
        if UIDevice.current.hasTopNotch == true{
            NSLayoutConstraint.activate([
                self.containerBezel.topAnchor.constraint(equalTo: self.topAnchor, constant: -20),
                self.containerBezel.heightAnchor.constraint(equalToConstant: 120),
                self.backButton.centerYAnchor.constraint(equalTo: self.containerBezel.centerYAnchor, constant: 30),
            ])
        }else{
            NSLayoutConstraint.activate([
                self.containerBezel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                self.containerBezel.heightAnchor.constraint(equalToConstant: 80),
                self.backButton.centerYAnchor.constraint(equalTo: self.containerBezel.centerYAnchor, constant: 10),
            ])
        }
        NSLayoutConstraint.activate([
            self.containerBezel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.containerBezel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 30),
            self.containerBezel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.backButton.heightAnchor.constraint(equalToConstant: 48),
            self.backButton.widthAnchor.constraint(equalToConstant: 48),
            self.backButton.leadingAnchor.constraint(equalTo: self.containerBezel.leadingAnchor, constant: 15),
            
            self.imageLogoNavBar.heightAnchor.constraint(equalToConstant: 37),
            self.imageLogoNavBar.widthAnchor.constraint(equalToConstant: 50),
            self.imageLogoNavBar.trailingAnchor.constraint(equalTo: self.containerBezel.trailingAnchor, constant: -50),
            self.imageLogoNavBar.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor, constant: 0),
            
            self.titleSection.leadingAnchor.constraint(equalTo: self.backButton.trailingAnchor, constant: 15),
            self.titleSection.trailingAnchor.constraint(equalTo: self.imageLogoNavBar.leadingAnchor, constant: -10),
        ])
        
        titleCenterYAnchor = NSLayoutConstraint(item: titleSection, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: backButton, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        titleCenterYAnchor?.isActive = true
    }
    /*
    @objc func popNavigationController(){
        self.navigationbar?.popViewController(animated: withAnimation ?? true)
    }*/
    
    @objc func popNavigationController(){
        if let navController = self.navigationbar {
            navController.popViewController(animated: withAnimation ?? true)
        }else {
            
        }
    }
    
    public func assignCustomBackEvent(target: Any, event: Selector, eventTrigger: UIControl.Event){
        self.backButton.removeTarget(nil, action: nil, for: .allEvents)
        self.backButton.addTarget(target, action: event, for: eventTrigger)
    }
}
