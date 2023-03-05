//
//  BAZ_ShareActionView.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 15/06/21.
//

import UIKit

@objc public protocol BAZ_ShareActionViewDelegate: AnyObject {
    @objc optional func notifyPrintTicket()
    @objc optional func notifyShareTicketToEmail()
    @objc optional func notifyShareTicketToSMS()
    @objc optional func notifyShareTicket()
}

open class BAZ_ShareActionView: UIView {
    public weak var delegate: BAZ_ShareActionViewDelegate?
    lazy var container: UIStackView = {
        let container = UIStackView(frame: .zero)
        container.axis = .horizontal
        container.spacing = 30
        container.alignment = .center
        container.distribution = .equalCentering
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    public convenience init(
        tintColor: UIColor,
        withComponents : [BAZ_ShareActionType]) {
        self.init()
        setupUIElements(withComponents: withComponents, tintColor: tintColor)
        setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUIElements(withComponents : [BAZ_ShareActionType], tintColor: UIColor){
        self.addSubview(container)
        for (index, element) in withComponents.enumerated() {
            let view = UIView(frame: .zero)
            let viewImage = UIView(frame: .zero)
            let image = UIImageView(frame: .zero)
            let title = UILabel(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .clear
            view.isUserInteractionEnabled = true

            viewImage.translatesAutoresizingMaskIntoConstraints = false
            viewImage.backgroundColor = .white
            viewImage.layer.cornerRadius = 30
            viewImage.layer.shadowRadius = 8
            viewImage.layer.shadowOffset =  CGSize(width: 0, height: 3)
            viewImage.layer.shadowColor = #colorLiteral(red: 0.05098039216, green: 0.2745098039, blue: 0.8352941176, alpha: 0.09793874172)
            viewImage.layer.shadowOpacity = 1
            
            var auxImage: UIImage?
            switch element {
            case .Email:
                auxImage = UIImage(bazNamed: "shareEmailIcon")
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.emailTapped)))
            case .Share:
                auxImage = UIImage(bazNamed: "shareIcon")
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.shareTapped)))
            case .Print:
                auxImage = UIImage(bazNamed: "sharePrinterpurpleIcon")
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.printTapped)))
            case .SMS:
                auxImage = UIImage(bazNamed: "shareIcon")
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.smsTapped)))
            }
            image.image = auxImage
            
//            image.image = element == BAZ_ShareActionType.Email ?  UIImage(bazNamed: "shareEmailIcon") :
//                element == BAZ_ShareActionType.Print ? UIImage(bazNamed: "sharePrinterpurpleIcon") :  UIImage(bazNamed: "shareIcon")
            
            image.translatesAutoresizingMaskIntoConstraints = false
            image.tintColor = tintColor
            image.contentMode = .scaleAspectFit
            title.translatesAutoresizingMaskIntoConstraints = false
            title.font = .Poppins_Regular_12
            title.textColor = BAZ_ColorManager.navyBlueDarkRW
            title.text = element.rawValue
            view.tag = index
            view.addSubview(viewImage)
            viewImage.addSubview(image)
            view.addSubview(title)
            NSLayoutConstraint.activate([
                viewImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                viewImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
                viewImage.heightAnchor.constraint(equalToConstant: 60),
                viewImage.widthAnchor.constraint(equalToConstant: 60),
                image.centerXAnchor.constraint(equalTo: viewImage.centerXAnchor),
                image.centerYAnchor.constraint(equalTo: viewImage.centerYAnchor),
                image.heightAnchor.constraint(equalToConstant: 20),
                image.widthAnchor.constraint(equalToConstant: 20),
                title.topAnchor.constraint(equalTo: viewImage.bottomAnchor, constant: 13),
                title.centerXAnchor.constraint(equalTo: viewImage.centerXAnchor),
                title.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                title.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                title.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
            ])
            container.addArrangedSubview(view)
//           / view.addge
        }
    }
    
    
    fileprivate func setupConstraints(){
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func didTapElement(_ sender: UIView){
        delegate?.notifyPrintTicket?()
    }
    
    
    @objc private func printTapped(){
        delegate?.notifyPrintTicket?()
    }
    @objc private func shareTapped(){
        delegate?.notifyShareTicket?()
    }
    @objc private func emailTapped(){
        delegate?.notifyShareTicketToEmail?()
    }
    @objc private func smsTapped(){
        delegate?.notifyShareTicketToSMS?()
    }
}
