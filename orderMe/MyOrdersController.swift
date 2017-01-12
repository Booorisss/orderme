//
//  MyOrdersController.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 6/4/16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class MyOrdersController: UIViewController {
    
    var orders : [Order] = []
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    override func viewDidLoad() {
        ordersTableView.dataSource = self
        loadData()
    }
    
    func loadData(){
        NetworkClient.getOrders { (orders, error) in
            if error != nil {
                return
            }
            if let myOrders = orders {
                self.orders = myOrders
                self.ordersTableView.reloadData()
            }
        }
        ordersTableView.reloadData()
    }
}


// Mark : UITableViewDataSource
extension MyOrdersController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myOrderCell",for: indexPath) as? myOrderCell {
            
            // firstly, display last order
            let numbetOfOrder = orders.count - 1 - (indexPath as NSIndexPath).row
            // check the correctness of number of order
            guard numbetOfOrder < orders.count else { return UITableViewCell() }
            let order = orders[numbetOfOrder]
            
            cell.placeNameLabel.text = order.place?.name
            guard let orderCreated = order.created,
                  let orderSum = order.sum  else { return UITableViewCell() }
            cell.dataLabel.text = orderCreated.makeDateRepresentation()
            cell.sumLabel.text = orderSum.description
            return cell
        }
        
        return UITableViewCell()
    }
    
}

