//
//  BucketVC.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 05.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit
import Foundation

class BucketVC : UIViewController, UITableViewDataSource, UITableViewDelegate, okAlertProtocol, MyCellProtocol, UITextViewDelegate {
    
    
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    
    @IBOutlet weak var commentText: UITextView!
    
    
    
    
    var bucket = Bucket.shareInstance
    let sTone = SingleTone.shareInstance
    
    var dishes : [Dish] = []
    var kol : [Int] = []
    
    
    override func viewDidLoad() {
        makeBucket()
        myTableView.dataSource = self
        commentText.delegate = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bucket.myBucket.count
    }
    func makeBucket(){
        
        for (d , k) in bucket.myBucket {
            dishes.append(d)
            kol.append(k)
        }
        sumLabel.text = bucket.allSum.description
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("bucketCell",forIndexPath: indexPath) as? BucketCell {
            cell.dishName.text = dishes[indexPath.row].name
            cell.dishKol.text = kol[indexPath.row].description
            let newPrice = dishes[indexPath.row].price * kol[indexPath.row]
            cell.onePrice.text = newPrice.description
            cell.dish = dishes[indexPath.row]
            
            //  cell.lastMsg.font = UIFont(name: "Arial", size: 15)
            cell.cellDelegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    @IBAction func deleteAll(sender: AnyObject) {
        bucket.myBucket = [:]
        bucket.allSum = 0
        sumLabel.text = "0"
        commentText.text = ""
        myTableView.reloadData()
        
    }
    
    
    @IBAction func makeAnOrder(sender: AnyObject) {
        if sTone.tableID == -1 {
            let alertController = UIAlertController(title: "Выберите столик", message: "Пожалуйста, считайте QR код и программа определит за каким столом вы сидите", preferredStyle: .Alert)
            
            
            let okAction = UIAlertAction(title: "Окей", style: .Default) { (action:UIAlertAction!) in
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("getTable") as! GetTableIdVC, animated: true)
            }
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion:nil)
        }
        else {
            if bucket.myBucket.isEmpty {
                let alertController = UIAlertController(title: "Пустой заказ", message: "Вы не выбрали ничего из меню, попробуйте еще раз", preferredStyle: .Alert)
                
                
                let okAction = UIAlertAction(title: "Окей", style: .Default) { (action:UIAlertAction!) in
                }
                alertController.addAction(okAction)
                
                self.presentViewController(alertController, animated: true, completion:nil)
            }
            else {
                let httpcon = HttpCon()
                httpcon.okDelegate = self
                var json = sTone.idPlace.description + "/" + sTone.tableID.description + "{"
                var flag = false
                for (dish, kol) in bucket.myBucket {
                    flag = true
                    json += dish.id.description + ":" + kol.description + ","
                }
                if !flag {
                    json = "{}"
                }
                else {
                    
                    json = json.substringToIndex(json.endIndex.predecessor())
                    json += "}"
                    
                }
                
                if let comments = commentText.text {
                    if comments != "Дополнительные комментарии к заказу: " {
                        json += comments
                    }
                }
                
                print(json)
                
                httpcon.post("\(myUrl)/makeorder", bodyData: json)
                deleteAll(sender)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        super.touchesBegan(touches, withEvent: event)
        view.endEditing(true)
    }
    
    func okAlert(){
        
        let alertController = UIAlertController(title: "Заказ принят!", message: "Ваш заказ успешно отправлен на кухню", preferredStyle: .Alert)
        
        
        let okAction = UIAlertAction(title: "Окей", style: .Default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
        
    }
    func notOkAlert(){
        
        let alertController = UIAlertController(title: "Возникли некоторые проблемы!", message: "Проверьте, пожалуйста, интернет и попробуйте снова", preferredStyle: .Alert)
        
        
        let okAction = UIAlertAction(title: "Окей", style: .Default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
        
    }
    func textViewDidBeginEditing(textView: UITextView) {
        commentText.text = ""
    }
    
    
    func addDish(dish: Dish) {
        bucket.allSum += dish.price
        sumLabel.text = bucket.allSum.description
        //myTableView.reloadData()
        
    }
    func deleteDish(dish: Dish) {
        bucket.allSum -= dish.price
        sumLabel.text = bucket.allSum.description
        //myTableView.reloadData()
    }
    
}
