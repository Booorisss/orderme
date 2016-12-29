//
//  MyOrdersController.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 6/4/16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class MyOrdersController: UIViewController {
    
    var orders : [Order]?
    
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
        
        orders = arrayOrders
        ordersTableView.reloadData()
    }
}


// Mark : UITableViewDataSource
extension MyOrdersController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let orders = orders else { return 0 }
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let orders = orders else { return UITableViewCell() }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myOrderCell",for: indexPath) as? myOrderCell {
            
            // firstly, display last order
            let numbetOfOrder = orders.count - 1 - (indexPath as NSIndexPath).row
            // check the correctness of number of order
            guard numbetOfOrder < orders.count else { return UITableViewCell() }
            let order = orders[numbetOfOrder]
            
            cell.placeNameLabel.text = order.place?.name
            cell.dataLabel.text = order.nowDate?.description
            // sum of order
            var sum : Double = 0
            guard let bucket = order.bucket else { return UITableViewCell() }
            for (dish, amount) in bucket {
                guard let price = dish.price else { return UITableViewCell() }
                sum += price * Double(amount)
            }
            cell.sumLabel.text = sum.description
            return cell
        }
        
        return UITableViewCell()
    }
    
}

// Mark : UITableViewDelegate
extension MyOrdersController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let orders = orders else { return }
        // firstly, there ara last orders displayed
        let numbetOfOrder = orders.count - 1 - (indexPath as NSIndexPath).row
        // check the correctness of number of order
        guard numbetOfOrder < orders.count else { return  }
        
        let order = orders[numbetOfOrder]
        
        guard let bucket = order.bucket else { return }
        var message = ""
        for dish in bucket.keys {
            guard   let dishName = dish.name,
                let amount = bucket[dish] else { return }
            message = message + dishName + " - x"  + amount.description + "\n"
        }
        let alertController = UIAlertController(title: "Order", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
}
