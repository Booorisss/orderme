//
//  SingleTone.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 30.03.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//
//



import Foundation

let myLocalUrl = "http://localhost:8080"
let googleUrl = "http://iorder.appspot.com"

let myUrl = myLocalUrl


class SingleTone : NSObject {
    
    private override init(){}
    
    static let shareInstance = SingleTone()
    
    var idPlace = 0
    
    var categoryId = 0
    
    var tableID = -1
    
    
}
