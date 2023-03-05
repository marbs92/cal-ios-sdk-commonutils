//
//  BAZ_TextFieldView.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 13/04/21.
//

import UIKit
public extension NSMutableCharacterSet {
    func isCharInSet(char: Character) -> Bool {
        var found = true
        for ch in String(char).utf16 {
            if !characterIsMember(ch) { found = false }
        }
        return found
    }
}

open class BAZ_TextFieldView: BAZ_TextFieldGeneric {
    
    public var baz_form : BAZ_TextFieldNormalEntity?
    private var helperCircleView : BAZ_CircleHelperMessageView?
    private var heigth: Int = 0
    private lazy var containerView = UIView(frame: .zero)
    private var textFieldInputTopMargin: Float = 16
    private var isSecureTextEntry: Bool = false
    
    
    private var questionMarkColor: UIColor?
    private var questionMarkBackgroundColor: UIColor?
    private var questionFont: UIFont?
    private var withShadow: Bool?
    private var leftSpace: CGFloat?
    
    public lazy var placeHolderUp: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public lazy var textFieldInput: BAZ_TextField = {
        let textfield = BAZ_TextField(maxLength: 0)
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textfield.frame.height))
        textfield.leftViewMode = .always
        textfield.returnKeyType = .done
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var toggleSecureEntryButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        button.tintColor = .lightGray
        button.imageEdgeInsets  = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        button.setImage(UIImage(bazNamed: "accessibilityVisibilityOffIcon"), for: .normal)//UIImage(bazNamed: "accessibilityVisibilityOffIcon"), for: .normal)
        button.tintColor = BAZ_ColorManager.purpleToolBarRW
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.toggleSecureEntry), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public convenience init(
        baz_form: BAZ_TextFieldNormalEntity,
        textFieldInputHeight: Int = 38,
        tintColor: UIColor = BAZ_ColorManager.navyBlueDarkRW,
        backgrounColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        placeHolderFont: UIFont = .Poppins_Medium_16,
        inputFont: UIFont = .Poppins_Regular_16,
        inputFontColor: UIColor = .black,
        widthShadow: Bool = false,
        textFieldInputTopMargin: Float = 16,
        questionMarkColor: UIColor = BAZ_ColorManager.greenDarkRW,
        questionMarkBackgroundColor: UIColor = .white,
        questionFont: UIFont = .Poppins_Semibold_16,
        withShadow: Bool = true,
        leftSpace: CGFloat = 0) {
            self.init()
            self.baz_form = baz_form
            self.heigth = textFieldInputHeight
            self.questionMarkColor = questionMarkColor
            self.questionMarkBackgroundColor = questionMarkBackgroundColor
            self.questionFont = questionFont
            self.withShadow = withShadow
            self.leftSpace = leftSpace
            
            placeHolderUp.textColor = tintColor
            placeHolderUp.font = placeHolderFont
            
            self.textFieldInputTopMargin = textFieldInputTopMargin
            
            if let titleTop = baz_form.titleTop, !titleTop.isEmpty {
                placeHolderUp.text = titleTop
            } else if let decorativeTitleTop = baz_form.decorativeTitleTop, decorativeTitleTop.length > 0{
                placeHolderUp.attributedText = decorativeTitleTop
            } else if let placeHolder = baz_form.placeHolderText, !placeHolder.isEmpty, baz_form.showPlaceHolderOnTop ?? false {
                placeHolderUp.text = placeHolder
                placeHolderUp.alpha = 0
            } else {
                self.textFieldInputTopMargin = 0
            }
            
            textFieldInput.text = baz_form.getCurrentValue()
            textFieldInput.maxLength = baz_form.maxLenght ?? 0
            textFieldInput.font = inputFont
            textFieldInput.textColor = inputFontColor
            textFieldInput.__backgroundColor = backgrounColor
            textFieldInput.placeholder = baz_form.placeHolderText ?? ""
            
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
    
    public override func setErrorUI() {
        textFieldInput.layer.borderWidth = 2
        textFieldInput.layer.borderColor = UIColor.red.cgColor
    }
    
    public override func setSuccessUI() {
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
        return self.baz_form ?? BAZ_TextFieldNormalEntity(defaultKey: "dump")
    }
    
    
    fileprivate func buildUI(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        textFieldInput.isSecureTextEntry = baz_form?.withSecurityEntry ?? false
        textFieldInput.keyboardType = baz_form?.typeKeyBoard ?? .asciiCapable
        textFieldInput.delegate = self
        textFieldInput.addTarget(self, action: #selector(self.didTextChange(_:)), for: .editingChanged)
        
        // Only show toggle button when the UITextField is secure, the toggle button is meant be shown and the baz form rightEvent is nil
        if baz_form?.withSecurityEntry ?? false && baz_form?.showToggleSecureEntry ?? false && baz_form?.rightEvent == nil {
            NSLayoutConstraint.activate([
                self.toggleSecureEntryButton.widthAnchor.constraint(equalToConstant: 55),
                self.toggleSecureEntryButton.heightAnchor.constraint(equalToConstant: CGFloat(self.heigth))
            ])
            textFieldInput.rightView = self.toggleSecureEntryButton
            textFieldInput.rightViewMode = .always
        }else if baz_form?.rightEvent != nil{
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
        
        self.addSubview(containerView)
        
        containerView.addSubview(placeHolderUp)
        containerView.addSubview(textFieldInput)
        if(baz_form?.getWithHelper() == true){
            helperCircleView = BAZ_CircleHelperMessageView(withHelperView: UIView(frame: .zero),
                                                           questionMarkColor: self.questionMarkColor ??  UIColor(),
                                                           questionMarkBackgroundColor: self.questionMarkBackgroundColor ?? UIColor(),
                                                           questionFont: self.questionFont ?? UIFont(),
                                                           withShadow: self.withShadow ?? Bool())
            helperCircleView?.delegate = self
            helperCircleView?.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(helperCircleView!)
        }
    }
    
    fileprivate func buildConstraint(){
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            placeHolderUp.topAnchor.constraint(equalTo: containerView.topAnchor),
            placeHolderUp.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            
            textFieldInput.topAnchor.constraint(equalTo: placeHolderUp.bottomAnchor, constant: CGFloat(self.textFieldInputTopMargin)),
            textFieldInput.heightAnchor.constraint(equalToConstant: CGFloat(self.heigth)),
            textFieldInput.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: ((baz_form?.widthPercent)! / 100.0), constant: 0),
            textFieldInput.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            textFieldInput.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        if(baz_form?.getWithHelper() == true){
            NSLayoutConstraint.activate([
                helperCircleView!.leadingAnchor.constraint(equalTo: placeHolderUp.trailingAnchor, constant: self.leftSpace ?? 0),
                helperCircleView!.centerYAnchor.constraint(equalTo: placeHolderUp.centerYAnchor),
                helperCircleView!.widthAnchor.constraint(equalToConstant: 18),
                helperCircleView!.heightAnchor.constraint(equalToConstant: 18),
            ])
        }else{
            NSLayoutConstraint.activate([
                placeHolderUp.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            ])
        }
    }
    
    @objc private func didTextChange(_ sender: BAZ_TextField){
       
        baz_form?.setCurrentValue(value: sender.text ?? "")
        self.showPlaceholderOnTop()
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc private func rightViewAction(_ sender: UIButton){
        baz_form?.delegate?.notifyRightViewTap?(sender)
    }
    
    public func disableMode(){
        textFieldInput.isUserInteractionEnabled = false
        placeHolderUp.textColor = BAZ_ColorManager.navyBlueDarDissablekRW
        textFieldInput.textColor = BAZ_ColorManager.navyBlueDarDissablekRW
    }
    
    private func showPlaceholderOnTop(){
        if baz_form?.showPlaceHolderOnTop ?? false, (baz_form?.titleTop ?? "").isEmpty, !(baz_form?.placeHolderText ?? "").isEmpty {
            if let text = baz_form?.getCurrentValue() {
                UIView.animate(withDuration: 0.1) {
                    self.layoutIfNeeded()
                    self.placeHolderUp.alpha = text.isEmpty ? 0 : 1
                }
            }
        }
    }
    
    private func formattedByMask(text: String, maskToReplace: String, characterToReplace: Character) -> String {
        let letters = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = letters.startIndex
        for ch in maskToReplace where index < letters.endIndex {
            if ch == characterToReplace {
                result.append(letters[index])
                index = letters.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    @objc func toggleSecureEntry(){
        self.isSecureTextEntry = !self.isSecureTextEntry
        self.textFieldInput.isSecureTextEntry = self.isSecureTextEntry
        
        self.toggleSecureEntryButton.setImage(self.isSecureTextEntry == false ? UIImage(bazNamed: "accessibilityVisibilityIcon") : UIImage(bazNamed: "accessibilityVisibilityOffIcon"), for: .normal)
//        toggleSecureEntryButton.tintColor = .purple

    }
}


extension BAZ_TextFieldView : UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.baz_form?.delegate?.notifyDoneButtonTapped?(tag: textField.tag)
        endEditing(true)
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        switch baz_form?.withMask {
        case . PhoneLogin:
            textField.text = formattedByMask(text: newText, maskToReplace: "## #### ####", characterToReplace: "#")
            baz_form?.setCurrentValue(value: textField.text?.replacingOccurrences(of: "()", with: "").replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespaces) ?? "")
            break
        case .Phone:
            textField.text = formattedByMask(text: newText, maskToReplace: "(###) ### ####", characterToReplace: "#")
            baz_form?.setCurrentValue(value: textField.text?.replacingOccurrences(of: "()", with: "").replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespaces) ?? "")
            break
        case .VisaCardNumber:
            textField.text = formattedByMask(text: newText, maskToReplace: "#### - #### - #### - ####", characterToReplace: "#")
            baz_form?.setCurrentValue(value: textField.text?.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespaces) ?? "")
            break
        case .DDMMYYDate:
            textField.text = formattedByMask(text: newText, maskToReplace: "##/##/####", characterToReplace: "#")
            baz_form?.setCurrentValue(value: textField.text ?? "")
            break
        case .MMYYDate:
            if expirationCard(textField: textField, shouldChangeCharactersIn: range, replacementString: string.replacingOccurrences(of: " ", with: "")){
                textField.text = formattedByMask(text: newText, maskToReplace: "## / ##", characterToReplace: "#")
                baz_form?.setCurrentValue(value: textField.text ?? "")
            }
            break
        case .ClienteUniq:
            textField.text = formattedByMask(text: newText, maskToReplace: "## ## #### ##########", characterToReplace: "#")
            baz_form?.setCurrentValue(value: textField.text?.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespaces) ?? "")
            break
        case .Reference:
            if (string.range(of: ".*[A-Za-z0-9].*",options: .regularExpression) == nil) && string != ""{
                return false
            }
            textField.text = newText.replacingOccurrences(of: " ", with: "")
            baz_form?.setCurrentValue(value: textField.text ?? "")
            break
        default:
            if(baz_form?.inputValidation == BAZ_TextFieldTypeKeyboard.AlfaNumeric){
                if(string == " " && range.location == 0){
                    return false
                }else if(string != ""){
                    return string.range(of: ".*[A-Za-z0-9 ].*",options: .regularExpression) != nil
                }
            }else if(baz_form?.inputValidation == BAZ_TextFieldTypeKeyboard.Alfa){
                if(string == " " && range.location == 0){
                    return false
                }else if(string != ""){
                    return string.range(of: ".*[A-Za-z ].*",options: .regularExpression) != nil
                }
            } else if(baz_form?.inputValidation == BAZ_TextFieldTypeKeyboard.AlfaSpa){
                if(string == " " && range.location == 0){
                    return false
                }else if(string != ""){
                    return string.range(of: ".*[A-Za-z ñÑáéíóúÁÉÍÓÚüÜ].*",options: .regularExpression) != nil
                }
            }
            else if(baz_form?.inputValidation == BAZ_TextFieldTypeKeyboard.AlfaNumericSpa){
                if(string == " " && range.location == 0){
                    return false
                }else if(string != ""){
                    return string.range(of: ".*[A-Za-z0-9 ñÑáéíóúÁÉÍÓÚüÜ].*",options: .regularExpression) != nil
                }
            } else if(baz_form?.inputValidation == BAZ_TextFieldTypeKeyboard.UUID){
                if string != "" {
                    return string.range(of: ".*[A-Fa-f0-9-].*",options: .regularExpression) != nil
                }
            }
            break
        }
        self.showPlaceholderOnTop()
        return baz_form?.withMask != nil ? false : true
    }
    
    fileprivate func expirationCard(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)->Bool{
        guard let oldText = textField.text?.replacingOccurrences(of: " ", with: ""), let r = Range(range, in: oldText) else {
            return true
        }
        let updatedText = oldText.replacingCharacters(in: r, with: string)
        
        if string == "" {
            if updatedText.count == 2 {
                textField.text = "\(updatedText.prefix(1))"
                return false
            }
        } else if updatedText.count == 1 {
            if updatedText > "1" {
                return false
            }
        } else if updatedText.count == 2 {
            if updatedText <= "12" { //Prevent user to not enter month more than 12
                textField.text = "\(updatedText)/" //This will add "/" when user enters 2nd digit of month
            }
            return false
        } else if updatedText.count == 5 {
            self.expDateValidation(dateStr: updatedText)
        } else if updatedText.count > 5 {
            return false
        }
        return true
    }
    
    fileprivate func expDateValidation(dateStr:String) {
        
        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)
        
        let enteredYear = Int(dateStr.suffix(2)) ?? 0 // get last two digit from entered string as year
        let enteredMonth = Int(dateStr.prefix(2)) ?? 0 // get first two digit from entered string as month
        
        
        if enteredYear > currentYear {
            if (1 ... 12).contains(enteredMonth) {
                //"Entered Date Is Right"
            } else {
                //"Entered Date Is Wrong"
            }
        } else if currentYear == enteredYear {
            if enteredMonth >= currentMonth {
                if (1 ... 12).contains(enteredMonth) {
                    //"Entered Date Is Right"
                } else {
                    //"Entered Date Is Wrong"
                }
            } else {
                //"Entered Date Is Wrong"
            }
        } else {
            //"Entered Date Is Wrong"
        }
    }
    
}

extension BAZ_TextFieldView:BAZ_CircleHelperMessageViewDelegate{
    public func notifyTapHelperView() {
        guard let hcircle = helperCircleView else {
            return
        }
        baz_form?.setEventTap(objectToTap: hcircle)
    }
}
