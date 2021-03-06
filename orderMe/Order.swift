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
    var created : Date?
    var sum : Double?
    
    required init?(map: Map) {
        
    }
    
    init(id: Int, place: Place, idTable: Int, bucket: [Dish : Int], comments: String, created: Date, sum : Double){
        self.id = id
        self.place = place
        self.idTable = idTable
        self.bucket = bucket
        self.comments = comments
        self.created = created
        self.sum = sum
        
    }
    
    // Mark : Mappable
    func mapping(map: Map) {
        id          <- map["id"]
        place       <- (map["place_id"], PlaceIdJsonTransform())
        idTable     <- map["idtable"]
        bucket      <- map["bucket"]
        comments    <- map["comments"]
        created     <- (map["created"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))
        sum         <- map["sum"]
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
