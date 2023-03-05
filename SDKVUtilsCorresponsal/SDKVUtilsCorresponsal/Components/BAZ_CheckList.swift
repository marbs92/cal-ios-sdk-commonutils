//
//  BAZ_CheckList.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 12/11/21.
//

import UIKit
open class BAZ_CheckList: UIView {
    var uncheckedIcon: UIImage = UIImage()
    var checkedIcon: UIImage = UIImage()
    var checkListElements: [BAZ_CheckListElement] = []
    
    lazy var elementsStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 10
        return stack
    }()
    
    public convenience init(title: [String],
                            titleFont: UIFont = .Poppins_Regular_16,
                            titleFontColor: UIColor = BAZ_ColorManager.navyBlueDarkRW,
                            titleAlignment: NSTextAlignment = .left,
                            checkedIcon: UIImage = UIImage(bazNamed: "checkIcon") ?? UIImage(),
                            uncheckedIcon: UIImage = UIImage(bazNamed: "closeIcon") ?? UIImage(),
                            checkAll: Bool? = false,
                            stackSpacing: Float = 10){
        self.init()
        
        self.setUI()
        self.setConstraints()
        
        self.checkedIcon = checkedIcon
        self.uncheckedIcon = uncheckedIcon
        self.elementsStack.spacing = CGFloat(stackSpacing)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.addElementsToList(title: title,
                                   checkAll: checkAll,
                                   titleFont: titleFont,
                                   titleFontColor: titleFontColor,
                                   titleAlignment: titleAlignment)
        }
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        self.addSubview(self.elementsStack)
    }
    
    func setConstraints(){
        NSLayoutConstraint.activate([
            self.elementsStack.topAnchor.constraint(equalTo: self.topAnchor),
            self.elementsStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.elementsStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.elementsStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    public func addElementsToList(title: [String],
                                  checkAll: Bool? = false,
                                  titleFont: UIFont = .Poppins_Regular_16,
                                  titleFontColor: UIColor = BAZ_ColorManager.navyBlueDarkRW,
                                  titleAlignment: NSTextAlignment = .left){
        for elementTitle in title {
            self.addElementToList(title: elementTitle,
                                  titleFont: titleFont,
                                  titleFontColor: titleFontColor,
                                  titleAlignment: titleAlignment,
                                  checked: checkAll)
            /*let listElement = BAZ_CheckListElement(title: elementTitle,
                                                   titleFont: titleFont,
                                                   titleFontColor: titleFontColor,
                                                   titleAlignment: titleAlignment,
                                                   icon: checkAll ? self.checkedIcon : self.uncheckedIcon)
            listElement.translatesAutoresizingMaskIntoConstraints = false
            self.checkListElements.append(listElement)
            self.elementsStack.addArrangedSubview(listElement)*/
        }
    }
    
    public func addElementToList(title: String,
                                 titleFont: UIFont = .Poppins_Regular_16,
                                 titleFontColor: UIColor = BAZ_ColorManager.navyBlueDarkRW,
                                 titleAlignment: NSTextAlignment = .left,
                                 checkedIcon: UIImage = UIImage(bazNamed: "checkIcon") ?? UIImage(),
                                 uncheckedIcon: UIImage = UIImage(bazNamed: "closeIcon") ?? UIImage(),
                                 checked: Bool? = false){
        var icon = UIImage()
        checkedIcon.withTintColor(BAZ_ColorManager.greenDarkRW)
        uncheckedIcon.withTintColor(BAZ_ColorManager.redError)
        if let nonNilChecked = checked {
            icon = nonNilChecked ? checkedIcon : uncheckedIcon
        }
        let listElement = BAZ_CheckListElement(title: title,
                                               titleFont: titleFont,
                                               titleFontColor: titleFontColor,
                                               titleAlignment: titleAlignment,
                                               icon: icon)
        listElement.translatesAutoresizingMaskIntoConstraints = false
        self.checkListElements.append(listElement)
        self.elementsStack.addArrangedSubview(listElement)
        listElement.elementImage.tintColor = (checked ?? false) ? BAZ_ColorManager.greenDarkRW : BAZ_ColorManager.redError
    }
    
    public func setElementsCheckedStatus(checked: [Bool?]){
        for index in 0 ..< checked.count {
            self.setElementCheckedStatus(checked: checked[index], index: index)
        }
    }
    
    public func setElementCheckedStatus(checked: Bool?, index: Int){
        if index < self.checkListElements.count {
            var icon = UIImage()
            if let nonNilChecked = checked {
                icon = nonNilChecked ? self.checkedIcon : self.uncheckedIcon
            }
            self.checkListElements[index].elementIcon = icon
            self.checkListElements[index].cheked = checked != nil ? checked ?? false : false
            self.checkListElements[index].elementImage.tintColor = (checked ?? false) ? BAZ_ColorManager.greenDarkRW : BAZ_ColorManager.redError
        }else {
            //"El índice proporcionado excede el límite de los elementos en lista"
        }
    }
    
    public func allConditionsHaveMet() -> Bool {
        if self.checkListElements.isEmpty {
            return false
        }
        for listElement in self.checkListElements {
            if !listElement.cheked {
                return false
            }
        }
        
        return true
    }
    
    
    public func removeAllElements(){
        self.checkListElements.removeAll()
        self.elementsStack.removeAllArrangedSubviews()
    }
}


class BAZ_CheckListElement: UIView {
    public var cheked: Bool = false
    
    public var elementTitle: String = ""{
        didSet{
            self.elementLabel.text = elementTitle
        }
    }
    public var elementIcon: UIImage = UIImage(){
        didSet{
            self.elementImage.image = elementIcon
        }
    }
    
    private lazy var elementLabel: UILabel = {
        let label = UILabel()
        label.font = .Poppins_Regular_16
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal lazy var elementImage: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    public convenience init(title: String,
                            titleFont: UIFont,
                            titleFontColor: UIColor,
                            titleAlignment: NSTextAlignment = .left,
                            icon: UIImage){
        self.init()
        
        self.elementLabel.text = title
        self.elementImage.image = icon
        self.elementTitle = title
        self.elementIcon = icon
        
        self.elementLabel.font = titleFont
        self.elementLabel.textColor = titleFontColor
        self.elementLabel.textAlignment = titleAlignment
        
        self.setUI()
        self.setConstraints()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        self.backgroundColor = .clear
        self.addSubview(elementLabel)
        self.addSubview(elementImage)
    }
    
    func setConstraints(){
        NSLayoutConstraint.activate([
            elementLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            elementLabel.trailingAnchor.constraint(equalTo: elementImage.leadingAnchor, constant: -10),
            elementLabel.topAnchor.constraint(equalTo: self.topAnchor),
            elementLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            elementImage.topAnchor.constraint(equalTo: self.topAnchor),
            elementImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            elementImage.widthAnchor.constraint(equalToConstant: 25),
            elementImage.heightAnchor.constraint(equalToConstant: 45),
            elementImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
