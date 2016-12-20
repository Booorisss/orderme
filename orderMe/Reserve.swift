//
//  Reserve.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 6/2/16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class Reserve : NSObject{
    var placeId = -1
    var placeName = ""
    var date = ""
    var nowDate = ""
    var phoneNumber = ""
    var numberOfPeople = ""
    var book = true
    
    init(placeId: Int, placeName :String, date: String, nowDate: String, phoneNumber: String, numberOfPeople: String, book: Bool){
        self.placeId = placeId
        self.placeName = placeName
        self.date = date
        self.nowDate = nowDate
        self.phoneNumber = phoneNumber
        self.numberOfPeople = numberOfPeople
        self.book = book
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let placeId = aDecoder.decodeInteger(forKey: "placeId")
        let placeName = aDecoder.decodeObject(forKey: "placeName") as! String
        let date = aDecoder.decodeObject(forKey: "date") as! String
        let nowDate = aDecoder.decodeObject(forKey: "nowDate") as! String
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        let numberOfPeople = aDecoder.decodeObject(forKey: "numberOfPeople") as! String
        let book = aDecoder.decodeObject(forKey: "book") as! Bool
        
        self.init(placeId: placeId, placeName:placeName, date: date,nowDate: nowDate, phoneNumber: phoneNumber, numberOfPeople: numberOfPeople, book: book)
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(placeId, forKey: "placeId")
        aCoder.encode(placeName, forKey: "placeName")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(nowDate, forKey: "nowDate")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(numberOfPeople, forKey: "numberOfPeople")
        aCoder.encode(book, forKey: "book")
    }
    
      override func isEqual(_ object: Any?) -> Bool {
         if let object = object as? Reserve {
            return placeId == object.placeId && placeName == object.placeName && date == object.date && nowDate == object.nowDate && phoneNumber == object.phoneNumber && numberOfPeople == object.numberOfPeople
        }
         else {
            return false
        }
        
    }
    
}
