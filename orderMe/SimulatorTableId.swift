//
//  SimulatorTableId.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 13.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class SimulatorTableId: UIViewController {

    @IBOutlet weak var tid: UITextField!
    @IBAction func button(sender: AnyObject) {
        if let myTableId = Int(tid.text!){
            let sTone = SingleTone.shareInstance
            sTone.tableID = myTableId
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
}
