//
//  TwoButtons.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 29.03.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class Buttons: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let sTone = SingleTone.shareInstance
    
    @IBOutlet weak var myTableView: UITableView!
    var place : Place!
    
    @IBOutlet weak var placeImage: UIImageView!
    
    var actions = []
    var photosOfAction = []
    
    
    
    override func viewDidLoad() {
        self.title = place.name
        let adress : String = place.adress
        let phoneNumber : String = place.phone
        actions = ["Определить столик","Меню", "Резерв стола", "Вызов официанта", phoneNumber, adress]
        photosOfAction = ["qrcode","list","folkandknife","Waiter","phone","adress"]
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.scrollEnabled = false
        
        placeImage.image = place.image
    
    }
    
    override func viewWillAppear(animated: Bool) {
    navigationController?.navigationBarHidden = true

        myTableView.reloadData()
        //        myTableView.estimatedRowHeight = myTableView.heightAnchor / 5
    }
    

    
    func callAWaiter() {
        // 1 - bring a menu
        // 2 - bring a check
        // 3 - clean the table
        // 4 - other
        // 5 - cancel
        
        let alertController = UIAlertController(title: "Официант уже идет к вам", message: "Пожалуйста, укажите с какой целью вы хотели бы позвать официанта", preferredStyle: .Alert)
        
        
        let menuAction = UIAlertAction(title: "Принесите меню", style: .Default) { (action:UIAlertAction!) in
            self.callWaiter(1)
        }
        let checkAction = UIAlertAction(title: "Принесите счет", style: .Default) { (action:UIAlertAction!) in
            self.callWaiter(2)
        }
        let cleanAction = UIAlertAction(title: "Уберите со стола", style: .Default) { (action:UIAlertAction!) in
            self.callWaiter(3)
        }
        let otherAction = UIAlertAction(title: "Другое", style: .Default) { (action:UIAlertAction!) in
            self.callWaiter(3)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .Default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(menuAction)
        alertController.addAction(checkAction)
        alertController.addAction(cleanAction)
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
        
        
        
    }
    
    
    
    
    
    func callWaiter(reason: Int) {
        let httpcon = HttpCon();
        
        
        let idPlace = sTone.idPlace
        
        httpcon.HTTPGet("\(myUrl)/callWaiter?id=\(idPlace)&idTable=\(sTone.tableID)&reason=\(reason)") {
            (data: String, error: String?) -> Void in
            if error != nil {
                print("error in callWaiter ")
            } else {
                print("callWaiter OK")
            }
        }
        // NSThread.sleepForTimeInterval(0.3)
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("actionCell",forIndexPath: indexPath) as? ActionCell {
            
            cell.actionName!.text = actions[indexPath.row] as? String
            let imageName : String = photosOfAction[indexPath.row] as! String
            cell.actionPhoto?.image = UIImage(named: imageName)
            
            if indexPath.row == 0 {
                if sTone.tableID != -1 {
                    //cell.actionName.textColor = UIColor.greenColor()
                    cell.actionName.text = "Стол номер " + sTone.tableID.description
                }
            }
            
            //  cell.lastMsg.font = UIFont(name: "Arial", size: 15)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if indexPath.row == 0 {
            //  DEVICE
              self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("getTable") as! GetTableIdVC, animated: true)
            
            // SIMULATOR
            //self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("simulatorTable") as! SimulatorTableId, animated: true)
            
            
        }
        else if indexPath.row == 1 {
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("getCatVC") as! getCategoriesVC, animated: true)
        }
            
        else if indexPath.row == 2 {
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("reserveVC") as! DateVC, animated: true)
        }
            
        else if indexPath.row == 3 {
            if sTone.tableID != -1 {
                callAWaiter()
            }
            else {
                let alertController = UIAlertController(title: "Выберете столик", message: "Считайте, пожалуйста, QR code на столе", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Считать QR код", style: .Default) { (action:UIAlertAction!) in
                    self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("getTable") as! GetTableIdVC, animated: true)
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion:nil)
            }
        }
            
        else if indexPath.row == 4 {
            let phoneNumber = actions[4] as! String
            let alertController = UIAlertController(title: "Позвонить в " + place.name, message: "Вы точно хотите позвонить на номер " + phoneNumber + "?", preferredStyle: .Alert)
            
            
            let okAction = UIAlertAction(title: "Позвонить", style: .Default) { (action:UIAlertAction!) in
                
                if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)") {
                    let application:UIApplication = UIApplication.sharedApplication()
                    if (application.canOpenURL(phoneCallURL)) {
                        application.openURL(phoneCallURL);
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Отменить", style: .Default) { (action:UIAlertAction!) in
                
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion:nil)
        }
        
    }
    

    @IBAction func backButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
