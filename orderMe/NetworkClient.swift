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


let server_url : String = "http://46.101.233.207:80/"
let base_url: String = server_url

//let base_url: String = "http://localhost:8080/"


class NetworkClient {
    
    
    static let dateFormatter = DateFormatter()
    
    
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
        
        send(api: "/getplaces", method: .get, parameters: nil, token: "", completion: response_completion )
        
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
    
    
    // getting a Menu - [ Category : [Dish] ]
    static func getMenu(placeId: Int, completion: @escaping (_ menu: Menu?, _ error : NSError?) -> () ) {
    
        func response_completion( _ response_result: String? , response_error: NSError? ) -> Void {
            if response_error != nil {
                completion(nil, response_error)
                return
            }
            
            guard let menuJson = response_result else {
                return
            }
            let menu : Menu? = Mapper<Menu>().map(JSONString: menuJson)
            
            completion(menu, nil)
            
            
        }
        
        send(api: "/getmenu?placeId=\(placeId)", method: .get, parameters: nil, token: "", completion: response_completion )
        
    }
    
    
}
