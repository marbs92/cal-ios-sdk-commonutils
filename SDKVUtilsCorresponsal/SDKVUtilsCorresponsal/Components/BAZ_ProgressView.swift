//
//  NavigationCustomView.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 05/04/21.
//

import UIKit

open class BAZ_ProgressView: UIProgressView {

    var progressValue : Float = 0.0
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.trackTintColor = #colorLiteral(red: 0.8784313725, green: 0.9843137255, blue: 0.5058823529, alpha: 1)
        self.progressTintColor = BAZ_ColorManager.greenDarkRW
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func loadingProgress(endPoint: Float){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.progressValue < endPoint {
                self.progressValue += 0.01
                self.progress = self.progressValue
                self.loadingProgress(endPoint: endPoint)
            }
        }
    }
    public func decreasingProgress(endPoint: Float){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.progressValue > endPoint {
                self.progressValue -= 0.01
                self.progress = self.progressValue
                self.decreasingProgress(endPoint: endPoint)
            }
        }
    }
}
