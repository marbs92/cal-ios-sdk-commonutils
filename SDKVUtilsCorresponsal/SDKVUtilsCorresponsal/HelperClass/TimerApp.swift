//
//  TimerApp.swift
//  AceptaPagoBaz
//
//  Created by David on 06/07/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation

public protocol TimerAppDelegate:class {
    func notifyOverTime()
}

open class TimerApp {
    private var timerToDetectInactivity: Timer?
    private var showScreenSaverInSeconds = TimeInterval(0)
    private var lastForeground: Double = 0
    public weak var delegate: TimerAppDelegate?
    
    public init(time: Int) {
        showScreenSaverInSeconds = TimeInterval(time)
    }
        
    // reset the timer because there was user event
    public func resetTimer() {
        
        
        
        invalidateTimer()

        setTimer()
    }
    
    public func invalidateTimer() {
        if let timerToDetectInactivity = timerToDetectInactivity {
            timerToDetectInactivity.invalidate()
        }
    }
    
    // For background
    func localTimerValidation() {
        if lastForeground + showScreenSaverInSeconds > Date().timeIntervalSince1970 {
            showScreenSaver()
        }
    }
    
    private func setTimer() {
        timerToDetectInactivity = Timer.scheduledTimer(
            timeInterval: showScreenSaverInSeconds,
            target: self,
            selector: #selector(showScreenSaver),
            userInfo: nil,
            repeats: false
        )
        lastForeground = Date().timeIntervalSince1970
    }

    
    @objc private func showScreenSaver() {
        printDebug("Excediste el tiempo de inactividad ...")
        delegate?.notifyOverTime()
//        DispatchQueue.main.async {
//            if let topVC = UIApplication.shared.topMostViewController(), topVC as? RequirementViewController == nil, topVC as? RequestViewController == nil {
//                let alertController = UIAlertController(title: "Información!", message: "¡Has excedido el tiempo de inactividad!", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "Aceptar", style: .default) { [weak self] (event) in
//                    AceptaPagosBaz.shared.toRootModule()
//                    self?.resetTimer()
//                }
//                alertController.addAction(okAction)
//                topVC.present(alertController, animated: true)
//            }
//        }

    }
    
}
