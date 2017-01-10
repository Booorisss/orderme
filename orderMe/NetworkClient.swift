//
//  NetworkClient.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 12/17/16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//


import Foundation
import Alamofire
import ObjectMapper
import AlamofireImage


let server_url : String = "http://46.101.233.207:80"
//let base_url: String = server_url

let base_url: String = "http://localhost:8080"


class NetworkClient {
    
    static let dateFormatter = DateFormatter() // for converting Dates to string
    
    // general request to the API, each function here will use this one
    static func send(api: String, method: HTTPMethod, parameters: Parameters?, token: String, completion: @escaping (_ result: String?, _ error: NSError?)->()) -> Void {
        
        let headers = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json",
            "Authorization": "Token " + token
        ]
        
        let url = (base_url + api) as URLConvertible
        
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseString { response in
                switch response.result {
                case .success:
                    completion(response.result.value, nil)
                case .failure(let error):
                    completion(nil, error as NSError?)
                }
        }
    }
    
    
    
    // getting the list of Places from API
    static func getPlaces(completion: @escaping (_ places: Array<Place>?, _ error : NSError?) -> () ) {
        
        
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            
            guard let placesJSON = response_result else {
                return
            }
            let places : [Place]? = Mapper<Place>().mapArray(JSONString: placesJSON)
            
            completion(places, nil)
        }
        
        send(api: "/places", method: .get, parameters: nil, token: "", completion: response_completion )
        
    }
    
    
    static func downloadImage(url : String, completion: @escaping (_ image: UIImage? , _ error: NSError?) -> () ) {
        Alamofire.request(url).responseImage { (response) -> Void in
            guard let image = response.result.value else {
                completion(nil, response.result.error as NSError?)
                return
            }
            completion(image, nil)
        }
    }
    
    static func callAWaiter( placeId : Int, idTable: Int, date: Date, reason: Int, completion: @escaping (_ success: Bool? , _ error: NSError?) -> () )  {
        
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            completion(true, nil)
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let nowDate = dateFormatter.string(from: date)
        
        
        let parameters = [
            "id" : placeId,
            "idTable" : idTable,
            "nowDate" : nowDate,
            "reason" : reason
            
            ] as [String : Any]
        
        send(api: "/callWaiter", method: .post, parameters: parameters, token: "", completion: response_completion)
        
    }
    
    
    // get a Menu
    static func getMenu(placeId: Int, completion: @escaping (_ menu: Menu?, _ error : NSError?) -> () ) {
        
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            
            guard let menuJson = response_result else {
                completion(nil, NSError())
                return
            }
            let menu : Menu? = Mapper<Menu>().map(JSONString: menuJson)
            
            guard let categories = menu?.categories,
                let dishes = menu?.dishes  else {
                    completion(nil, NSError())
                    return
            }
            
            var newDishes : [Dish] = []
            for dish in dishes {
                
                let categoryId = dish.category_id
                
                for category in categories {
                    if categoryId == category.id {
                        dish.category = category
                        newDishes.append(dish)
                    }
                }
            }
            menu?.dishes = newDishes
            completion(menu, nil)
            
        }
        
        send(api: "/menu/\(placeId)", method: .get, parameters: nil, token: "", completion: response_completion )
        
    }
    
    // make an order
    static func makeOrder(order: Order, completion: @escaping (_ successId: Int?, _ error : NSError?) -> () ) {
        
        
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            if let jsonOrder = response_result  {
                if let order = Order(JSONString: jsonOrder) {
                    if let id = order.id  {
                        completion(id, nil)
                        return
                    }
                }
            }
            completion(nil, NSError())
            return
        }
        
        // make new bucket from DishId - Amount
        guard let oldBucket = order.bucket  else { return }
        var newBucket : [String: Int] = [:]
        for (dish, amount) in oldBucket {
            guard let id = dish.id else { completion(nil, NSError())
                return }
            newBucket[String(id)] = amount
        }
        // make String Date
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let nowDate = dateFormatter.string(from: Date())
        
        guard let comments = order.comments,
            let id = order.place?.id      else {
                completion(nil, NSError())
                return
        }
        
        let parameters = ["place_id" : id,
                          "idtable" : SingleTone.shareInstance.tableID,
                          "bucket"  : newBucket,
                          "comments" : comments,
                          "created" : nowDate ] as [String : Any]
        
        send(api: "/menu/order", method: .post, parameters: parameters, token: "", completion: response_completion)
        
    }
    
    // make a Reservation
    static func makeReservation(reserve: Reserve, completion: @escaping (_ successId: Int?, _ error : NSError?) -> () ) {
        
        
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            if let jsonReserve = response_result  {
                if let reserve = Reserve(JSONString: jsonReserve) {
                    if let id = reserve.id  {
                        completion(id, nil)
                        return
                    }
                }
            }
            completion(nil, NSError())
            return
        }
        
        // make String Dates
        guard let dateForReservation = reserve.date,
            let id = reserve.place?.id,
            let phoneNumber = reserve.phoneNumber,
            let people = reserve.numberOfPeople else {
                completion(nil, NSError())
                return
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.string(from : dateForReservation)
        let nowDate = dateFormatter.string(from: Date())
        
        
        let parameters = ["place_id" : id,
                          "date"  : date,
                          "created" : nowDate,
                          "phonenumber" : phoneNumber,
                          "numberofpeople" : people
            ] as [String : Any]
        
        send(api: "/places/reserve", method: .post, parameters: parameters, token: "", completion: response_completion)
        
    }
    
}
