//
//  Reserve.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 6/2/16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import ObjectMapper

class Reserve : Mappable{
    var id : Int?
    var place : Place?
    var date : Date?
    var created : Date?
    var phoneNumber : String?
    var numberOfPeople : Int?
    
    required init?(map: Map) {
        
    }
    
    init(id : Int, place: Place, date: Date, created: Date, phoneNumber: String, numberOfPeople: Int){
        self.id = id
        self.place = place
        self.date = date
        self.created = created
        self.phoneNumber = phoneNumber
        self.numberOfPeople = numberOfPeople
    }
    
    // Mark : Mappable
    func mapping(map: Map) {
        id              <- map["id"]
        place           <- (map["place_id"], PlaceIdJsonTransform())
        date            <- (map["date"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))
        created         <- (map["created"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))
        phoneNumber     <- map["phonenumber"]
        numberOfPeople  <- map["numberofpeople"]
    }
    
}

// Mark : Equatable

extension Reserve : Equatable {
    static func == (lhs: Reserve, rhs: Reserve) -> Bool {
        return lhs.id == rhs.id
    }
}


// Mark : Hashable

extension Reserve : Hashable {
    var hashValue : Int {
        return self.id ?? -1
    }
}
