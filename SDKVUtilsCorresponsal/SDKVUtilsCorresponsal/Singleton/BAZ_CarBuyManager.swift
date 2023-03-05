//
//  Product.swift
//  aceptapago-ios-sdk-utils
//
//  Created by Omar Becerra on 20/07/21.
//

import Foundation

open class BAZ_CarBuyManager{
    public static let shareManager = BAZ_CarBuyManager()
    private var productOnCard = [CarProduct]()
    
    public func getProductCard()->[CarProduct]{
        return productOnCard
    }
    
    public func getQuantity(product: CarProduct)->Int{
        return productOnCard.first(where: { $0.id == product.id})?.quantity ?? 0
    }
    
    public func addProduct(product: CarProduct){
        if productOnCard.contains(where: { prod in
            return prod.id == product.id
        }){
            for  (ind,prod) in productOnCard.enumerated(){
                if prod.id == product.id{
                    productOnCard[ind].quantity += 1
                }
            }
        }else{
            productOnCard.append(product)
            for  (ind,prod) in productOnCard.enumerated(){
                if prod.id == product.id{
                    productOnCard[ind].quantity += 1
                }
            }
        }
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierListeningProductCar"), object: nil)
    }
    
    public func reduceProduct(product: CarProduct){
        if productOnCard.contains(where: { prod in
            return prod.id == product.id
        }){
            for  (ind,prod) in productOnCard.enumerated(){
                if prod.id == product.id && prod.quantity > 1{
                    productOnCard[ind].quantity -= 1
                }else if prod.id == product.id && prod.quantity == 1{
                    productOnCard.remove(at: ind)
                    
                }
            }
        }
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierListeningProductCar"), object: nil)
    }
    
    public func removeProduct(product: CarProduct){
        productOnCard = productOnCard.filter({ prod in
            return prod.id != product.id
        })
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierListeningProductCar"), object: nil)
    }
    
    public func getTotal()->Double{
        return productOnCard.reduce(0.0) { partialResult, prod in
            return partialResult + (Double(prod.price)! * Double(prod.quantity))
        }
    }
    
    public func resetCar(){
        productOnCard.removeAll()
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierListeningProductCar"), object: nil)
    }
    
}

public struct CarProduct: Codable, Hashable {
    public let id: Int
    public let name: String
    public let description: String
    public var quantity: Int
    public let price: String
    public let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id",
             name = "nombre",
             quantity = "cantidad",
             price = "precio",
             imageURL = "urlImagen",
             description = "descripcion"
    }

    public init?(id: Int, name: String, description: String, quantity: Int, price: String, imageURL: String?) {        
        self.id = id
        self.name = name
        self.description = description
        self.quantity = quantity
        self.price = price
        self.imageURL = imageURL
    }
}
