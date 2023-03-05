//
//  BAZ_FrontErrorView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Phinder 2022 on 20/07/22.
//

import UIKit

@objc public protocol BAZ_FrontErrorViewDelegate:NSObjectProtocol {
    @objc optional func alertErrorFrontActionWithTag(tag: Int)
    @objc optional func alertErrorFrontAction()
}


open class BAZ_FrontErrorView: UIViewController {
    
    private lazy var contentView: UIScrollView = {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.backgroundColor = .red
        return scrollview
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = BAZ_ColorManager.whiteNavBarBackground
        return view
    }()
    
    private lazy var imageWarning: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(bazNamed: "alertWarningIcon")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var titleTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.statusListConditioned
        label.numberOfLines = 0
        label.font = .Poppins_Semibold_16
        label.text = "Algo no está bien"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.font = .Poppins_Regular_15
        label.text = message
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var confirmButton: BAZ_UpdatedButtonView = {
        let btn = BAZ_UpdatedButtonView(
            titleText: "Aceptar",
            textAlignment: .Center,
            buttonBackgroundColor: BAZ_ColorManager.statusListConditioned,
            buttonSecondBackgroundColor: BAZ_ColorManager.statusListConditioned,
            buttonTintColor: BAZ_ColorManager.noneSpaceRW,
            buttonCornerRadius: 20,
            showIcon: false)
        btn.addTarget(self, action: #selector(self.returnAction(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setEnableButton(enable: true)
        return btn
    }()
    
    public weak var delegate    :   BAZ_FrontErrorViewDelegate?
    var message : String?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElements()
        setupConstraints()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.69921875)
    }
    
    
    fileprivate func setupUIElements() {
        view.addSubview(cardView)
        cardView.addSubview(imageWarning)
        cardView.addSubview(titleTextLabel)
        cardView.addSubview(contentTextLabel)
        cardView.addSubview(confirmButton)
       
    }
    
    fileprivate func setupConstraints() {
        // add constraints to subviews
        NSLayoutConstraint.activate([
            
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageWarning.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 15),
            imageWarning.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            imageWarning.heightAnchor.constraint(equalToConstant: 70),
            imageWarning.widthAnchor.constraint(equalToConstant: 70),

            titleTextLabel.topAnchor.constraint(equalTo: imageWarning.bottomAnchor, constant: 10),
            titleTextLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            titleTextLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),

            contentTextLabel.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: 15),
            contentTextLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            contentTextLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),

            confirmButton.topAnchor.constraint(equalTo: contentTextLabel.bottomAnchor, constant: 30),
            confirmButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor,constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 60),
            confirmButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -60),
            confirmButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc private func returnAction(_ sender: UIButton){
        dismiss(animated: true, completion: {
            self.delegate?.alertErrorFrontAction?()
            self.delegate?.alertErrorFrontActionWithTag?(tag: self.view.tag)
        })
        
    }
}

