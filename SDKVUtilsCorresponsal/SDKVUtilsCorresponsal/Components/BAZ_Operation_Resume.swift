//
//  BAZ_Operation_Resume.swift
//  baz-ios-akpago-utils
//
//  Created by Alfonso Mariano Hernandez Espinosa on 12/08/21.
//

import UIKit

public protocol BAZ_OperationResumeDelegate:class {
    func amountOnCambio(value: String)
}
 
open class BAZ_Operation_Resume : UIView{
    
    public weak var delegate : BAZ_OperationResumeDelegate?
    private var editeCents : Bool = false
    private lazy var containerMainFist: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelDio : UILabel = {
        let labelOne = UILabel()
        labelOne.translatesAutoresizingMaskIntoConstraints = false
        labelOne.font = .Poppins_Semibold_17
        labelOne.textColor = BAZ_ColorManager.navyBlueDarkRW
        labelOne.numberOfLines = 0
        labelOne.text = "Cantidad que entregó el cliente:"
        return labelOne
    }()
    
    private lazy var labelCobro : UILabel = {
        let labelCobro = UILabel()
        labelCobro.translatesAutoresizingMaskIntoConstraints = false
        labelCobro.font = .Poppins_Semibold_17
        labelCobro.textColor = BAZ_ColorManager.whiteNavBarBackground
        labelCobro.numberOfLines = 0
        labelCobro.text = "Cantidad a cobrar:"
        return labelCobro
    }()
    lazy var orLinesFirts: UIView = {
        let leftLine = UIView(frame: .zero)
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.backgroundColor = BAZ_ColorManager.dissableButtonRW
        view.addSubview(leftLine)
        NSLayoutConstraint.activate([
            leftLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            leftLine.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            view.heightAnchor.constraint(equalToConstant: 40)
        ])
        return view
    }()
    
    private lazy var containerMainSecond: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = BAZ_ColorManager.purpleToolBarRW
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var labelCambio : UILabel = {
        let labelCambio = UILabel()
        labelCambio.translatesAutoresizingMaskIntoConstraints = false
        labelCambio.font = .Poppins_Semibold_17
        labelCambio.textColor = BAZ_ColorManager.navyBlueDarkRW
        labelCambio.numberOfLines = 0
        labelCambio.text = "Entrega de cambio:"
        return labelCambio
    }()
    
    private lazy var amoutToDio: BAZ_AmountTextField = {
        let textField = BAZ_AmountTextField(
            color: BAZ_ColorManager.navyBlueDarkRW,
            font: .Poppins_Medium_34,
            maxWidth: (UIScreen.main.bounds.width - 40.0) * 0.5,
            numberOfDigits: 6,
            editCents: editeCents)
        textField.delegate = self
        return textField
    }()
    
    private lazy var orLinesSecond: UIView = {
        let leftLine = UIView(frame: .zero)
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.backgroundColor = BAZ_ColorManager.dissableButtonRW
        view.addSubview(leftLine)
        NSLayoutConstraint.activate([
            leftLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            leftLine.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            view.heightAnchor.constraint(equalToConstant: 40)
        ])
        return view
    }()
    
