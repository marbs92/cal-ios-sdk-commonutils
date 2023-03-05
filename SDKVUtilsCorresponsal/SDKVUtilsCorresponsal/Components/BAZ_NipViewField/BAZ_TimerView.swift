//
//  BAZ_TimerView.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 13/04/21.
//

import UIKit

public protocol BAZ_TimerViewProtocol: class {
    func notifyRefreshCode()
    func notifyTimeOver()
}


open class BAZ_TimerView: UIView {
    
    weak var delegate : BAZ_TimerViewProtocol?
    public var timer : Timer?
    private var cooldown: Int?
    private var reduceCooldown : Int?
    private var startOnTypeText: String?
    
    lazy var containerDivider = UIView(frame: .zero)
    lazy var stackerContainer = UIStackView(frame: .zero)
    lazy var dividerView = UIView(frame: .zero)
    
    lazy var timerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Poppins_Regular_14
        label.textColor = BAZ_ColorManager.greenDarkRW
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var refreshCode: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .white
        button.setTitleColor(BAZ_ColorManager.greenDarkRW, for: .normal)
        button.setTitle("Reenviar código", for: .normal)
        button.titleLabel?.font = UIFont.Poppins_Regular_14
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public init(
        cooldown: Int,
        startOnTypeText: String) {
        self.cooldown = cooldown
        self.startOnTypeText = startOnTypeText
        self.reduceCooldown = cooldown
        super.init(frame: .zero)
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
        refreshCode.addTarget(self, action: #selector(self.resendCodeAction(_:)), for: .touchUpInside)
        containerDivider.translatesAutoresizingMaskIntoConstraints = false
        containerDivider.addSubview(dividerView)
        dividerView.backgroundColor = BAZ_ColorManager.greenDarkRW
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        stackerContainer.translatesAutoresizingMaskIntoConstraints = false
        stackerContainer.spacing = 10
        stackerContainer.axis = .horizontal
        stackerContainer.addArrangedSubview(timerLabel)
        stackerContainer.addArrangedSubview(containerDivider)
        stackerContainer.addArrangedSubview(refreshCode)
        self.addSubview(stackerContainer)
    }
    
    
    fileprivate func buildConstraint(){
        NSLayoutConstraint.activate([
            stackerContainer.topAnchor.constraint(equalTo: self.topAnchor),
            stackerContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackerContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dividerView.widthAnchor.constraint(equalToConstant: 2),
            dividerView.heightAnchor.constraint(equalToConstant: 25),
            dividerView.centerXAnchor.constraint(equalTo: containerDivider.centerXAnchor),
            dividerView.centerYAnchor.constraint(equalTo: containerDivider.centerYAnchor),
            
        ])
    }
    
    
    private func updateLabel(labelText: String){
        timerLabel.text = labelText
    }
    
    private func refreshTimerCode(){
        reduceCooldown = cooldown
        guard self.timer != nil else{
            startTimerCode()
            return
        }
    }
    
    public func stopTimerCode() {
        reduceCooldown = cooldown
        timer?.invalidate()
        timer = nil
        updateLabel(labelText: startOnTypeText ?? "5:00")
    }
    
    public func startTimerCode() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountDown(){
        let seg = (reduceCooldown ?? 0) % 60
        let min = (reduceCooldown ?? 0) / 60
        
        if (reduceCooldown ?? 0) > 0 {
            if seg > 9 {
                updateLabel(labelText: "\(min):\(seg)")
            } else {
                updateLabel(labelText: "\(min):0\(seg)")
            }
            reduceCooldown = (reduceCooldown ?? 0) - 1
        } else {
            delegate?.notifyTimeOver()
            reduceCooldown = cooldown
            updateLabel(labelText: "0:00")
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func resendCodeAction(_ sender: UIButton){
        refreshTimerCode()
        delegate?.notifyRefreshCode()
    }
    
    
}
