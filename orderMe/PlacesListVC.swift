//
//  PlacesList.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 29.03.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class PlacesList: UITableViewController {
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    var places = [Place]()
    var filteredPlaces = [Place]()
    
    let bucket = Bucket.shareInstance
    
    let sTone = SingleTone.shareInstance
    
    override func viewDidLoad() {
        getPlaces()
        
        // ----------
        if places.count == 0 {
            let place = Place()
            place.name = "The Burger"
            place.adress = "asda"
            place.id = 1
            place.phone = "230432402"
            places.append(place)
        }
        // ----------
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPlaces = places.filter { place in
            return place.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        bucket.myBucket = [:]
        bucket.allSum = 0
        sTone.tableID = -1
    }
    
    
    
    func getPlaces(){
        let httpcon = HttpCon()
        
        httpcon.HTTPGet("\(myUrl)/getplaces") {
            (data: String, error: String?) -> Void in
            if error != nil {
                print("error in getting places ")
            } else {
                do {
                    //print(data)
                    do {
                        let newdata: NSData = data.dataUsingEncoding(NSUTF8StringEncoding)!
                        let json = try NSJSONSerialization.JSONObjectWithData(newdata, options: .AllowFragments)
                        self.places = self.parseJson(json)
                        
                    } catch {
                        print(error)
                        
                    }
                    
                }
            }
        }
        NSThread.sleepForTimeInterval(0.3)
        
    }
    
    func parseJson(anyObj:AnyObject) -> Array<Place>{
        
        var list:Array<Place> = []
        
        if  anyObj is Array<AnyObject> {
            
            
            
            for json in anyObj as! Array<AnyObject>{
                let pl:Place = Place()
                
                pl.id  =  (json["id"]  as AnyObject? as? Int) ?? 0
                pl.name = (json["name"] as AnyObject? as? String) ?? "" // to get rid of null
                pl.adress = (json["adress"] as AnyObject? as? String) ?? ""
                pl.phone = (json["phone"] as AnyObject? as? String) ?? ""
                
                list.append(pl)
            }// for
            
        } // if
        
        
        return list
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredPlaces.count
        }
        return places.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell",forIndexPath: indexPath) as? PlaceCell {
            
            if searchController.active && searchController.searchBar.text != "" {
                cell.placeName.text = filteredPlaces[indexPath.row].name
                cell.id = filteredPlaces[indexPath.row].id
                cell.placeAdress.text = filteredPlaces[indexPath.row].adress
                cell.place = filteredPlaces[indexPath.row]
            }
            else{
                cell.placeName.text = places[indexPath.row].name
                cell.id = places[indexPath.row].id
                cell.placeAdress.text = places[indexPath.row].adress
                cell.place = places[indexPath.row]
            }
            //  cell.lastMsg.font = UIFont(name: "Arial", size: 15)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as? PlaceCell
        if let Twobut = segue.destinationViewController as? Buttons {
            Twobut.place = cell!.place
            sTone.idPlace = cell!.id
            
        }
        
    }
    
    
    
    
}

extension PlacesList: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
