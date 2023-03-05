//
//  BAZ_TextFieldsNip.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 13/04/21.
//

import UIKit


@objc public protocol BAZ_TextFieldsNipProtocol:class {
    @objc optional func responseInputText(componentText: String, tag : Int)
    @objc optional func notifyTextDidBegin(tag: Int)
    @objc optional func notifyTextDidEnd(tag: Int)
}

open class BAZ_TextFieldsNipView: UIView {
    var defaultBorderWidth: Float = 1
    var defaultBorderColor: UIColor = BAZ_ColorManager.borderColorRW
    
    lazy private var stackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints =   false
        return stackView
    }()
    lazy private var descriptionText: UILabel = {
        let label = UILabel(frame: .zero)
        label.isHidden = true
        label.textColor = .red
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.Poppins_Semibold_14
        label.text = "Código de confirmación incorrecto"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public var arrayInputs : [UITextField] = [UITextField]()
    private var numOfComponents: Int = 6
    private var maxNumOfComponents: Int = 6
    private var minNumOfComponents: Int = 4
    private var fontSize : Int = 30
    private var defaultHeight: Float = 0
    private var defaultWidth: Float = 0
    private var isWithSecurity : Bool = false
    private var isWithMaxSecurity : Bool = false
    private var isPasteActive : Bool = true
    private var hideDescriptionText: Bool = false
    public weak var delegate: BAZ_TextFieldsNipProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public convenience init(
        typeViewTextField: String = "",
        numOfComponents : Int,
        fontSize: Int = 30,
        defaultHeight: Float = 50,
        defaultWidth: Float = Float(UIScreen.main.bounds.width*(42.5/375)),
        isWithSecurity: Bool = false,
        isWithMaxSecurity: Bool = false,
        isPasteActive: Bool = true,
        defaultBorderWidth: Float = 1,
        defaultBorderColor: UIColor = BAZ_ColorManager.borderColorRW,
        hideDescriptionText: Bool = false) {
            self.init()
            self.defaultWidth = defaultWidth
            self.defaultHeight = defaultHeight
            self.isWithSecurity = isWithSecurity
            self.isWithMaxSecurity = isWithMaxSecurity
            self.isPasteActive = isPasteActive
            self.hideDescriptionText = hideDescriptionText

            if numOfComponents < self.minNumOfComponents {
                self.numOfComponents = self.minNumOfComponents
            } else if numOfComponents > self.maxNumOfComponents {
                self.numOfComponents = self.maxNumOfComponents
            } else {
                self.numOfComponents = numOfComponents
            }
            
            self.fontSize = fontSize
            self.defaultBorderWidth = defaultBorderWidth
            self.defaultBorderColor = defaultBorderColor
            self.buildTextField()
            self.setDefaultBorder()
        }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildTextField(){
        
        self.addSubview(stackViewContainer)
        self.addSubview(descriptionText)
        for i in 1...numOfComponents {
            let textFieldView : UIView = {
                let textFieldView =  UIView(frame: .zero)
                textFieldView.backgroundColor = .white
                textFieldView.layer.cornerRadius = 8
                textFieldView.layer.borderWidth = 1
                textFieldView.layer.borderColor = BAZ_ColorManager.borderColorRW.cgColor
                textFieldView.translatesAutoresizingMaskIntoConstraints = false
                
                let textField : UITextField = {
                    let textField = UITextField(frame: CGRect.zero)
                    textField.textColor = .black
                    textField.textAlignment = NSTextAlignment.center
                    textField.autocapitalizationType = .allCharacters
                    textField.tag = i
                    if isWithSecurity {
                        textField.addTarget(self, action: #selector(self.textFieldDidBegin(_:)), for: .editingDidBegin)
                        textField.addTarget(self, action: #selector(self.textFieldDidEnd(_:)), for: .editingDidEnd)
                    } else if isWithMaxSecurity {
                        textField.addTarget(self, action: #selector(self.textFieldDidBeginWithMaxSecurity(_:)), for: .editingDidBegin)
                    }
                    textField.delegate = self
                    textField.maxSize = 1
                    textField.font = UIFont.Poppins_Semibold_26
                    textField.keyboardType = .asciiCapableNumberPad
                    textField.autocorrectionType = .no
                    textField.translatesAutoresizingMaskIntoConstraints = false
                    return textField
                }()
                
                textFieldView.addSubview(textField)
                
                NSLayoutConstraint.activate([
                    textFieldView.widthAnchor.constraint(equalToConstant: CGFloat(self.defaultWidth)),
                    textFieldView.heightAnchor.constraint(equalToConstant: CGFloat(self.defaultHeight)),
                    textField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: 0),
                    textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 0),
                    textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: 0),
                    textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 0),
                ])
                arrayInputs.append(textField)
                return textFieldView
            }()
            stackViewContainer.addArrangedSubview(textFieldView)
        }
        
        var widthModifier = self.defaultWidth * Float(self.maxNumOfComponents - self.numOfComponents)
        widthModifier /= 2

        widthModifier = widthModifier < 20 ? 20 : widthModifier
        
        NSLayoutConstraint.activate([
            stackViewContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            // Se modificó
            stackViewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CGFloat(widthModifier)),
            stackViewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: CGFloat(-widthModifier)),
            stackViewContainer.heightAnchor.constraint(equalToConstant: 80),
            descriptionText.topAnchor.constraint(equalTo: stackViewContainer.bottomAnchor, constant: self.hideDescriptionText ? 0 : 10),
            descriptionText.leadingAnchor.constraint(equalTo: stackViewContainer.leadingAnchor),
            descriptionText.trailingAnchor.constraint(equalTo: stackViewContainer.trailingAnchor),
            descriptionText.heightAnchor.constraint(equalToConstant: self.hideDescriptionText ? 0 : 20),
            descriptionText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
        ])
    }
    
    @objc func textFieldDidBegin(_ textField: UITextField){
        for (i, _) in stackViewContainer.arrangedSubviews.enumerated(){
            (stackViewContainer.arrangedSubviews[i].subviews[0] as? UITextField)?.isSecureTextEntry = false
        }
        delegate?.notifyTextDidBegin?(tag: self.tag)
    }
    
    @objc func textFieldDidEnd(_ textField: UITextField){
        for (i, _) in stackViewContainer.arrangedSubviews.enumerated(){
            (stackViewContainer.arrangedSubviews[i].subviews[0] as? UITextField)?.isSecureTextEntry = true
        }
        delegate?.notifyTextDidEnd?(tag: self.tag)
    }
    
    @objc func textFieldDidBeginWithMaxSecurity(_ textField: UITextField){
        for (i, _) in stackViewContainer.arrangedSubviews.enumerated(){
            (stackViewContainer.arrangedSubviews[i].subviews[0] as? UITextField)?.isSecureTextEntry = true
        }
        delegate?.notifyTextDidBegin?(tag: self.tag)
    }
    
    private func buildInputText(){
        let allText = arrayInputs.map { (uITextField) -> String in
            return uITextField.text?.first?.lowercased() ?? ""
        }.joined()
        delegate?.responseInputText?(componentText: allText, tag: self.tag)
    }
    
    public func successUI(withText: String = "",
                          textColor: UIColor? = .black,
                          textFont: UIFont = .Poppins_Semibold_14,
                          textAlignment: NSTextAlignment = .left,
                          borderColor: UIColor? = nil,
                          borderWidth: CGFloat = 0){
        DispatchQueue.main.async {
            self.descriptionText.isHidden = withText.isEmpty
            self.descriptionText.text = withText
            self.descriptionText.textAlignment = textAlignment
            self.descriptionText.textColor = textColor
            self.descriptionText.font = textFont
            
            guard let color = borderColor else {
                self.setDefaultBorder()
                return
            }
            for (i, _) in self.stackViewContainer.arrangedSubviews.enumerated(){
                self.stackViewContainer.arrangedSubviews[i].layer.borderWidth = borderWidth
                self.stackViewContainer.arrangedSubviews[i].layer.borderColor = color.cgColor
            }
        }
    }
    
    public func failureUI(withText: String = "Código de confirmación incorrecto",
                          textColor: UIColor? = .red,
                          textFont: UIFont = .Poppins_Semibold_14,
                          textAlignment: NSTextAlignment = .left,
                          borderColor: UIColor = .red,
                          borderWidth: CGFloat = 2){
        DispatchQueue.main.async {
            self.descriptionText.isHidden = withText.isEmpty
            self.descriptionText.text = withText
            self.descriptionText.textAlignment = textAlignment
            self.descriptionText.textColor = textColor
            self.descriptionText.font = textFont
            
            for (i, _) in self.stackViewContainer.arrangedSubviews.enumerated(){
                self.stackViewContainer.arrangedSubviews[i].layer.borderWidth = borderWidth
                self.stackViewContainer.arrangedSubviews[i].layer.borderColor = borderColor.cgColor
            }
        }
    }
    
    public func setDefaultBorder(){
        self.descriptionText.isHidden = true
        
        for (i, _) in stackViewContainer.arrangedSubviews.enumerated(){
            stackViewContainer.arrangedSubviews[i].layer.borderWidth = CGFloat(self.defaultBorderWidth)
            stackViewContainer.arrangedSubviews[i].layer.borderColor = self.defaultBorderColor.cgColor
        }
    }
    
    public func resetNip(withFirstResponder: Bool = true){
        self.setDefaultBorder()
        self.descriptionText.isHidden = true
        for textField in self.arrayInputs {
            textField.text = ""
        }
        if withFirstResponder {
            self.arrayInputs[0].becomeFirstResponder()
        }
    }
}

