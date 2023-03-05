//
//  BAZ_TextFieldOption.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 18/04/21.
//

import UIKit

open class BAZ_TextFieldOption: BAZ_TextFieldGeneric {
    
    public var baz_form : BAZ_TextFieldOptionEntity?
    private var containerViewStack = UIStackView(frame: .zero)
    private lazy var containerView = UIView(frame: .zero)
    private lazy var placeHolderUp: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Poppins_Regular_14
        label.numberOfLines = 0
        label.textColor = BAZ_ColorManager.greenDarkRW
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public convenience init(
        baz_form: BAZ_TextFieldOptionEntity) {
        self.init()
        self.baz_form = baz_form
        buildUI()
        buildConstraint()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setErrorUI(){
        containerViewStack.arrangedSubviews.first?.layer.borderWidth = 2
        containerViewStack.arrangedSubviews.first?.layer.borderColor = UIColor.red.cgColor
    }
    
    public override func setSuccessUI(){
        containerViewStack.arrangedSubviews.first?.layer.borderWidth = 0
        containerViewStack.arrangedSubviews.first?.layer.borderColor = nil
    }
    
    public override func isRequired()->Bool {
        return self.baz_form?.isRequired ?? false
    }
    
    public override func getBazForm() -> BAZ_TextFieldEntity {
        return self.baz_form ?? BAZ_TextFieldOptionEntity(defaultKey: "dump", models: [])
    }
    
    public override func hasErrorRequired(requiredErrorBorder: Bool = true) -> Int {
        if isRequired(){
            if getBazForm().getCurrentValue() == ""{
                if requiredErrorBorder{
                    setErrorUI()
                }
                return 1
            }else{
                if requiredErrorBorder{
                    setSuccessUI()
                }
                return 0
            }
        }
        if requiredErrorBorder{
            setSuccessUI()
        }
        return 0
    }
    
    fileprivate func buildUI(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        placeHolderUp.text = baz_form?.titleTop
        self.addSubview(containerView)
        containerView.addSubview(placeHolderUp)
        containerViewStack.axis = .horizontal
        containerViewStack.spacing = 20
        containerViewStack.distribution = .fillEqually
        containerViewStack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(containerViewStack)
        for (id, name) in (baz_form?.entities ?? []).enumerated(){
            
            let view = UIView(frame: .zero)
            
            view.tag = id
            view.layer.cornerRadius = 10
            view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
            button.isEnabled = true
            button.isUserInteractionEnabled = true
            button.addTarget(self, action: #selector(self.optionSelected(_:)), for: .touchUpInside)
            button.tag = id
            button.tintColor = .lightGray
            button.setImage(UIImage(bazNamed: "radioButtonUncheckIcon"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            let textFInput = UILabel(frame: .zero)
            textFInput.tag = id + 100
            textFInput.text = name
            textFInput.font = UIFont.Poppins_Regular_14
            textFInput.textColor = #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1)
            textFInput.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(button)
            view.addSubview(textFInput)
            
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 23),
                button.widthAnchor.constraint(equalToConstant: 23),
                button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
                
                textFInput.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 8),
                textFInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
                textFInput.topAnchor.constraint(equalTo: view.topAnchor),
                textFInput.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            containerViewStack.addArrangedSubview(view)
        }
        NSLayoutConstraint.activate([
            placeHolderUp.topAnchor.constraint(equalTo: containerView.topAnchor),
            placeHolderUp.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            placeHolderUp.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            placeHolderUp.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            containerViewStack.topAnchor.constraint(equalTo: placeHolderUp.bottomAnchor, constant: 5),
            containerViewStack.leadingAnchor.constraint(equalTo: placeHolderUp.leadingAnchor),
            containerViewStack.trailingAnchor.constraint(equalTo: placeHolderUp.trailingAnchor),
            containerViewStack.heightAnchor.constraint(equalToConstant: 38),
            containerViewStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    fileprivate func buildConstraint(){
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
        ])
    }
    
    @objc private func optionSelected(_ sender: UIButton){
        for element in containerViewStack.arrangedSubviews{
            if(sender.tag == element.tag){
                (element.subviews[0] as? UIButton)?.setImage(UIImage(bazNamed: "radioButtonCheckIcon"), for: .normal)
                (element.subviews[0] as? UIButton)?.tintColor = BAZ_ColorManager.greenDarkRW
            }else{
                (element.subviews[0] as? UIButton)?.setImage(UIImage(bazNamed: "radioButtonUncheckIcon"), for: .normal)
                (element.subviews[0] as? UIButton)?.tintColor = .lightGray
            }
        }
        baz_form?.setCurrentValue(value: (containerViewStack.arrangedSubviews[sender.tag].viewWithTag(sender.tag)?.subviews[1] as? UILabel)?.text ?? "")
        endEditing(true)
        
    }
    public func defaultSelectedOptionIndex(index: Int){
        if index >= baz_form?.entities?.count ?? -1 || index < 0 {
            
            return
        }
        var button: UIButton?
        button = UIButton(type: UIButton.ButtonType.system)
        button?.tag = index
        self.optionSelected(button ?? UIButton())
        button = nil
    }
}
