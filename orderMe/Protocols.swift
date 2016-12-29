//
//  MyCellProtocol.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 06.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import Foundation

protocol BucketCellProtocolAddDelete {
    func addDish(_ dish: Dish)
    func deleteDish(_ dish: Dish)
}


protocol InfoDishProtocol {
    func showInfoDish(_ dish: Dish)
}


protocol RepeatQuestionProtocol{
    func repeatQuestion(_ reserve: Reserve)
}

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}
