//
//  Dish.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 02.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import ObjectMapper

class Dish : Mappable {
    
    var id : Int?
    var place : Place?
    var category: Category?
    var name : String?
    var price : Int?
    var dishDescription : String?
    
    
    required init?(map: Map) {
        
    }
    
    
    init ( id: Int , place : Place, category: Category,  name: String, price: Int, description: String, oneprice: Bool){
        self.id = id
        self.place = place
        self.category = category
        self.name = name
        self.price = price
        self.dishDescription = description
    }
  
    func mapping(map: Map) {
        id              <- map["id"]
        place           <- map["place"]
        category        <- map["category"]
        name            <- map["name"]
        price           <- map["price"]
        dishDescription <- map["dishDescription"]
        
    }
    
}

// Mark : Equatable

extension Dish : Equatable {
    static func == (lhs: Dish, rhs: Dish) -> Bool {
        return lhs.id == rhs.id
    }
}


// Mark : Hashable

extension Dish : Hashable {
    var hashValue : Int {
        return self.id ?? -1
    }
}

