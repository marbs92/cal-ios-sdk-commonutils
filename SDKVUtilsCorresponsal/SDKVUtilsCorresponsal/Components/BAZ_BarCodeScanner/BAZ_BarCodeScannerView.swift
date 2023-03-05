//
//  BAZ_BarCodeScannerView.swift
//  baz-ios-akpago-utils
//
//  Created Jorge Cruz on 17/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

public enum BAZ_ScannBarCodeFromWhere {
    case PayCredit
    case ReferencedPayment
    case ServicesPayment
    
    public func getTitle() -> String {
        switch self {
        case .PayCredit:
            return "Pago de crédito"
        case .ReferencedPayment:
            return "Abono referenciado"
        case .ServicesPayment:
            return "Pago de servicios"
        }
    }
    
    public func getSubtitle() -> String {
        switch self {
        case .PayCredit:
            return "Ticket de pago"
        case .ReferencedPayment:
            return "Ticket de abono"
        case .ServicesPayment:
            return "Referencia de pago"
        }
    }
    
    public func getInstructions() -> String {
        switch self {
        case .PayCredit:
            return "Escanea el código de barras impreso en el ticket"
        case .ReferencedPayment:
            return "Escanea el código de barras impreso en el ticket"
        case .ServicesPayment:
            return "Escanea la referencia impreso en el recibo de pago"
        }
    }
}

public protocol BAZ_BarCodeScannerViewDelegate: class {
    func notifyCodeScanner(barcode: String)
}

/// BAZ_BarCodeScanner Module View
class BAZ_BarCodeScannerView: UIViewController {
    private var ui : BAZ_BarCodeScannerViewUI?
    public weak var delegate : BAZ_BarCodeScannerViewDelegate?
    internal var fromWhere: BAZ_ScannBarCodeFromWhere = .PayCredit
    
    override func loadView() {
        // setting the custom view as the view controller's view
        ui =  BAZ_BarCodeScannerViewUI(delegate: self,
                                       fromWhere: self.fromWhere)
        view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (ui?.captureSession?.isRunning == false) {
            ui?.captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (ui?.captureSession?.isRunning == true) {
            ui?.captureSession.stopRunning()
        }
    }
    
}

// MARK: - extending BAZ_BarCodeScannerView to implement the custom ui view delegate
extension BAZ_BarCodeScannerView: BAZ_BarCodeScannerViewUIDelegate {
    func notifySuccesfullScan(barcode: String) {
        delegate?.notifyCodeScanner(barcode: barcode)
    }
    
    func notifyDissmissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
