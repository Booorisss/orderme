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

    @IBOutlet weak var sumLabel: UILabel!
    
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var menu : [Dish]?
    
    var categoryName = ""
    
    let bucket = Bucket.shareInstance
    let sTone = SingleTone.shareInstance
    
    var category : Category? = nil
    
    override func viewDidLoad() {
        self.title = categoryName

        if let p = sTone.place {
            myImage.image = p.image
        }
        
        self.orderTableView.dataSource = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
         nameLabel.text = sTone.place.name
        sumLabel.text = bucket.allSum.description
        nameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        orderTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.menu[category!]!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "dishCell",for: indexPath) as? DishCell {
            cell.dishName.text = menu.menu[category!]![(indexPath as NSIndexPath).row].name
            cell.dish = menu.menu[category!]![(indexPath as NSIndexPath).row]
            cell.priceLabel.text = String(menu.menu[category!]![(indexPath as NSIndexPath).row].price)
            getNumberofItems(cell)
            cell.numberOfItemsLabel.text = cell.numberOfItems.description
            cell.cellDelegate = self
            cell.infoD = self
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func getNumberofItems(_ myCell: UITableViewCell){
        if let cell = myCell as? DishCell {
            cell.numberOfItems = 0
            for d in bucket.myBucket.keys {
                if d.id == cell.dish.id {
                    cell.numberOfItems = bucket.myBucket[d]!
                    break
                }
            }
        }
    }
    func addDish(_ dish: Dish) {
        bucket.allSum += dish.price
        sumLabel.text = bucket.allSum.description
    }
    func deleteDish(_ dish: Dish) {
        bucket.allSum -= dish.price
        sumLabel.text = bucket.allSum.description
    }
    
    
    
    func showInfoDish(_ d: Dish) {
        let alertController = UIAlertController(title: "Информация о блюде", message: d.dishDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "окей", style: .default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    
    
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gest(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
