//
//  MyCellProtocol.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 06.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import Foundation

protocol MyCellProtocol {
    func addDish(dish: Dish)
    func deleteDish(dish: Dish)
}

protocol okAlertProtocol {
    func okAlert()
    func notOkAlert()
}