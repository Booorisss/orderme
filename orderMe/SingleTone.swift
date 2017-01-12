//
//  SingleTone.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 30.03.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//
//

import Foundation

class SingleTone : NSObject {
    
    fileprivate override init(){}
    
    static let shareInstance = SingleTone()
    
    var allplaces : [Place]?
    var place : Place?
    
    var tableID = -1
   
    var placeIdValidation = -1
    
    var qrcodeWasDetected = false
    
    var user : User?

    // when QR code captures the Id, we want to understand which place is this id for
    func makePlace(_ id: Int){
        guard let places = allplaces else { return }
        for myplace in places {
            if myplace.id == id {
                place = myplace
                break
            }
        }
    }
}



