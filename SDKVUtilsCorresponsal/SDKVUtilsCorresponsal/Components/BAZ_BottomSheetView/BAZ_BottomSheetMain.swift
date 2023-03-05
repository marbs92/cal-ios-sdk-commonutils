//
//  BAZ_BottomSheetMain.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Fernando Sánchez Palma on 10/06/22.
//

import Foundation
import UIKit


internal class BAZ_BottomSheetMain{
    internal static func createModule(showCloseButton: Bool,
                                      cardViewHeightPercentaje: CGFloat,
                                      contentView: UIView,
                                      delegate: BAZ_BottomSheetDelegate?) -> BAZ_BottomSheetView {
        let viewController: BAZ_BottomSheetView? = BAZ_BottomSheetView()
        if let view = viewController {
            view.showCloseButton = showCloseButton
            view.cardViewHeightPercentaje = cardViewHeightPercentaje
            view.contentView = contentView
            view.delegate = delegate
            
            view.modalPresentationStyle = .overFullScreen
            
            return view
        }
        return BAZ_BottomSheetView()
    }
}
