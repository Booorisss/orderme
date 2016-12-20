//
//  MyOrdersController.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 6/4/16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class MyOrdersController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var orders : [Order]! = []
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    override func viewDidLoad() {
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(){
        orders = []
        let defaults = UserDefaults.standard
        let decoded  = defaults.object(forKey: "myOrders") as? Data ?? Data()
        let arrayOrders = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Order] ?? [Order]()
        
        
//        defaults.setObject(NSData(), forKey: "myOrders")
//        defaults.synchronize()
        
        
        orders = arrayOrders
        ordersTableView.reloadData()
    }
    
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return orders.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            if let cell = tableView.dequeueReusableCell(withIdentifier: "myOrderCell",for: indexPath) as? myOrderCell {
                let order = orders[orders.count - 1 - (indexPath as NSIndexPath).row]
                
                cell.placeNameLabel.text = order.placeName
                cell.dataLabel.text = order.nowDate
                cell.sumLabel.text = order.sum.description
                
                return cell
            }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let order = orders[orders.count - 1 - (indexPath as NSIndexPath).row]
        var message = ""

        for nameDish in order.bucket.keys{
          message = message + nameDish + "  x"  + order.bucket[nameDish]!.description + "\n"
        }
        
        
        let alertController = UIAlertController(title: "Информация о заказе", message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "Окей", style: .default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion:nil)
        
    
        
        
    }
    

    

}
