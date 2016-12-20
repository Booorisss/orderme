//
//  Menu.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 12/17/16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//


import ObjectMapper

class Menu: Mappable {
   
    var menu : [Category : [Dish]]?
 
    required init?(map: Map) {
        
    }
    
    init (menu : [Category : [Dish]]){
        self.menu = menu
        
    }
    
    // Mark : Mappable
    func mapping(map: Map) {
        menu  <- map["menu"]
    }
    
    
}
