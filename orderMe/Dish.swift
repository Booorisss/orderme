//
//  Dish.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 02.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import Foundation

class Dish : NSObject {
    
    let id : Int
    let idPlace : Int
    let idCategory: Int
    let name : String
    let price : Int
    let dishDescription : String
    
    
    init ( id: Int , idPlace : Int, idCategory: Int,  name: String, price: Int, description: String){
        self.id = id
        self.idPlace = idPlace
        self.idCategory = idCategory
        self.name = name
        self.price = price
        self.dishDescription = description
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? Dish {
            return id == object.id && idPlace == object.idPlace && name == object.name && price == object.price && description == object.description
        } else {
            return false
        }
    }

    
    
}
