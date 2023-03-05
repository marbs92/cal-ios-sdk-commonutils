//
//  BAZ_QRGenerator.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 08/02/22.
//

import UIKit
import Darwin
import EFQRCode

public class BAZ_QRGenerator: NSObject {
    
    /**
     JSON Encoder class to convert a codable to data
     */
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    
    /// This function generates a QR from a codable object.
    ///
    /// - Parameter codableObject: Any object that conforms the codable protocol
    /// - Parameter backgroundColor: The color of the background of the QR Image
    /// - Parameter foregroundColor: The color of the foreground of the QR Image
    /// - Parameter waterMarkImage: A optional water mark image for the QR Code
    /// - Parameter completion: A closure completion for the generated QR
    public func generateQRFrom <ANYCODABLE: Codable> (codableObject: ANYCODABLE, backgroundColor: UIColor, foregroundColor: UIColor, waterMarkImage: UIImage?, waterMarkMode: EFWatermarkMode = .scaleAspectFit, icon: UIImage? = nil, completion: @escaping (_ qrImage: UIImage?) -> () ) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                
                let jsonData = try self.jsonEncoder.encode(codableObject.self)
                
                guard let dataString = String(data: jsonData, encoding: .utf8) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                let qrUImage = self.generateImageFrom(dataString: dataString,
                                                      backgroundColor: backgroundColor,
                                                      foregroundColor: foregroundColor,
                                                      waterMarkImage: waterMarkImage,
                                                      waterMarkMode: waterMarkMode,
                                                      icon: icon)
                
                DispatchQueue.main.async {
                    completion(qrUImage)
                }
                
            } catch {
                //"Error generating the QR: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
        }
    }
    
    /// This function generates a QR from a String.
    ///
    /// - Parameter stringData: A String that represents the data for the QR
    /// - Parameter backgroundColor: The color of the background of the QR Image
    /// - Parameter foregroundColor: The color of the foreground of the QR Image
    /// - Parameter waterMarkImage: A optional water mark image for the QR Code
    /// - Parameter completion: A closure completion for the generated QR
    public func generateQRFromString(stringData: String, backgroundColor: UIColor, foregroundColor: UIColor, waterMarkImage: UIImage?, waterMarkMode: EFWatermarkMode = .scaleAspectFit, icon: UIImage? = nil, completion: @escaping (_ qrImage: UIImage?) -> () ) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            let qrUImage = self.generateImageFrom(dataString: stringData,
                                                  backgroundColor: backgroundColor,
                                                  foregroundColor: foregroundColor,
                                                  waterMarkImage: waterMarkImage,
                                                  waterMarkMode: waterMarkMode,
                                                  icon: icon)
            DispatchQueue.main.async {
                completion(qrUImage)
            }
        }
    }
    
    
    /// This function generates a QR from a String.
    ///
    /// - Parameter dataString: A String that represents the data for the QR
    /// - Parameter backgroundColor: The color of the background of the QR Image
    /// - Parameter foregroundColor: The color of the foreground of the QR Image
    /// - Returns: A UIImage with the generated QR code
    private func generateImageFrom(dataString: String, backgroundColor: UIColor, foregroundColor: UIColor, waterMarkImage: UIImage?, waterMarkMode: EFWatermarkMode, icon: UIImage?) -> UIImage? {
        
        let waterMarkCgImage = waterMarkImage?.cgImage
        let iconCgImage = icon?.cgImage
        let iconSize = icon != nil ? EFIntSize(width: Int(icon?.size.width ?? 90), height: Int(icon?.size.height ?? 90)) : nil
        
        guard let qrCgImage = EFQRCode.generate(content: dataString,
                                                backgroundColor: backgroundColor.cgColor,
                                                foregroundColor: foregroundColor.cgColor,
                                                watermark: waterMarkCgImage,
                                                watermarkMode: waterMarkMode,
                                                icon: iconCgImage,
                                                iconSize: iconSize) else {
            return nil
        }
        
        let qrUImage = UIImage(cgImage: qrCgImage)
        
        return qrUImage
    }
}
