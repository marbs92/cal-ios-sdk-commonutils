//
//  BAZ_LotieContainer.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 04/08/21.
//

import UIKit
import Lottie

open class BAZ_LotieContainer: UIView {

    var lottieLoop: LottieLoopMode?
    
    lazy var lottiImageView: AnimationView = {
        let lottie = AnimationView(animation: Animation.named("lottie-tarjeta", bundle: Bundle.local_ak_utils, subdirectory: nil, animationCache: nil))
        lottie.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5 + 50)
        lottie.contentMode = .scaleAspectFill
        lottie.clipsToBounds = false
        lottie.backgroundBehavior = .pauseAndRestore
        lottie.loopMode = lottieLoop ?? LottieLoopMode.loop
        lottie.play()
        return lottie
    }()
    
    convenience init(animationLottie: String) {
        self.init()
    }
}
