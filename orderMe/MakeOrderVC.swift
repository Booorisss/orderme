//
//  MakeOrderVC.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 02.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class MakeOrderVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MyCellProtocol, infoDish {
    
    @IBOutlet weak var orderTableView: UITableView!
    var menu : [Dish] = []
    @IBOutlet weak var sumLabel: UILabel!
    
    @IBOutlet weak var myImage: UIImageView!
    var categoryName = ""
    
    let bucket = Bucket.shareInstance
    let sTone = SingleTone.shareInstance
    
    override func viewDidLoad() {
        self.navigationController?.navigationBarHidden = true
        self.title = categoryName
        loadMenu()
        if let p = sTone.place {
            myImage.image = p.image
        }
        if menu.count == 0 {
            let dish = Dish(id: 1, idPlace: 1, idCategory: 1, name: "Chocolate Macarun", price: 30, description: "Best macarun in Kiev")
            menu.append(dish)
            let dish1 = Dish(id: 2, idPlace: 1, idCategory: 1, name: "Strawberry Macarun", price: 30, description: "Delicious macarun ")
            menu.append(dish1)
        }
        
        
        self.orderTableView.dataSource = self
        
        
    }
    override func viewWillAppear(animated: Bool) {
        sumLabel.text = bucket.allSum.description
        orderTableView.reloadData()
    }
    
    func loadMenu(){
        let httpcon = HttpCon()
        let catId = sTone.categoryId
        httpcon.HTTPGet("\(myUrl)/getMenu?placeId=\(SingleTone.shareInstance.idPlace)&varCase=2&categoryId=\(catId)") {
            (data: String, error: String?) -> Void in
            if error != nil {
                print("error in getting places ")
            } else {
                do {
                    // print(data)
                    do {
                        let newdata: NSData = data.dataUsingEncoding(NSUTF8StringEncoding)!
                        let json = try NSJSONSerialization.JSONObjectWithData(newdata, options: .AllowFragments)
                        self.menu = self.parseJson(json)
                        
                    } catch {
                        print(error)
                        
                    }
                    
                }
            }
        }
        NSThread.sleepForTimeInterval(0.3)
        
        
        
        
    }
    
    func parseJson(anyObj:AnyObject) -> Array<Dish>{
        
        var list:Array<Dish> = []
        
        if  anyObj is Array<AnyObject> {
            
            
            
            for json in anyObj as! Array<AnyObject>{
                
                let id  =  (json["id"]  as AnyObject? as? Int) ?? 0
                let idPlace = ((json)["idPlace"] as AnyObject? as? Int ) ?? 0
                let idCategory = ((json)["idCategory"] as AnyObject? as? Int ) ?? 0
                let name = (json["name"] as AnyObject? as? String) ?? "" // to get rid of null
                let price = ((json)["price"] as AnyObject? as? Int ) ?? 0
                let description = (json["description"] as AnyObject? as? String) ?? ""
                let dish = Dish(id: id, idPlace: idPlace, idCategory: idCategory,  name: name, price: price, description: description)
                
                list.append(dish)
            }
            
        }
        
        
        return list
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("dishCell",forIndexPath: indexPath) as? DishCell {
            cell.dishName.text = menu[indexPath.row].name
            cell.dish = menu[indexPath.row]
            cell.priceLabel.text = String(menu[indexPath.row].price)
            getNumberofItems(cell)
            cell.numberOfItemsLabel.text = cell.numberOfItems.description
            cell.cellDelegate = self
            cell.infoD = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    func getNumberofItems(myCell: UITableViewCell){
        if let cell = myCell as? DishCell {
            cell.numberOfItems = 0
            for d in bucket.myBucket.keys {
                if d.name == cell.dish.name{
                    cell.numberOfItems = bucket.myBucket[d]!
                    break
                }
            }
        }
    }
    func addDish(dish: Dish) {
        bucket.allSum += dish.price
        sumLabel.text = bucket.allSum.description
    }
    func deleteDish(dish: Dish) {
        bucket.allSum -= dish.price
        sumLabel.text = bucket.allSum.description
    }
    
    
    
    func showInfoDish(d: Dish) {
        let alertController = UIAlertController(title: "Информация о блюде", message: d.dishDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "окей", style: .Default) { (action:UIAlertAction!) in
           
        }
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    
    
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func gest(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
