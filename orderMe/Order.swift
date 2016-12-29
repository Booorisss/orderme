//
//  Order.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 5/19/16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import ObjectMapper

class Order: Mappable {
    var id : Int?
    var place : Place?
    var idTable : Int?
    var bucket : [Dish:Int]?
    var comments : String?
    var nowDate : Date?
    
    required init?(map: Map) {
        
    }
    
    init(id: Int, place: Place, idTable: Int, bucket: [Dish : Int], comments: String, nowDate: Date){
        self.id = id
        self.place = place
        self.idTable = idTable
        self.bucket = bucket
        self.comments = comments
        self.nowDate = nowDate
        
    }
    
    // Mark : Mappable
    func mapping(map: Map) {
        id          <- map["id"]
        place       <- map["place"]
        idTable     <- map["idTable"]
        bucket      <- map["bucket"]
        comments    <- map["comments"]
        nowDate     <- map["nowDate"]
    }
}


// Mark : Equatable
extension Order : Equatable {
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
    }
}


// Mark : Hashable
extension Order : Hashable {
    var hashValue : Int {
        return self.id ?? -1
    }
}
