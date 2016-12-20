//
//  Bucket.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 04.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import Foundation

class Bucket : NSObject {
    
    fileprivate override init(){}
    
    static let shareInstance = Bucket()
    
    var myBucket : [Dish : Int] = [:]
    
    
    var allSum = 0
    
    
    
}
