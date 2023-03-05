//
//  BAZ_AlertErrorView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Phinder on 29/04/22.
//



import UIKit

@objc public protocol BAZ_AlertErrorViewDelegate:NSObjectProtocol {
    @objc optional func alertErrorBackActionWithTag(tag: Int)
    @objc optional func alertErrorBackAction()
}


open class BAZ_AlertErrorView: UIViewController {
    public weak var delegate: BAZ_AlertErrorViewDelegate?
    internal var alertTitle: String?
    
    
    private lazy var navigationBar: BAZ_NavigationView = {
        let navigationController = BAZ_NavigationView(frame: .zero)
        navigationController.translatesAutoresizingMaskIntoConstraints = false
        return navigationController
    }()
    
    private lazy var cardView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var alertImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(bazNamed: "alertErrorIcon")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Operación Fallida"
        label.font = .Poppins_Semibold_18
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionScroll: UIScrollView = {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.bounces = false
        return scrollview
    }()
    
    public lazy var subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Ocurrió un problema al realizar la operación"
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.font = .Poppins_Semibold_18
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = ""
        label.font = .Poppins_Regular_15
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backButton: BAZ_UpdatedButtonView = {
        let btn = BAZ_UpdatedButtonView(titleText: "Regresar",
                                        textAlignment: .Center,
                                        buttonBackgroundColor: .clear,
                                        buttonSecondBackgroundColor: .clear,
                                        buttonTintColor: BAZ_ColorManager.navyBlueDarkRW,
                                        showIcon: false)
        btn.addTarget(self, action: #selector(self.returnAction(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setEnableButton(enable: true)
        return btn
    }()


    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationBar.setComponents(title: self.alertTitle ?? "baz acepta pago",
                                         navigationController: nil,
                                         hiddenBackButton: true)
        
        self.setupUIElements()
        self.setupConstraints()
    }
    
    fileprivate func setupUIElements(){
        self.view.addSubview(self.navigationBar)
        self.view.addSubview(self.cardView)
        
        self.cardView.addSubview(self.alertImage)
        self.cardView.addSubview(self.titleLabel)
        self.cardView.addSubview(self.descriptionScroll)
        
        self.descriptionScroll.addSubview(self.subtitleLabel)
        self.descriptionScroll.addSubview(self.descriptionLabel)
        
        self.cardView.addSubview(self.backButton)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.navigationBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.cardView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor, constant: 60 * UIDevice.screenMultiplier),
            self.cardView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.70),
            self.cardView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.cardView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            self.alertImage.topAnchor.constraint(equalTo: self.cardView.topAnchor),
            self.alertImage.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor),
            self.alertImage.heightAnchor.constraint(equalToConstant: 95 * UIDevice.screenMultiplier),
            self.alertImage.widthAnchor.constraint(equalToConstant: 95 * UIDevice.screenMultiplier),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.alertImage.bottomAnchor, constant: 30 * UIDevice.screenMultiplier),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            
            self.descriptionScroll.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 30 * UIDevice.screenMultiplier),
            self.descriptionScroll.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.descriptionScroll.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.descriptionScroll.bottomAnchor.constraint(equalTo: self.backButton.topAnchor, constant: -20),
            
            self.subtitleLabel.topAnchor.constraint(equalTo: self.descriptionScroll.topAnchor),
            self.subtitleLabel.leadingAnchor.constraint(equalTo: self.descriptionScroll.leadingAnchor),
            self.subtitleLabel.widthAnchor.constraint(equalTo: self.descriptionScroll.widthAnchor),
            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.descriptionScroll.trailingAnchor),
            
            self.descriptionLabel.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor, constant: 20),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.descriptionScroll.leadingAnchor),
            self.descriptionLabel.widthAnchor.constraint(equalTo: self.descriptionScroll.widthAnchor),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.descriptionScroll.trailingAnchor),
            self.descriptionLabel.bottomAnchor.constraint(equalTo: self.descriptionScroll.bottomAnchor),

            self.backButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.backButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.backButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
            self.backButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        self.navigationBar.addBorder()
    }
    
    
    @objc private func returnAction(_ sender: UIButton){
        dismiss(animated: true, completion: {
            self.delegate?.alertErrorBackAction?()
            self.delegate?.alertErrorBackActionWithTag?(tag: self.view.tag)
        })
    }
}
