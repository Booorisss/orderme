//
//  Category.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 03.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//
import ObjectMapper

class Category : Mappable {
    
    
    var id : Int?
    var place : Place?
    var name : String?
    
    required init?(map: Map) {
        
    }
    
    init ( id: Int , place : Place, name: String){
        self.id = id
        self.place = place
        self.name = name
        
    }
    
    // Mark : Mappable
    func mapping(map: Map) {
        id             <- map["id"]
        place          <- map["place"]
        name           <- map["name"]
        
        
    }
    
}

extension Category : Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Category : Hashable {
    var hashValue : Int {
        return self.id ?? -1
    }
}
