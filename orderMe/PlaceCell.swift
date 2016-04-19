//
//  PlaceCell.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 29.03.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAdress: UILabel!
    @IBOutlet weak var placeImage: UIImageView!
    
    var id = 0
    var place : Place!
    
}
