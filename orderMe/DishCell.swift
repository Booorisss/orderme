//
//  DishCell.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 03.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class DishCell: UITableViewCell {
    
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    
    
    var dish : Dish!
    
    var numberOfItems = 0
    
    let bucket = Bucket.shareInstance
    
    var cellDelegate : MyCellProtocol?
    
    var infoD : infoDish?
    
    let sTone = SingleTone.shareInstance
    
    @IBAction func addItem(_ sender: AnyObject) {
        numberOfItems += 1
        
        numberOfItemsLabel.text = String(numberOfItems)
        addToBucket(sender)
        
        
    }
    
    @IBAction func infoBut(_ sender: AnyObject) {
        infoD?.showInfoDish(self.dish)
    }
    
    
    @IBAction func deleteItem(_ sender: AnyObject) {
        if numberOfItems > 0 {
            numberOfItems -= 1
            numberOfItemsLabel.text = String(numberOfItems)
            
            if let button = sender as? UIButton {
                if let superview = button.superview {
                    if let cell = superview.superview as? DishCell {
                        if cell.dish.oneprice {
                            if sTone.categoriesOnePrice.keys.contains(cell.dish.idCategory){
                                sTone.categoriesOnePrice[cell.dish.idCategory] = sTone.categoriesOnePrice[cell.dish.idCategory]! - 1
                                if  sTone.categoriesOnePrice[cell.dish.idCategory] == 0 {
                                     sTone.categoriesOnePrice.removeValue(forKey: cell.dish.idCategory)
                                    let dish1 = Dish(id: -1, idPlace: -1, idCategory: dish.catid, name: cell.dish.catname, price: cell.dish.catprice, description: "", oneprice: true)
                                     self.cellDelegate?.deleteDish(dish1)
                                     self.bucket.myBucket.removeValue(forKey: dish1)
                                    
                                    
                                }
                            }
                          
                        }
                        self.cellDelegate?.deleteDish(cell.dish)
                        
                        for (d,_) in bucket.myBucket {
                            if d.id == cell.dish.id {
                                bucket.myBucket[d]! -= 1
                                if bucket.myBucket[d]! == 0 {
                                    bucket.myBucket.removeValue(forKey: d)
                                }
                                break
                            }
                        }
                        
                    }
                }
            }
            
        }
    }
    
    func addToBucket(_ sender: AnyObject){
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? DishCell {
                    if cell.dish.oneprice {
                        if sTone.categoriesOnePrice.keys.contains(cell.dish.idCategory){
                            sTone.categoriesOnePrice[cell.dish.idCategory] = sTone.categoriesOnePrice[cell.dish.idCategory]! + 1
                        }
                        else {
                            sTone.categoriesOnePrice[cell.dish.idCategory] = 1
                            
                            let dish1 = Dish(id: -1, idPlace: -1, idCategory: dish.catid , name: cell.dish.catname, price: cell.dish.catprice, description: "", oneprice: true)
                            self.cellDelegate?.addDish(dish1)
                            bucket.myBucket[dish1] = 1
                        }
                    }
                    self.cellDelegate?.addDish(cell.dish)
                    var flag = false
                    for (d,_) in bucket.myBucket {
                        if d.id == cell.dish.id {
                            flag = true
                            bucket.myBucket[d]! += 1
                            break
                        }
                    }
                    if !flag {
                        bucket.myBucket[cell.dish] = 1
                    }
                    
                }
            }
        }
    }
    
    
}
