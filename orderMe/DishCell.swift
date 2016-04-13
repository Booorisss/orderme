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
    
    @IBOutlet weak var dishDescription: UILabel!
    
    var dish : Dish!
    
    var numberOfItems = 0
    
    let bucket = Bucket.shareInstance
    
    var cellDelegate : MyCellProtocol?
    
    @IBAction func addItem(sender: AnyObject) {
        numberOfItems += 1
        
        numberOfItemsLabel.text = String(numberOfItems)
        addToBucket(sender)
        
    }
    
    
    
    @IBAction func deleteItem(sender: AnyObject) {
        if numberOfItems > 0 {
            numberOfItems -= 1
            numberOfItemsLabel.text = String(numberOfItems)
            
            if let button = sender as? UIButton {
                if let superview = button.superview {
                    if let cell = superview.superview as? DishCell {                        self.cellDelegate?.deleteDish(cell.dish)
                
                        for (d,_) in bucket.myBucket {
                            if d.id == cell.dish.id {
                                bucket.myBucket[d]! -= 1
                                if bucket.myBucket[d]! == 0 {
                                    bucket.myBucket.removeValueForKey(d)
                                }
                                break
                            }
                        }
                 
                    }
                }
            }
            
        }
    }
    
    func addToBucket(sender: AnyObject){
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? DishCell {
                    
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
