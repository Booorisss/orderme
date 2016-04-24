//
//  getCategoriesVC.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 03.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class getCategoriesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var categories : [Category] = []
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var sumLabel: UILabel!
    
    @IBOutlet weak var bucketButton: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    
    let bucket = Bucket.shareInstance
    let sTone = SingleTone.shareInstance
    override func viewDidLoad() {
        loadCategories()
        
        categoryTableView.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0)
        if categories.count == 0 {
            let cat = Category(id: 1, idPlace: 1, name: "Macaruns")
            categories.append(cat)
            
        }
        if let p = sTone.place {
        myImage.image = p.image
        }
        
        self.navigationController?.navigationBarHidden = true
        
        self.categoryTableView.dataSource = self
        
          // sumLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
          // bucketButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
    }
    override func viewWillAppear(animated: Bool) {
        sumLabel.text = bucket.allSum.description
    }
    
    
    func loadCategories() {
        let httpcon = HttpCon()
        
        
        httpcon.HTTPGet("\(myUrl)/getMenu?placeId=\(SingleTone.shareInstance.idPlace)&varCase=1") {
            (data: String, error: String?) -> Void in
            if error != nil {
                print("error in getting places ")
            } else {
                do {
                    //print(data)
                    do {
                        let newdata: NSData = data.dataUsingEncoding(NSUTF8StringEncoding)!
                        let json = try NSJSONSerialization.JSONObjectWithData(newdata, options: .AllowFragments)
                        self.categories = self.parseJson(json)
                        
                    } catch {
                        print(error)
                        
                    }
                    
                }
            }
        }
        NSThread.sleepForTimeInterval(0.3)
        
        
    }
    
    
    func parseJson(anyObj:AnyObject) -> Array<Category>{
        
        var list:Array<Category> = []
        
        if  anyObj is Array<AnyObject> {
            
            
            
            for json in anyObj as! Array<AnyObject>{
                
                let id  =  (json["id"]  as AnyObject? as? Int) ?? 0
                let idPlace = ((json)["idPlace"] as AnyObject? as? Int ) ?? 0
                let name = (json["name"] as AnyObject? as? String) ?? "" // to get rid of null
                let category = Category(id: id, idPlace: idPlace, name: name)
                
                list.append(category)
            }
            
        }
        
        
        return list
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell",forIndexPath: indexPath) as? CategoryCell {
            cell.categoryName.text = categories[indexPath.row].name
            cell.id = categories[indexPath.row].id
            
            //            cell.lastMsg.font = UIFont(name: "Arial", size: 15)
            cell.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as? CategoryCell
        if let Order = segue.destinationViewController as? MakeOrderVC {
            
            if let categoryNameText = cell!.categoryName.text {
                Order.categoryName = categoryNameText
                sTone.categoryId = cell!.id
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
            }
            
        }
        
    }

    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
