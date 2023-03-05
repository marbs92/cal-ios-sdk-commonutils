//
//  BAZ_AlertPrinterView.swift
//  baz-ios-akpago-utils
//
//  Created by Gustavo Tellez on 23/08/21.
//

import UIKit
import cal_ios_sdk_printer
import CoreBluetooth

internal class BAZ_AlertPrinterView: UIViewController {
    
    private let heigthScreen        :   CGFloat = UIScreen.main.bounds.height
    private var alertPrinterView    :   BAZ_AlertPrinterViewUI?
    private var printerIsShowing    :   Bool = false

    private var bluetoothManager    :   CBCentralManager?
    
    public var imgToPrint           :   UIImage?
    private var printersList        :   [UPOSPrinter] = []
    private let printerManager      =   BXL_PrinterManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeFlow))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        buildUI()
        registerObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func buildUI(){
        bluetoothManager = CBCentralManager(delegate: self, queue: nil)
        
        alertPrinterView = BAZ_AlertPrinterViewUI(delegate: self)
        self.view.addSubview(alertPrinterView!)
    }
    
    private func showAlertPrinterView(){
        printerIsShowing = true
        UIView.animate(withDuration: 0.5) {
            self.alertPrinterView?.frame.origin.y = self.heigthScreen - (self.alertPrinterView?.frame.height ?? 0.0)
        }
    }
    
    @objc func closeFlow(){
        printerIsShowing = false

        UIView.animate(withDuration: 0.5) {
            self.alertPrinterView?.frame.origin.y = self.heigthScreen
        } completion: { isFinish in
            if isFinish{
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    private func animateView(toShowing showView: Bool){
        printerIsShowing = showView
        var positionView = self.heigthScreen
        
        if showView{
            positionView = positionView - (self.alertPrinterView?.frame.height ?? 0.0)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.alertPrinterView?.frame.origin.y = positionView
            
        } completion: { isFinish in
            
            if isFinish && showView{
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    private func showErrorAlert(msg:  String){
        _ = BAZ_UpdatedAlertView(parent: self, delegate: nil, title: "Información", message: msg)
    }
    
    private func sendImageToPrint(showAlert: Bool = false){
        alertPrinterView?.updateContent(to: .printing, img: imgToPrint)

        if showAlert{
            showAlertPrinterView()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let printStatus = self.printerManager.printImage(self.imgToPrint!)
            
            if printStatus{
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.printersList.removeAll()
                    self.closeFlow()
                }

            }else{
                self.closeFlow()
                self.showErrorAlert(msg: "Error de conexión al momento de imprimir.")
            }
        }
    }
    
    private func connectWithPrinter(_ printer: UPOSPrinter, showAlert: Bool){
        printerManager.registerDevice(printer)
        
        if printerManager.deviceEnabled{
            self.sendImageToPrint(showAlert: showAlert)
        }else{
            if printerManager.connect(){
                self.sendImageToPrint(showAlert: showAlert)
            }else{
                showErrorAlert(msg: "Fallo la conexión con la impresora.")
            }
        }
    }
}

extension BAZ_AlertPrinterView : BAZ_AlertPrinterViewUIProtocol{
    
    func rechargePrinterList() {
        printersList.removeAll()
        printerManager.controller.refreshBTLookup()
    }
    
    func notifySelectedPrinter(printer: UPOSPrinter) {
        connectWithPrinter(printer, showAlert: false)
    }
    
    func notifyCloseAlert() {
        closeFlow()
    }
}

// Notification printer
extension BAZ_AlertPrinterView{
    
    func registerObservers(){
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: __NOTIFICATION_NAME_BT_FOUND_PRINTER_),
                               object: nil,
                               queue: OperationQueue.current)
        {
            [weak self] notification in
            guard let strongSelf = self else { return }
            
            if let userinfo = notification.userInfo {
                if let lookupDevice : UPOSPrinter = userinfo[__NOTIFICATION_NAME_BT_FOUND_PRINTER_] as? UPOSPrinter  {
                    strongSelf.printersList.append(lookupDevice)
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: __NOTIFICATION_NAME_BT_LOOKUP_COMPLETE_),
                                               object: nil,
                                               queue: OperationQueue.current)
        {
            [weak self] notification in
            guard let strongSelf = self else { return }
            
            if strongSelf.printersList.count > 0{
                strongSelf.connectWithPrinter(strongSelf.printersList[0], showAlert: true)
            }
        }
    }
}

extension BAZ_AlertPrinterView: CBCentralManagerDelegate{
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOn:
           
            
            if printerManager.connectedDevice != nil && printerManager.deviceEnabled{
                sendImageToPrint(showAlert: true)
            }else{
                printersList.removeAll()
                printerManager.controller.refreshBTLookup()
            }
            
        case .poweredOff:
            
            alertPrinterView?.updateContent(to: .disabledBluetooth)
        
        case .unauthorized:
            
            alertPrinterView?.updateContent(to: .disabledBluetooth)
            
        default:
            
            alertPrinterView?.updateContent(to: .disabledBluetooth)
        }
        
        if printerIsShowing == false && central.state != .poweredOn{
            showAlertPrinterView()
        }
    }
}

extension BAZ_AlertPrinterView : UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
}
