//
//  BAZ_TextFieldOption.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 20/04/21.
//

import UIKit

open class BAZ_TextFieldSelect<T:Codable>: BAZ_TextFieldGeneric,UIPickerViewDelegate, UIPickerViewDataSource {
    
    public var baz_form : BAZ_TextFieldSelectEntity<T>?
    public var selectedItems = UIPickerView()
    private var helperCircleView : BAZ_CircleHelperMessageView?
    private var heigth: Int = 0
    private var containerViewStack = UIStackView(frame: .zero)
    private lazy var containerView = UIView(frame: .zero)
    private var textFieldInputTopMargin: Float = 16
    
    private var questionMarkColor: UIColor?
    private var questionMarkBackgroundColor: UIColor?
    private var questionFont: UIFont?
    private var withShadow: Bool?
    
    private lazy var placeHolderUp: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
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
        baz_form: BAZ_TextFieldSelectEntity<T>,
        textFieldInputHeight: Int = 38,
        tintColor: UIColor = BAZ_ColorManager.navyBlueDarkRW,
        backgrounColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        placeHolderFont: UIFont = UIFont.Poppins_Medium_16,
        inputFont: UIFont = UIFont.Poppins_Medium_14,
        inputFontColor: UIColor = .black,
        widthShadow: Bool = false,
        textFieldInputTopMargin: Float,
        questionMarkColor: UIColor = BAZ_ColorManager.greenDarkRW,
        questionMarkBackgroundColor: UIColor = .white,
        questionFont: UIFont = .Poppins_Semibold_16,
        withShadow: Bool = true){
        self.init()
        self.baz_form = baz_form
        self.heigth = textFieldInputHeight
        placeHolderUp.textColor = tintColor
        placeHolderUp.font = placeHolderFont
        textFieldInput.__backgroundColor = backgrounColor
        textFieldInput.font = inputFont
        textFieldInput.textColor = inputFontColor
        self.textFieldInputTopMargin = textFieldInputTopMargin
        self.questionMarkColor = questionMarkColor
        self.questionMarkBackgroundColor = questionMarkBackgroundColor
        self.questionFont = questionFont
        self.withShadow = withShadow
        if(widthShadow){
            textFieldInput.layer.shadowRadius = 8
            textFieldInput.layer.shadowOffset =  CGSize(width: 0, height: 3)
            textFieldInput.layer.shadowColor = #colorLiteral(red: 0.05098039216, green: 0.2745098039, blue: 0.8352941176, alpha: 0.09793874172)
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
        return self.baz_form ?? BAZ_TextFieldSelectEntity(defaultKey: "dump", data: [])
    }
    
    public func setData(data: [T]){
        baz_form?.data = data
    }
    
    public func setDataTitle(data : [String]){
        baz_form?.dataTitle = data
    }

    
    lazy var arrowDownImage: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 14, height: 7))
        button.tintColor = .lightGray
        button.setImage(UIImage(bazNamed: "arrowDownIcon"), for: .normal)
        button.tintColor = BAZ_ColorManager.navyBlueDarkRW
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate func buildUI(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.arrowDownImage.widthAnchor.constraint(equalToConstant: 50),
            self.arrowDownImage.heightAnchor.constraint(equalToConstant: 24.5)
        ])
        textFieldInput.rightView = self.arrowDownImage
        textFieldInput.rightViewMode = .always
        
//        placeHolderUp.text = baz_form?.titleTop
        
        if let titleTop = baz_form?.titleTop, !titleTop.isEmpty {
            placeHolderUp.text = titleTop
        } else if let decorativeTitleTop = baz_form?.decorativeTitleTop, decorativeTitleTop.length > 0{
            placeHolderUp.attributedText = decorativeTitleTop
        }

        self.addSubview(containerView)
        containerView.addSubview(placeHolderUp)
        containerView.addSubview(textFieldInput)
        crearPromisseWithPicker(components: textFieldInput, pickers: selectedItems)
        if(baz_form?.getWithHelper() == true){
            helperCircleView = BAZ_CircleHelperMessageView(withHelperView: UIView(frame: .zero),
                                                           questionMarkColor: self.questionMarkColor ??  UIColor(),
                                                           questionMarkBackgroundColor: self.questionMarkBackgroundColor ?? UIColor(),
                                                           questionFont: self.questionFont ?? UIFont(),
                                                           withShadow: self.withShadow ?? Bool())
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
            textFieldInput.leadingAnchor.constraint(equalTo: placeHolderUp.leadingAnchor),
            textFieldInput.heightAnchor.constraint(equalToConstant: CGFloat(self.heigth)),
            textFieldInput.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: ((baz_form?.widthPercent)! / 100.0), constant: 0),
            textFieldInput.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        if(baz_form?.getWithHelper() == true){
            NSLayoutConstraint.activate([
                helperCircleView!.leadingAnchor.constraint(equalTo: placeHolderUp.trailingAnchor, constant: 10),
                helperCircleView!.topAnchor.constraint(equalTo: placeHolderUp.topAnchor),
                helperCircleView!.widthAnchor.constraint(equalToConstant: 18),
                helperCircleView!.heightAnchor.constraint(equalToConstant: 18),
            ])
        }else{
//            NSLayoutConstraint.activate([
//                placeHolderUp.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            ])
        }
    }
    
    func crearPromisseWithPicker(components: BAZ_TextField,pickers: UIPickerView) {
        
        pickers.delegate = self
        pickers.dataSource = self
        pickers.tag = 0
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100.0, height: 44.0))
//        let botonAceptar = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.dismissPicker(_:)))
        let doneButton = UIBarButtonItem(title: "Continuar", style: UIBarButtonItem.Style.done, target: nil, action: #selector(self.dismissPicker(_:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        doneButton.tag = 0
        toolbar.setItems([spacer,doneButton], animated: true)
        components.addTarget(self, action: #selector(self.onTapPicker), for: .editingDidBegin)
        components.inputAccessoryView = toolbar
        components.inputView = pickers
        components.tag = 0
    }
    
    @objc func dismissPicker(_ sender: UIBarButtonItem){
        if(textFieldInput.text == ""){
            if (baz_form?.data?.count ?? 0) > 0 {
                textFieldInput.text = baz_form?.dataTitle?[0]
                baz_form?.setCurrentGenericValue(value:  baz_form?.data?[0])
            }
        }
        self.baz_form?.delegate?.notifyDoneButtonTapped?(tag: self.textFieldInput.tag)
        self.endEditing(true)
    }
    
    @objc func onTapPicker(){
        baz_form?.setSelectTap()
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return baz_form?.data?.count ?? 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return baz_form?.dataTitle?[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (baz_form?.data?.count ?? 0) > 0 {
            textFieldInput.text = baz_form?.dataTitle?[row]
            baz_form?.setCurrentGenericValue(value: baz_form?.data?[row])
        }
    }
    
    public func resetData(){
        self.textFieldInput.text = ""
        self.setData(data: [])
        self.setDataTitle(data: [""])
        self.selectedItems.reloadAllComponents()
    }
}
