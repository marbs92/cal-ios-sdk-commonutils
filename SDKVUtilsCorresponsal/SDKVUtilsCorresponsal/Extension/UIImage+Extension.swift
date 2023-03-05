//
//  UIImage+Extension.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 17/02/22.
//

import UIKit

public extension UIImage {
    
    func toBase64String(compress: Bool = true) -> String {
        return jpegData(compressionQuality: compress ? 0.5 : 1)?.base64EncodedString() ?? ""
    }
    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedTo1MB() -> UIImage? {
        guard let imageData = self.pngData() else { return nil }
        let megaByte = 1000.0
        
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / megaByte
        
        while imageSizeKB > megaByte {
            guard let resizedImage = resizingImage.resized(toWidth: 0.5),
                  let imageData = resizedImage.pngData() else { return nil }
            
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / megaByte
        }
        
        return resizingImage
    }
    
    func resize(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func compressToChars(maxChars: Int,
                         compressed: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let compression: CGFloat = 0.95
            var holderImage = self
            var complete = false
            while(!complete) {
                if let data = holderImage.jpegData(compressionQuality: 1.0) {
                    if data.base64EncodedString().count <= maxChars {
                        complete = true
                        compressed(holderImage)
                        return
                    }
                }
                guard let newImage = holderImage.resize(withPercentage: compression) else { break }
                holderImage = newImage
            }
            compressed(nil)
        }
    }
    
    func compress(to kb: Int, allowedMargin: CGFloat = 0) -> Data {
        let bytes = kb * 1024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        var complete = false
        while(!complete) {
            if let data = holderImage.jpegData(compressionQuality: 1.0) {
                let ratio = data.count / bytes
                if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                    complete = true
                    return data
                } else {
                    let multiplier:CGFloat = CGFloat((ratio / 5) + 1)
                    compression -= (step * multiplier)
                }
            }
            
            guard let newImage = holderImage.resize(withPercentage: compression) else { break }
            holderImage = newImage
        }
        return Data()
    }
    
    convenience init?(bazNamed: String) {
        self.init(named: bazNamed, in: Bundle.local_ak_utils, compatibleWith: nil)
    }
}
