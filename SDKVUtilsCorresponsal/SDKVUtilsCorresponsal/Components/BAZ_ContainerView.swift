//
//  BAZ_ContainerView.swift
//  GenericPrinter
//
//  Created by Gustavo Tellez on 24/08/21.
//

import UIKit

open class BAZ_ContainerView: UIView {
    
    private var childViewTag = 100
    
    public init(){
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required public init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    private func embedChildView(_ childView: UIView){
        childView.alpha = 1.0
        childView.tag = childViewTag
        childView.isUserInteractionEnabled = true
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(childView)
        self.sendSubviewToBack(childView)
        SetupChildViewConstraints(childView)
    }
    
    private func SetupChildViewConstraints(_ childView: UIView){
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: self.topAnchor),
            childView.leftAnchor.constraint(equalTo: self.leftAnchor),
            childView.rightAnchor.constraint(equalTo: self.rightAnchor),
            childView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func removeChildView(_ view: UIView, withDuration duration: Double){
        UIView.animate(withDuration: duration) {
            view.alpha = 0.0
        } completion: { (finish) in
            if finish{
                view.removeConstraints(view.constraints)
                view.removeFromSuperview()
            }
        }
    }
    
    public func embedView(_ view: UIView, withDuration duration: Double = 0.5){
        if let childView = self.viewWithTag(childViewTag){
            embedChildView(view)
            removeChildView(childView, withDuration: duration)
        }else{
            embedChildView(view)
        }
    }
    
    public func getChildView() -> UIView?{
        if let childView = self.viewWithTag(childViewTag){
            return childView
        }else{
            return nil
        }
    }
}
