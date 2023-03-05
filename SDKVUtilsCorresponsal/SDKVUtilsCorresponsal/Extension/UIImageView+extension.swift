//
//  UIImageView+extension.swift
//  aceptapago-ios-sdk-utils
//
//  Created by Omar Becerra on 30/06/21.
//
import UIKit.UIImage

public extension UIImageView {
    /**
     Permite que un elemento imagen tenga el aspecto redondo como si fuera un avatar
     
      ```
      imageview.rounded(aspect: .scaleAspectFill)
      ```
     
     - Parameter aspect: contentMode.
     */
    func rounded(aspect:UIView.ContentMode = .scaleAspectFill) {
        self.contentMode = aspect
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    /**
     Permite que un elemento imagen tenga el aspecto con esquinas redondeadas.
     
      ```
      imageview.roundedCorner(aspect: .scaleAspectFill)
      ```
     
     - Parameter aspect: contentMode.
     */
    func roundedCorner(aspect:UIView.ContentMode = .scaleAspectFill) {
        self.contentMode = aspect
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.size.width / 3.0
        self.clipsToBounds = true
    }
    
    /**
     Permite asignar la imagen a partir de una URL dada
     
      ```
      imageview.loadFromURL("https://hola.com/asjdlasjd.jpg")
      ```
     
     - Parameter imageURL: URL de la imagen.
     */
    func loadFromURL(_ imageURL: String?) {
        if let imagen = imageURL, let escapedString = imagen.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: escapedString) {
            let request = URLRequest(url: url);
            let session = URLSession.shared
            let datatask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                DispatchQueue.main.async {
                    guard let nonNilData = data, let nonNilImage = UIImage(data: nonNilData) else {
                        self.image = UIImage(bazNamed: "cameraNo_image")
                        self.contentMode = .scaleAspectFit
                        return
                    }
                    self.image = nonNilImage
                }
            }
            datatask.resume()
        } else {
            DispatchQueue.main.async {
                self.image = UIImage(bazNamed: "cameraNo_image")
                self.contentMode = .scaleAspectFit
            }
        }
    }
}
