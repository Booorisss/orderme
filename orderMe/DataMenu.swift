////
////  DataMenu.swift
////  orderMe
////
////  Created by Boris Gurtovyy on 5/30/16.
////  Copyright © 2016 Boris Gurtovoy. All rights reserved.
////
//
//import UIKit
//
//class Menu : NSObject  {
//    
//    fileprivate override init(){}
//    
//    static let shareInstance = Menu()
//    
//    var json : Array<AnyObject>!
//    
//    var categories : [Category]! = []
//    var menu : [Category:[Dish]]! = [:]
//    
//    var loaded : downloadedProtocol?
//    
//    func makeData(){
//     
//        for object in json {
//            
//            let placeIdValidation = (object["idPlace"] as AnyObject? as? Int) ?? -1
//            SingleTone.shareInstance.placeIdValidation = placeIdValidation
//            
//            
//            let categoryObject = object["category"] as! [String : AnyObject?
//            
//            ]
//            
//            let id  =  (categoryObject["id"]  as AnyObject? as? Int) ?? 0
//            let idPlace = (categoryObject["place"]  as AnyObject? as? Int) ?? 0
//            let name = (categoryObject["name"]  as AnyObject? as? String) ?? ""
//            let oneprice = (categoryObject["oneprice"]  as AnyObject? as? Bool) ?? false
//            let price = (categoryObject["price"]  as AnyObject? as? Int) ?? 0
//            let category = Category(id: id, idPlace: idPlace, name: name, oneprice: oneprice, price: price)
//            
//            categories.append(category)
//        
//            
//            let dishesObject = object["dishes"] as! Array<AnyObject>
//            
//            var dishesArray : [Dish] = []
//            
//            for dishObject in dishesObject {
//                let id = (dishObject["id"] as AnyObject? as? Int) ?? 0
//                let idPlace = (dishObject["place"] as AnyObject? as? Int) ?? 0
//                let idCategory = (dishObject["category"] as AnyObject? as? Int) ?? 0
//                let name = (dishObject["name"] as AnyObject? as? String) ?? ""
//                let price = (dishObject["price"] as AnyObject? as? Int) ?? 0
//                let dishDescription = (dishObject["description"] as AnyObject? as? String) ?? ""
//                let dish = Dish(id: id, idPlace: idPlace, idCategory: idCategory, name: name, price: price, description: dishDescription, oneprice: oneprice)
//                dishesArray.append(dish)
//            }
//            
//            menu[category] = dishesArray
//            
//            loaded?.finished()
//         }
//        
//    }
//    func deleteMenu(){
//        categories = []
//        menu = [:]
//    }
//}
