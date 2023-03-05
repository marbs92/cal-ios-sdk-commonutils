//
//  BAZ_TextFieldDate.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 18/04/21.
//

import UIKit

open class BAZ_TextFieldDate: BAZ_TextFieldGeneric {
    
    public var baz_form : BAZ_TextFieldDateEntity?
    
    private var containerViewStack = UIStackView(frame: .zero)
    private var customPickerView = UIDatePicker()
    private var heigth: Int = 0
    private lazy var containerView = UIView(frame: .zero)
    
    private var textFieldInputTopMargin: Float = 16
    
    private lazy var placeHolderUp: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public lazy var textFieldInput: BAZ_TextField = {
        let textfield = BAZ_TextField(frame: .zero)
        textfield.layer.cornerRadius = 10
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textfield.frame.height))
        textfield.leftViewMode = .always
        textfield.returnKeyType = .done
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public convenience init(
        baz_form: BAZ_TextFieldDateEntity,
        textFieldInputHeight: Int = 38,
        tintColor: UIColor = BAZ_ColorManager.navyBlueDarkRW,
        backgrounColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        placeHolderFont: UIFont = .Poppins_Medium_16,
        inputFont: UIFont = .Poppins_Regular_16,
        inputFontColor: UIColor = .black,
        widthShadow: Bool = false,
        textFieldInputTopMargin: Float  = 16){
        self.init()
        self.baz_form = baz_form
        self.heigth = textFieldInputHeight
        placeHolderUp.textColor = tintColor
        placeHolderUp.font = placeHolderFont
        textFieldInput.__backgroundColor = backgrounColor
        textFieldInput.font = inputFont
        textFieldInput.textColor = inputFontColor
        textFieldInput.text = baz_form.getCurrentValue()
        baz_form.setCurrentValue(value:baz_form.getCurrentValue())
        self.textFieldInputTopMargin = textFieldInputTopMargin
            
        if(widthShadow){
            textFieldInput.layer.shadowRadius = 8
            textFieldInput.layer.shadowOffset =  CGSize(width: 0, height: 3)
            textFieldInput.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1221039245)
            textFieldInput.layer.shadowOpacity = 1
        }else{
            textFieldInput.layer.cornerRadius = 8
            textFieldInput.layer.borderColor = BAZ_ColorManager.borderColorRW.cgColor
            textFieldInput.layer.borderWidth = 1
        }
        buildUI()
        buildConstraint()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setErrorUI(){
        textFieldInput.layer.borderWidth = 2
        textFieldInput.layer.borderColor = UIColor.red.cgColor
    }
    
    public override func setSuccessUI(){
        textFieldInput.layer.borderWidth = 1
        textFieldInput.layer.borderColor = BAZ_ColorManager.borderColorRW.cgColor
    }
    
    public override func isRequired()->Bool {
        return self.baz_form?.isRequired ?? false
    }
    public override func hasErrorRequired(requiredErrorBorder: Bool = true) -> Int {
        if isRequired(){
            if textFieldInput.text == ""{
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
    
    public override func getBazForm() -> BAZ_TextFieldEntity {
        return self.baz_form ?? BAZ_TextFieldDateEntity(defaultKey: "dump", datePickerMode: .date)
    }
    
    fileprivate func buildUI(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100.0, height: 44.0))

        if #available(iOS 13.4, *) {
            customPickerView.preferredDatePickerStyle = .wheels
        } else {

        }
        if baz_form?.rightEvent != nil{
            baz_form!.rightEvent?.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            baz_form!.rightEvent?.contentMode = .scaleAspectFill
            NSLayoutConstraint.activate([
                baz_form!.rightEvent!.widthAnchor.constraint(equalToConstant: CGFloat(self.heigth)),
                baz_form!.rightEvent!.heightAnchor.constraint(equalToConstant: 30)
            ])
            baz_form?.rightEvent?.addTarget(self, action: #selector(self.rightViewAction(_:)), for: .touchUpInside)
            textFieldInput.rightView = baz_form?.rightEvent
            textFieldInput.rightViewMode = .always
        }
//        let botonAceptar = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.dismissDatePicker(_:)))
        let doneButton = UIBarButtonItem(title: "Continuar", style: UIBarButtonItem.Style.done, target: nil, action: #selector(self.dismissDatePicker(_:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        doneButton.tag = self.tag
        toolbar.setItems([spacer,doneButton], animated: true)
        customPickerView.tag = self.tag
        customPickerView.datePickerMode = baz_form?.datePickerMode ?? .date
        customPickerView.locale = .init(identifier: "es_MX")
        customPickerView.timeZone = .current
        customPickerView.minimumDate = baz_form?.minimumDate
        customPickerView.maximumDate = baz_form?.maximumDate
        textFieldInput.inputAccessoryView = toolbar
        textFieldInput.inputView = customPickerView
        textFieldInput.tag = self.tag
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
//        placeHolderUp.text = baz_form?.titleTop
        if let titleTop = baz_form?.titleTop, !titleTop.isEmpty {
            placeHolderUp.text = titleTop
        } else if let decorativeTitleTop = baz_form?.decorativeTitleTop, decorativeTitleTop.length > 0{
            placeHolderUp.attributedText = decorativeTitleTop
        }
        
        textFieldInput.delegate = self
        textFieldInput.addTarget(self, action: #selector(self.didTextChange(_:)), for: .editingChanged)
        self.addSubview(containerView)
        containerView.addSubview(placeHolderUp)
        containerView.addSubview(textFieldInput)
    }
    
    fileprivate func buildConstraint(){
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            placeHolderUp.topAnchor.constraint(equalTo: containerView.topAnchor),
            placeHolderUp.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            placeHolderUp.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            placeHolderUp.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            textFieldInput.topAnchor.constraint(equalTo: placeHolderUp.bottomAnchor, constant: CGFloat(self.textFieldInputTopMargin)),
            textFieldInput.leadingAnchor.constraint(equalTo: placeHolderUp.leadingAnchor),
            textFieldInput.trailingAnchor.constraint(equalTo: placeHolderUp.trailingAnchor),
            textFieldInput.heightAnchor.constraint(equalToConstant: CGFloat(self.heigth)),
            textFieldInput.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: ((baz_form?.widthPercent)! / 100.0), constant: 0),
            textFieldInput.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    public func disableMode(){
        textFieldInput.isUserInteractionEnabled = false
        placeHolderUp.textColor = BAZ_ColorManager.navyBlueDarDissablekRW
        textFieldInput.textColor = BAZ_ColorManager.navyBlueDarDissablekRW
    }
    @objc private func didTextChange(_ sender: BAZ_TextField){
        baz_form?.setCurrentValue(value: sender.text ?? "")
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc private func dismissDatePicker(_ sender: UIBarButtonItem){
        textFieldInput.text = customPickerView.date.dateToStringDayMonthYearD
        baz_form?.setCurrentValue(value: customPickerView.date.dateToStringDayMonthYearD)
        self.baz_form?.delegate?.notifyDoneButtonTapped?(tag: self.textFieldInput.tag)
        endEditing(true)
    }
    
    @objc private func rightViewAction(_ sender: UIButton){
        baz_form?.delegate?.notifyRightViewTap?(sender)
    }
}


extension BAZ_TextFieldDate : UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
