//
//  BAZ_AlertTerminalView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez  on 06/11/21.
//

import UIKit

public enum BAZ_ParentFlowTerminal{
    case AceptaPago
    case Corresponsal
}

public enum BAZ_AlertTerminalStatus{
    case searching
    case connecting
    case selectingTerminal
    case FailedConnection
    case connected
}

public protocol BAZ_AlertTerminalViewDelegate: AnyObject{
    func sendTerminalSelected(_ terminal: String, position: Int)
    func retryConnection()
    func cancelConnection()
}

open class BAZ_AlertTerminalView: UIViewController {
    
    private lazy var alertTerminalView : BAZ_AlertTerminalViewUI = {
        let view = BAZ_AlertTerminalViewUI(parentFlow: self.parentFlow)
        return view
    }()
    
    public var parentFlow: BAZ_ParentFlowTerminal = .Corresponsal
    public weak var delegate : BAZ_AlertTerminalViewDelegate? 
    
    private let screen = UIScreen.main.bounds

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeFlow))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        buildUI()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlertView()
    }
    
    private func buildUI(){
        alertTerminalView.delegate = self.delegate
        self.view.addSubview(alertTerminalView)
    }
    
    @objc func closeFlow(){
        self.delegate?.cancelConnection()
    }
    
    private func showAlertView(){
        UIView.animate(withDuration: 0.5) {
            self.alertTerminalView.frame.origin.y = self.screen.height - self.alertTerminalView.frame.height
        }
    }
    
    public func hideAlertView(completionHandler: @escaping () -> Void){
        UIView.animate(withDuration: 0.5) {
            self.alertTerminalView.frame.origin.y = self.screen.height

        } completion: { isFinish in
            if isFinish{
                self.dismiss(animated: false) {
                    completionHandler()
                }
            }
        }
    }
    
    public func changeStatusTerminal(to status: BAZ_AlertTerminalStatus, terminal: String = "", terminalList: [String] = []){
        alertTerminalView.changeStatusTerminal(to: status, terminal: terminal, terminalList: terminalList)
    }
}

extension BAZ_AlertTerminalView : UIGestureRecognizerDelegate{
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
}
