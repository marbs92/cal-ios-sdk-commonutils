//
//  BAZ_SliderComponent.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 11/07/22.
//

import UIKit
class BAZ_SliderComponent: UISlider {
    public var step: Int = 1
    public var requiredFormatt: Bool = false
    lazy var labelUpside: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .Poppins_Medium_12
        label.textColor = BAZ_ColorManager.grayDarkRW
        return label
    }()
    private let baseLayer = CALayer()
    private let trackLayer = CAGradientLayer()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }

    private func setup() {
        clear()
        createBaseLayer()
        createThumbImageView()
        configureTrackLayer()
        addUserInteractions()
        addLabelThumb()
    }

    private func clear() {
        tintColor = .clear
        maximumTrackTintColor = .clear
        backgroundColor = .clear
        thumbTintColor = .clear
        
    }

    private func createBaseLayer() {
        baseLayer.masksToBounds = true
        baseLayer.backgroundColor = UIColor(red: 230/255, green: 204/255, blue: 255/255, alpha: 1.0).cgColor
        baseLayer.frame = .init(x: 0, y: frame.height / 4, width: frame.width, height: frame.height / 2)
        baseLayer.cornerRadius = baseLayer.frame.height / 2
        layer.insertSublayer(baseLayer, at: 0)
        let slide = (frame.width) / 10
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = (frame.height / 2)
        shapeLayer.lineDashPattern = [2, NSNumber(floatLiteral: slide)]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: slide, y: (frame.height / 2)),
                                CGPoint(x: frame.width, y: (frame.height / 2))])
        
        shapeLayer.path = path
        layer.insertSublayer(shapeLayer, at: 1)
    }

    private func configureTrackLayer() {
        let firstColor = BAZ_ColorManager.purpleToolBarRW.cgColor
        trackLayer.colors = [firstColor, firstColor]
        trackLayer.startPoint = .init(x: 0, y: 0.5)
        trackLayer.endPoint = .init(x: 1, y: 0.5)
        trackLayer.frame = .init(x: 0, y: frame.height / 4, width: 0, height: frame.height / 2)
        trackLayer.cornerRadius = trackLayer.frame.height / 2
        layer.insertSublayer(trackLayer, at: 1)
    }

    private func addUserInteractions() {
        addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }

    @objc private func valueChanged(_ sender: BAZ_SliderComponent) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let thumbRectA = thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
        trackLayer.frame = .init(x: 0, y: frame.height / 4, width: thumbRectA.midX, height: frame.height / 2)
        let value = round(value / Float(step)) * Float(step)
        labelUpside.text = requiredFormatt == true ? Double(value).formatAsMoney() : "\(value)"
        sender.value = value
        CATransaction.commit()
    }

    private func createThumbImageView() {
        let thumbSize = 20
        let thumbView = BAZ_SliderThumbView(frame: .init(x: 0, y: 0, width: thumbSize, height: thumbSize))
        thumbView.layer.cornerRadius = CGFloat(thumbSize / 2)
        let thumbSnapshot = thumbView.snapshot
        setThumbImage(thumbSnapshot, for: .normal)
        setThumbImage(thumbSnapshot, for: .highlighted)
        setThumbImage(thumbSnapshot, for: .application)
        setThumbImage(thumbSnapshot, for: .disabled)
        setThumbImage(thumbSnapshot, for: .focused)
        setThumbImage(thumbSnapshot, for: .reserved)
        setThumbImage(thumbSnapshot, for: .selected)
    }
    
    private func addLabelThumb(){
        guard let handleView = subviews.last else{ return }
        handleView.addSubview(labelUpside)
        NSLayoutConstraint.activate([
            labelUpside.centerXAnchor.constraint(equalTo: handleView.centerXAnchor),
            labelUpside.bottomAnchor.constraint(equalTo: handleView.topAnchor, constant: -5)
        ])
    }
}


final class BAZ_SliderThumbView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = BAZ_ColorManager.purpleToolBarRW
        let middleView = UIView(frame: .init(x: frame.midX - 6, y: frame.midY - 6, width: 12, height: 12))
        middleView.backgroundColor = BAZ_ColorManager.purpleToolBarRW
        middleView.layer.cornerRadius = 6
        addSubview(middleView)
    }
}
