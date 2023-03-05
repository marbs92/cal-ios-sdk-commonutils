//
//  BAZ_UpdatedAlertView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 29/11/21.
//


import UIKit

@objc public protocol BAZ_AlertSuccessViewProtocol: AnyObject {
 @objc optional func alertSuccessConfirmed()
}

open class BAZ_SuccessAlertView: UIView {
    private weak var parentView: UIViewController?
    private weak var parentUIView: UIView?
    private var topAnchorCustom : NSLayoutConstraint?
    private var leadingAnchorCustom : NSLayoutConstraint?
    private var trailingAnchorCustom : NSLayoutConstraint?
    private var bottomAnchorCustom : NSLayoutConstraint?
    private var heightAnchorCustom : NSLayoutConstraint?
    private var centerxAnchorCustom : NSLayoutConstraint?
    public weak var delegate : BAZ_AlertSuccessViewProtocol?
    private var showOptionalButton = false
    
    private lazy var contentView: UIScrollView = {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    private lazy var imageHeader: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(bazNamed: "HeaderAlertSuccesIcon")
        image.contentMode = UIView.ContentMode.scaleAspectFill
        return image
    }()
    
    
    private lazy var imageFailure: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(bazNamed: "alertSuccessIcon")
        return image
    }()
    
    lazy public var failedOperationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Operación Exitosa"
        label.font = .Poppins_Semibold_18
        label.textColor = BAZ_ColorManager.greenDarkRW
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy public var staticTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "La operación se ha realizado con éxito"
        label.textColor = .black
        label.font = .Poppins_Semibold_18
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy public var dinamicTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = .Poppins_Regular_15
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var acceptButton: BAZ_UpdatedButtonView = {
        let btn = BAZ_UpdatedButtonView(
            titleText: "Aceptar",
            textAlignment: .Center,
            buttonBackgroundColor: BAZ_ColorManager.greenDarkRW,
            buttonSecondBackgroundColor: BAZ_ColorManager.greenDarkRW,
            buttonTintColor: BAZ_ColorManager.noneSpaceRW,
            buttonCornerRadius: 25,
            showIcon: false)
        btn.addTarget(self, action: #selector(self.continueAction(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setEnableButton(enable: true)
        return btn
    }()
    
    public convenience init(parent: UIViewController?,
                            parentUIView: UIView? = nil,
                            delegate: BAZ_AlertSuccessViewProtocol?,
                            message: String,
                            tag: Int = 0){
        self.init(frame: UIScreen.main.bounds)
        
        self.tag = self.tag == 0 ? tag : self.tag
        
        self.alpha = 0
        
        self.parentView = parent
        self.parentUIView = parentUIView
        
        if self.parentView == nil && self.parentUIView == nil {
            return
        }
        
        self.delegate = delegate
        self.dinamicTextLabel.text = message
        self.showOptionalButton = showOptionalButton
        
        self.buildUI()
        self.buildConstraint()
        parentView?.dismissKeyboard()
        endEditing(true)
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController{
            rootViewController.view.endEditing(true)
            rootViewController.dismissKeyboard()
        }
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = BAZ_ColorManager.noneSpaceRW
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func buildUI(){
        if self.parentView != nil {
            self.parentView?.view.addSubview(self)
        }else if self.parentUIView != nil {
            self.parentUIView?.addSubview(self)
        }else {
            return
        }
        self.addSubview(contentView)
        contentView.addSubview(imageHeader)
        contentView.addSubview(imageFailure)
        contentView.addSubview(failedOperationLabel)
        contentView.addSubview(staticTextLabel)
        contentView.addSubview(acceptButton)
        contentView.addSubview(dinamicTextLabel)
    }
    
    
    fileprivate func buildConstraint(){
        /*guard let parentView = parentView?.view else {
            return
        }*/
        var auxParentView: UIView? = nil
        if self.parentView != nil {
            auxParentView = self.parentView?.view
        }else if self.parentUIView != nil {
            auxParentView = self.parentUIView
        }
        
        guard let parentView = auxParentView else{
            return
        }
        topAnchorCustom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        trailingAnchorCustom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        leadingAnchorCustom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        bottomAnchorCustom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        topAnchorCustom?.isActive = true
        trailingAnchorCustom?.isActive = true
        leadingAnchorCustom?.isActive = true
        bottomAnchorCustom?.isActive = true
        
        
        centerxAnchorCustom?.isActive = true
        
        NSLayoutConstraint.activate([
            
            ///ScrollView
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        
            //imageHeader
            imageHeader.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -30),
            imageHeader.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageHeader.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.4),
            imageHeader.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width + 30),

            //imageFailure
            imageFailure.topAnchor.constraint(equalTo: imageHeader.bottomAnchor, constant: 40),
            imageFailure.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageFailure.heightAnchor.constraint(equalToConstant: 96),
            imageFailure.widthAnchor.constraint(equalToConstant: 96),
            
            //failedOperationLabel
            failedOperationLabel.topAnchor.constraint(equalTo: imageFailure.bottomAnchor, constant: 30),
            failedOperationLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            //staticTextLabel
            staticTextLabel.topAnchor.constraint(equalTo: failedOperationLabel.bottomAnchor, constant: 36),
            staticTextLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            staticTextLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            
            dinamicTextLabel.topAnchor.constraint(equalTo: staticTextLabel.bottomAnchor, constant: 21),
            dinamicTextLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dinamicTextLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),

            //retryButton
            acceptButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80),
            acceptButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            acceptButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            acceptButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            acceptButton.heightAnchor.constraint(equalToConstant: 50),

        ])
    }
    
    @objc private func continueAction(_ sender: UIButton){
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0
        } completion: { completed in
            self.delegate?.alertSuccessConfirmed?()
            self.topAnchorCustom?.isActive = false
            self.trailingAnchorCustom?.isActive = false
            self.leadingAnchorCustom?.isActive = false
            self.bottomAnchorCustom?.isActive = false
            self.centerxAnchorCustom?.isActive = false
            self.removeFromSuperview()
        }
        
    }
}