    private lazy var containerMainThird: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var amoutToCobro: BAZ_AmountTextField = {
        let textField = BAZ_AmountTextField(
            color: BAZ_ColorManager.whiteNavBarBackground,
            font: .Poppins_Medium_45,
            maxWidth: (UIScreen.main.bounds.width - 40.0) * 0.5,
            numberOfDigits: 6,
            editCents: false)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var amoutToCambio: BAZ_AmountTextField = {
        let textField = BAZ_AmountTextField(
            color: BAZ_ColorManager.navyBlueDarkRW,
            font: .Poppins_Medium_34,
            maxWidth: (UIScreen.main.bounds.width - 40.0) * 0.5,
            editCents: false)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    private lazy var orLinesThird: UIView = {
        let leftLine = UIView(frame: .zero)
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.backgroundColor = BAZ_ColorManager.dissableButtonRW
        view.addSubview(leftLine)
        NSLayoutConstraint.activate([
            leftLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            leftLine.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            view.heightAnchor.constraint(equalToConstant: 40)
        ])
        return view
    }()
    
    public init(amount: String, editCents : Bool = false){
        super.init(frame: CGRect.zero)
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.editeCents = editCents
        buildUI()
        buildConstraints()
        amoutToCobro.sendAmountToShow(text: amount)
        amoutToCambio.sendAmountToShow(text: "0.00")
        delegate?.amountOnCambio(value: "0.00")
       
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI(){
        self.addSubview(containerMainFist)
        self.addSubview(containerMainSecond)
        self.addSubview(containerMainThird)
        containerMainFist.addSubview(labelDio)
        containerMainFist.addSubview(amoutToDio)
        containerMainFist.addSubview(orLinesFirts)
        containerMainSecond.addSubview(labelCobro)
        containerMainSecond.addSubview(amoutToCobro)
        containerMainSecond.addSubview(orLinesSecond)
        containerMainThird.addSubview(labelCambio)
        containerMainThird.addSubview(amoutToCambio)
        containerMainThird.addSubview(orLinesThird)
    }
    
    private func buildConstraints(){
        NSLayoutConstraint.activate([
            containerMainFist.topAnchor.constraint(equalTo: topAnchor),
            containerMainFist.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerMainFist.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerMainFist.heightAnchor.constraint(equalToConstant: 110),
            
            labelDio.centerYAnchor.constraint(equalTo: containerMainFist.centerYAnchor),
            labelDio.leadingAnchor.constraint(equalTo: containerMainFist.leadingAnchor, constant: 30),
            labelDio.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            amoutToDio.centerYAnchor.constraint(equalTo: containerMainFist.centerYAnchor),
            amoutToDio.trailingAnchor.constraint(equalTo: containerMainFist.trailingAnchor, constant: -30),
            
            orLinesFirts.leadingAnchor.constraint(equalTo: containerMainFist.leadingAnchor),
            orLinesFirts.trailingAnchor.constraint(equalTo: containerMainFist.trailingAnchor),
            orLinesFirts.bottomAnchor.constraint(equalTo: containerMainFist.bottomAnchor),
            orLinesFirts.heightAnchor.constraint(equalToConstant: 1),
            
            containerMainSecond.topAnchor.constraint(equalTo: containerMainFist.bottomAnchor),
            containerMainSecond.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerMainSecond.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerMainSecond.heightAnchor.constraint(equalToConstant: 110),
            
            labelCobro.centerYAnchor.constraint(equalTo: containerMainSecond.centerYAnchor),
            labelCobro.leadingAnchor.constraint(equalTo: containerMainSecond.leadingAnchor, constant: 30),
            labelCobro.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            amoutToCobro.centerYAnchor.constraint(equalTo: containerMainSecond.centerYAnchor),
            amoutToCobro.trailingAnchor.constraint(equalTo: containerMainSecond.trailingAnchor, constant: -30),
            
            orLinesSecond.leadingAnchor.constraint(equalTo: containerMainSecond.leadingAnchor),
            orLinesSecond.trailingAnchor.constraint(equalTo: containerMainSecond.trailingAnchor),
            orLinesSecond.bottomAnchor.constraint(equalTo: containerMainSecond.bottomAnchor),
            orLinesSecond.heightAnchor.constraint(equalToConstant: 1),
            
            containerMainThird.topAnchor.constraint(equalTo: containerMainSecond.bottomAnchor),
            containerMainThird.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerMainThird.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerMainThird.heightAnchor.constraint(equalToConstant: 110),
            containerMainThird.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            labelCambio.centerYAnchor.constraint(equalTo: containerMainThird.centerYAnchor),
            labelCambio.leadingAnchor.constraint(equalTo: containerMainThird.leadingAnchor, constant: 30),
            labelCambio.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            amoutToCambio.centerYAnchor.constraint(equalTo: containerMainThird.centerYAnchor),
            amoutToCambio.trailingAnchor.constraint(equalTo: containerMainThird.trailingAnchor, constant: -30),
            
            orLinesThird.leadingAnchor.constraint(equalTo: containerMainThird.leadingAnchor),
            orLinesThird.trailingAnchor.constraint(equalTo: containerMainThird.trailingAnchor),
            orLinesThird.bottomAnchor.constraint(equalTo: containerMainThird.bottomAnchor),
            orLinesThird.heightAnchor.constraint(equalToConstant: 1),
        ])
        
    }
}

extension BAZ_Operation_Resume: BAZ_AmountTextFieldDelegate{
    public func finishedAmountEdition() { () }
    
    public func amountChanged() {
        let cambio = Double(amoutToDio.getAmount())! - Double(amoutToCobro.getAmount())!
        if cambio > 0{
            amoutToCambio.sendAmountToShow(text: String(cambio))
            delegate?.amountOnCambio(value: String(cambio))
        }else{
            amoutToCambio.sendAmountToShow(text: "0.00")
            delegate?.amountOnCambio(value: String(cambio))
        }
    }
}
