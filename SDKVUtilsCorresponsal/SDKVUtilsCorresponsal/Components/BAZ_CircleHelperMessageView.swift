//
//  BAZ_CircleHelperMessageView.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 23/04/21.
//

import UIKit

public protocol BAZ_CircleHelperMessageViewDelegate:class {
    func notifyTapHelperView()
}

open class BAZ_CircleHelperMessageView: UIView {
    public var isShowing = false
    public weak var delegate: BAZ_CircleHelperMessageViewDelegate?
    
    private var questionMarkColor: UIColor?
    private var questionFont: UIFont?
    private var withShadow: Bool?
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.attributedText = NSAttributedString(string: "?", attributes: [
            NSAttributedString.Key.font : questionFont,
            NSAttributedString.Key.foregroundColor : self.questionMarkColor
        ])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public convenience init(
        withHelperView: UIView,
        questionMarkColor: UIColor,
        questionMarkBackgroundColor: UIColor,
        questionFont: UIFont,
        withShadow: Bool) {
        self.init()
        self.questionMarkColor = questionMarkColor
        self.backgroundColor = questionMarkBackgroundColor
        self.questionFont = questionFont
        self.withShadow = withShadow
        buildUI()
        buildConstraint()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func buildUI(){
        layer.cornerRadius = 9
        layer.masksToBounds = false
        if self.withShadow == true {
        layer.shadowRadius = 7
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1221039245)
        }
        self.isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        addSubview(questionLabel)
        button.addTarget(self, action: #selector(self.tabOnView(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.widthAnchor.constraint(equalTo: self.widthAnchor,constant: 30),
            button.heightAnchor.constraint(equalTo: self.heightAnchor,constant: 30)
        ])
    }
    
    fileprivate func buildConstraint(){
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 25),
            widthAnchor.constraint(equalToConstant: 25),
            questionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            questionLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    @objc func tabOnView(_ sender: UIButton){
        isShowing = !isShowing
        delegate?.notifyTapHelperView()
    }
}