extension BAZ_TextFieldsNipView: UITextFieldDelegate{
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.count == 6, self.isPasteActive == true  {
            
            if string.isEmpty{
                return true
            }
            
            if Int(string) == nil {
                return false
            }
            
            if string.count == 6 {
                arrayInputs[0].text = "\(string[0])"
                arrayInputs[1].text = "\(string[1])"
                arrayInputs[2].text = "\(string[2])"
                arrayInputs[3].text = "\(string[3])"
                arrayInputs[4].text = "\(string[4])"
                arrayInputs[5].text = "\(string[5])"
                self.arrayInputs[5].becomeFirstResponder()
                self.buildInputText()
            }
            
            
        } else {
            if(string != ""){
                arrayInputs[textField.tag - 1].text = string.first?.lowercased()
            }else if (string == ""){
                guard let nonNilText = arrayInputs[textField.tag - 1].text, !nonNilText.isEmpty else {
                    return false
                }
                arrayInputs[textField.tag - 1].text = String(nonNilText.dropLast())
            }
            if (textField.text?.count ?? 0) > 0 {
                if(textField.tag == arrayInputs.count){
                    arrayInputs[textField.tag-1].resignFirstResponder()
                }else{
                    arrayInputs[textField.tag].becomeFirstResponder()
                }
            }else{
                if(textField.tag != 1){
                    arrayInputs[textField.tag - 2].becomeFirstResponder()
                }
            }
        }
        self.buildInputText()
        return false
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Element {
        return self[index(startIndex, offsetBy: offset)]
    }
    subscript(_ range: Range<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence {
        return prefix(range.upperBound.advanced(by: 1))
    }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence {
        return prefix(range.upperBound)
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence {
        return suffix(Swift.max(0, count - range.lowerBound))
    }
}

extension LosslessStringConvertible {
    var string: String { return .init(self) }
}

extension BidirectionalCollection {
    subscript(safe offset: Int) -> Element? {
        guard !isEmpty, let i = index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex)) else { return nil }
        return self[i]
    }
}
