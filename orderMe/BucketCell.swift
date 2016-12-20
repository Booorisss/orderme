//
//  BucketCell.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 06.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class BucketCell: UITableViewCell {
    
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishKol: UILabel!
    @IBOutlet weak var onePrice: UILabel!
    
    var dish : Dish!
    
    var numberOfItems = 0
    
    let bucket = Bucket.shareInstance
    
    var cellDelegate : MyCellProtocol?
    
    let sTone = SingleTone.shareInstance
    
    
    @IBAction func addDishBut(_ sender: AnyObject) {
        if dish.oneprice {
            if sTone.categoriesOnePrice.keys.contains(dish.idCategory){
                sTone.categoriesOnePrice[dish.idCategory] = sTone.categoriesOnePrice[dish.idCategory]! + 1
            }
            else {
                sTone.categoriesOnePrice[dish.idCategory] = 1
                let dish1 = Dish(id: -1, idPlace: -1, idCategory: dish.idCategory, name: "", price: dish.catprice, description: "", oneprice: true)
                self.cellDelegate?.addDish(dish1)
            }
        }

        
        
        
        let kol = Int(dishKol.text!)! + 1
        dishKol.text = kol.description
        
        let price = Int(onePrice.text!)!
        var newprice = price
        if kol != 1 {
            newprice = price * kol / (kol - 1)
        }
        else {
            newprice = dish.price
        }
        
        onePrice.text = newprice.description
        
        
        var flag = false
        for (d,_) in bucket.myBucket {
            if d.id == self.dish.id {
                flag = true
                bucket.myBucket[d]! += 1
                break
            }
        }
        if !flag {
            bucket.myBucket[self.dish] = 1
        }
        self.cellDelegate?.addDish(self.dish)
    }
    
    @IBAction func delDishBut(_ sender: AnyObject) {
        if dish.oneprice {
            if sTone.categoriesOnePrice.keys.contains(dish.idCategory){
                sTone.categoriesOnePrice[dish.idCategory] = sTone.categoriesOnePrice[dish.idCategory]! - 1
                if  sTone.categoriesOnePrice[dish.idCategory] == 0 {
                    sTone.categoriesOnePrice.removeValue(forKey: dish.idCategory)
                    let dish1 = Dish(id: -1, idPlace: -1, idCategory: dish.idCategory, name: "", price: dish.catprice, description: "", oneprice: true)
                    self.cellDelegate?.deleteDish(dish1)
                }
            }
            
        }
        
        
        
        if Int(dishKol.text!)! > 0 {
            let kol = Int(dishKol.text!)! - 1
            dishKol.text = kol.description
            
            let price = Int(onePrice.text!)!
            let newprice = price * kol  / (kol + 1)
            onePrice.text = newprice.description
            
            
            
            
            for (d,_) in bucket.myBucket {
                if d.id == self.dish.id {
                    bucket.myBucket[d]! -= 1
                    if bucket.myBucket[d]! == 0 {
                        bucket.myBucket.removeValue(forKey: d)
                    }
                    break
                }
            }
            cellDelegate?.deleteDish(self.dish)
        }
        
        
    }
    
    
    
}
