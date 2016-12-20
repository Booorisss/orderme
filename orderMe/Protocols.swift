//
//  MyCellProtocol.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 06.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import Foundation

protocol MyCellProtocol {
    func addDish(_ dish: Dish)
    func deleteDish(_ dish: Dish)
}

protocol okAlertProtocol {
    func okAlert()
    func notOkAlert()
}

protocol infoDish {
    func showInfoDish(_ dish: Dish)
}

protocol cancelReserve {
    func ok(_ reserve: Reserve)
    func notOk()
}

protocol downloadedProtocol{
    func finished()
}

protocol repeatQuest{
    func repeatQuestion(_ reserve: Reserve)
}

import Foundation

struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
    }
    
}
