//
//  BucketVC.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 05.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit
import Foundation

class BucketVC : UIViewController, UITableViewDataSource, UITableViewDelegate, okAlertProtocol, MyCellProtocol, UITextViewDelegate, UIScrollViewDelegate {
    
    
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    
    @IBOutlet weak var commentText: UITextView!
    
    
    
    
    var bucket = Bucket.shareInstance
    let sTone = SingleTone.shareInstance
    
    var dishes : [Dish] = []
    var kol : [Int] = []
    
    var myOrder : Order!
    
    
    override func viewDidLoad() {
        makeBucket()
        commentText.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        myTableView.backgroundColor = UIColor.lightGray.withAlphaComponent(0)
        myTableView.dataSource = self
        commentText.delegate = self
        myTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bucket.myBucket.count
    }
    func makeBucket(){
        
        for (d , k) in bucket.myBucket {
            dishes.append(d)
            kol.append(k)
        }
        sumLabel.text = bucket.allSum.description
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "bucketCell",for: indexPath) as? BucketCell {
            cell.dishName.text = dishes[(indexPath as NSIndexPath).row].name
            cell.dishKol.text = kol[(indexPath as NSIndexPath).row].description
            let newPrice = dishes[(indexPath as NSIndexPath).row].price * kol[(indexPath as NSIndexPath).row]
            cell.onePrice.text = newPrice.description
            cell.dish = dishes[(indexPath as NSIndexPath).row]
            
            //  cell.lastMsg.font = UIFont(name: "Arial", size: 15)
            cell.cellDelegate = self
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        view.endEditing(true)
    }
    
    
    @IBAction func deleteAll(_ sender: AnyObject) {
        bucket.myBucket = [:]
        bucket.allSum = 0
        sumLabel.text = "0"
        commentText.text = ""
        myTableView.reloadData()
        
        
    }
    
    
    @IBAction func makeAnOrder(_ sender: AnyObject) {
        if sTone.tableID == -1 {
            let alertController = UIAlertController(title: "Выберите столик", message: "Пожалуйста, считайте QR код и программа определит за каким столом вы сидите", preferredStyle: .alert)
            
            
            let okAction = UIAlertAction(title: "Окей", style: .default) { (action:UIAlertAction!) in
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "getTable") as! GetTableIdVC, animated: true)
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:nil)
        }
        else {
            if bucket.myBucket.isEmpty {
                let alertController = UIAlertController(title: "Пустой заказ", message: "Вы не выбрали ничего из меню, попробуйте еще раз", preferredStyle: .alert)
                
                
                let okAction = UIAlertAction(title: "Окей", style: .default) { (action:UIAlertAction!) in
                }
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion:nil)
            }
            else {
                let httpcon = HttpCon()
                httpcon.okDelegate = self
                let order = Order()
                order.idPlace = sTone.place.id
                order.idTable = sTone.tableID
                order.sum = bucket.allSum
                order.placeName = SingleTone.shareInstance.place.name
                
                for( dish, kol) in bucket.myBucket {
                    if dish.id != -1{
                        order.bucket[dish.id.description] = kol;
                    }
                    else {
                        let categid = dish.idCategory * -1
                        order.bucket[categid.description] = kol;
                    }
                }
                
                if let comments = commentText.text {
                    if comments != "Дополнительные комментарии к заказу: " {
                        order.comments = comments
                    }
                }
                
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "yyyy/MM/dd-HH:mm"
                
                let Date = Foundation.Date()
                
                let nowDate = dateFormatter.string(from: Date)
                
                order.nowDate = nowDate
                
                let json = JSONSerializer.toJson(order)
                print(json)
                
                myOrder = order
                
                
                httpcon.post("\(myUrl)/makeorder", bodyData: json)
                
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func okAlert(){
        deleteAll(0 as AnyObject)
        let alertController = UIAlertController(title: "Заказ принят!", message: "Ваш заказ успешно отправлен на кухню", preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "Окей", style: .default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion:nil)
        
    
        let defaults = UserDefaults.standard
        
        let decoded  = defaults.object(forKey: "myOrders") as? Data ?? Data()
        var arrayOrders = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Order] ?? [Order]()
        
        for intnameDish in myOrder.bucket.keys {
            
            for dish in dishes {
                if dish.id == Int(intnameDish) {
                     let stringname = dish.name
                    myOrder.bucket[stringname] = myOrder.bucket[intnameDish]
                    myOrder.bucket.removeValue(forKey: intnameDish)
                }
            }
           
            
        }
        
        arrayOrders.append(myOrder)
        
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: arrayOrders)
        
        defaults.set(encodedData, forKey: "myOrders")
        defaults.synchronize()

    
    
    
    }
    func notOkAlert(){
        
        let alertController = UIAlertController(title: "Возникли некоторые проблемы!", message: "Проверьте, пожалуйста, интернет и попробуйте снова", preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "Окей", style: .default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let comments = commentText.text {
            if comments == "Дополнительные комментарии к заказу: " {
                 commentText.text = ""
            }
        }
     
    }
    
    
    func addDish(_ dish: Dish) {
        bucket.allSum += dish.price
        sumLabel.text = bucket.allSum.description
        //myTableView.reloadData()
        
    }
    func deleteDish(_ dish: Dish) {
        bucket.allSum -= dish.price
        sumLabel.text = bucket.allSum.description
        //myTableView.reloadData()
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gest(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
