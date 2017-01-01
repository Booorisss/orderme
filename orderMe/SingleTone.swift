//
//  SingleTone.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 30.03.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//
//
import Foundation

let localUrl = "http://localhost:8080"
let googleUrl = "http://orderme-1286.appspot.com"
let frankfurtUrl = "http://139.59.159.173:8080/OrderMe%5FV4/"

let myUrl =  frankfurtUrl


class SingleTone : NSObject {
    
    fileprivate override init(){}
    
    static let shareInstance = SingleTone()
    
    var allplaces : [Place] = []
    var place : Place?
    
    var tableID = -1
   
    var placeIdValidation = -1
    
    var qrcodeWasDetected = false
    
    var userId: String?
    var accessToken: String?
    
    
    // when QR code captures the Id, we want to understand which place is this id for
    func makePlace(_ id: Int){
        for myplace in allplaces {
            if myplace.id == id {
                place = myplace
                break
            }
        }
    }
    
    
    
    
    
}



