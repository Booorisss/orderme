//
//  Order.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 5/19/16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class Order: NSObject {
    var idPlace = 0
    var placeName = ""
    var sum = 0
    var idTable = 0
    var bucket : [String:Int] = [:]
    var comments = ""
    var nowDate = ""
    
    override init(){
        
    }
    
    init(idPlace: Int, placeName: String, sum: Int, idTable: Int, bucket: [String:Int], comments: String, nowDate: String){
        self.idPlace = idPlace
        self.placeName = placeName
        self.sum = sum
        self.idTable = idTable
        self.bucket = bucket
        self.comments = comments
        self.nowDate = nowDate
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let idPlace = aDecoder.decodeInteger(forKey: "idPlace")
        let placeName = aDecoder.decodeObject(forKey: "placeName") as! String
        let sum = aDecoder.decodeInteger(forKey: "sum")
        let idTable = aDecoder.decodeInteger(forKey: "idTable")
        let bucket = aDecoder.decodeObject(forKey: "bucket") as! [String:Int]
        let comments = aDecoder.decodeObject(forKey: "comments") as! String
        let nowDate = aDecoder.decodeObject(forKey: "nowDate") as! String
        
        self.init(idPlace: idPlace, placeName: placeName, sum: sum, idTable: idTable, bucket: bucket, comments: comments, nowDate: nowDate)
    }
    
    
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(idPlace, forKey: "idPlace")
        aCoder.encode(placeName, forKey: "placeName")
        aCoder.encode(sum, forKey: "sum")
        aCoder.encode(idTable, forKey: "idTable")
        aCoder.encode(bucket, forKey: "bucket")
        aCoder.encode(comments, forKey: "comments")
        aCoder.encode(nowDate, forKey: "nowDate")
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Order {
            return idPlace == object.idPlace && placeName == object.placeName && sum == object.sum && idTable == object.idTable && bucket == object.bucket && comments == object.comments && nowDate == object.comments
        }
        else {
            return false
        }
        
    }

    
    
    
    
    
    
}
