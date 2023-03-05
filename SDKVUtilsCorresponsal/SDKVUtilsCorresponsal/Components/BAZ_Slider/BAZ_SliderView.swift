//
//  BAZ_SliderView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 11/07/22.
//
import UIKit
public enum BAZ_SlideViewAmount{
    case Number
    case Amount
}

open class BAZ_SlideView: UIView{
    private var typeSlide = BAZ_SlideViewAmount.Number
    private lazy var titleName: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .Poppins_Medium_14
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        return label
    }()
    private lazy var slideComponent: BAZ_SliderComponent = {
        let slide = BAZ_SliderComponent()
        slide.translatesAutoresizingMaskIntoConstraints = false
        return slide
    }()
    private lazy var leadingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .Poppins_Medium_14
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.textAlignment = .left
        return label
    }()
    private lazy var trailingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .Poppins_Medium_14
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.textAlignment = .right
        return label
    }()
    
    public convenience init(title: String, startValueRange: Int, endValueRange: Int, step:Int, typeSlide: BAZ_SlideViewAmount) {
        self.init(frame: .zero)
        self.typeSlide = typeSlide
        slideComponent.maximumValue = Float(endValueRange)
        slideComponent.minimumValue = Float(startValueRange)
        slideComponent.step = step
        slideComponent.requiredFormatt = (typeSlide == .Amount)
        titleName.text = title
        leadingLabel.text = (typeSlide == .Amount) ? "\(Double(startValueRange).formatAsMoney())" : "\(startValueRange)"
        trailingLabel.text = (typeSlide == .Amount) ? "\(Double(endValueRange).formatAsMoney())" : "\(endValueRange)"
        setUI()
        setConstraints()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUI(){
        addSubview(titleName)
        addSubview(slideComponent)
        addSubview(leadingLabel)
        addSubview(trailingLabel)
    }
    
    fileprivate func setConstraints(){
        NSLayoutConstraint.activate([
            titleName.topAnchor.constraint(equalTo: topAnchor),
            titleName.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleName.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            slideComponent.topAnchor.constraint(equalTo: titleName.bottomAnchor, constant: 20),
            slideComponent.leadingAnchor.constraint(equalTo: leadingAnchor),
            slideComponent.trailingAnchor.constraint(equalTo: trailingAnchor),
            slideComponent.heightAnchor.constraint(equalToConstant: 15),
            
            leadingLabel.topAnchor.constraint(equalTo: slideComponent.bottomAnchor, constant: 5),
            leadingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            leadingLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            leadingLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            trailingLabel.topAnchor.constraint(equalTo: slideComponent.bottomAnchor, constant: 5),
            trailingLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            trailingLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            trailingLabel.bottomAnchor.constraint(equalTo: leadingLabel.bottomAnchor),
        ])
    }
}
