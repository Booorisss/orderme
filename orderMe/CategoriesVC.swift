//
//  getCategoriesVC.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 03.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController {
    
    @IBOutlet weak var myImage: UIImageView! // image of Place
    @IBOutlet weak var sumLabel: UILabel!    // sum in the bucket
    
    @IBOutlet weak var bucketButton: UIButton!  // go to Bucket
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    let bucket = Bucket.shareInstance
    
    var menu : Menu?   // menu from previous ViewController ( PlaceMainMenu )
    var categoriesArray : [Category] = [] // Keys of dictionary menu
    
    
    override func viewDidLoad() {
        if let place = SingleTone.shareInstance.place {
            myImage.image = place.image
        }
        self.navigationController?.isNavigationBarHidden = true
        self.categoryTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = true
        nameLabel.text = SingleTone.shareInstance.place.name
        nameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        sumLabel.text = bucket.allSum.description
        guard let menu = self.menu else { return }
        let keys = menu.menu!.keys
        categoriesArray = Array(keys)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? CategoryCell else { return }
        guard let Order = segue.destination as? MakeOrderVC else  { return }
        
            if let categoryNameText = cell.categoryName.text {
                Order.categoryName = categoryNameText  // name of chosen category
                Order.category = cell.category    // category
                let chosenMenu = menu?.menu?[cell.category]
                Order.menu = chosenMenu
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
            }
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gest(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
}



// Mark : UITableViewDataSource, UITableViewDelegate
extension CategoriesVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell",for: indexPath) as? CategoryCell {
            cell.category = categoriesArray[(indexPath as NSIndexPath).row]
            cell.categoryName.text = categoriesArray[(indexPath as NSIndexPath).row].name
            return cell
        }
        
        return UITableViewCell()
    }
    
}
