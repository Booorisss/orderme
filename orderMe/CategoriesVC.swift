//
//  getCategoriesVC.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 03.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, downloadedProtocol {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var sumLabel: UILabel!
    
    @IBOutlet weak var bucketButton: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    let bucket = Bucket.shareInstance
    let sTone = SingleTone.shareInstance
    
    let menu = Menu.shareInstance
    
    
    
    var lockview : UIView!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    
    override func viewDidLoad() {
        menu.loaded = self
        
        if let p = sTone.place {
        myImage.image = p.image
        }
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.categoryTableView.dataSource = self
        

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = true
        
        nameLabel.text = sTone.place.name
        nameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        sumLabel.text = bucket.allSum.description
        
        categoryTableView.reloadData()
        
        
        if menu.categories.count == 0{
             lockview = UIView(frame: self.view.frame)
            let downloadingImage = UIImage(named: "iOrder-1")
            let downloadingImageView = UIImageView(image: downloadingImage)
            downloadingImageView.contentMode = .scaleToFill
            
            lockview = downloadingImageView
            lockview.frame = self.view.frame
            lockview.contentMode = .scaleToFill
            
            self.view.addSubview(lockview)
            lockview.bringSubview(toFront: view)
            indicator.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0);
            indicator.center = view.center
            indicator.color = UIColor.white
            view.addSubview(indicator)
            indicator.bringSubview(toFront: view)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            indicator.startAnimating()

        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell",for: indexPath) as? CategoryCell {
            cell.category = menu.categories[(indexPath as NSIndexPath).row]
            if !menu.categories[(indexPath as NSIndexPath).row].oneprice{
            cell.categoryName.text = menu.categories[(indexPath as NSIndexPath).row].name
            }
            else {
                cell.categoryName.text = menu.categories[(indexPath as NSIndexPath).row].name+"    [ " + menu.categories[(indexPath as NSIndexPath).row].price.description+" грн ]"

            }
            
            
            //            cell.lastMsg.font = UIFont(name: "Arial", size: 15)
           // cell.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as? CategoryCell
        if let Order = segue.destination as? MakeOrderVC {
            
            if let categoryNameText = cell!.categoryName.text {
                Order.categoryName = categoryNameText
                Order.category = cell!.category
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
            }
            
        }
        
    }
    
    func finished() {
        
        if lockview != nil {
        indicator.removeFromSuperview()
        indicator.stopAnimating()
        lockview.removeFromSuperview()
        categoryTableView.reloadData()
        }
        
    }

    
    @IBAction func backButton(_ sender: AnyObject) {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gest(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func refreshUI() {
        DispatchQueue.main.async(execute: {
            self.categoryTableView.reloadData()
        });
    }

    
}
