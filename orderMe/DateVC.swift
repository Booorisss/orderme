//
//  DateVC.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 30.03.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class DateVC: UIViewController, okAlertProtocol{
    
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var phoneText: UITextField!
    
    
    var chosenDate = ""
    let sTone = SingleTone.shareInstance
    
    override func viewDidLoad() {
        if let p = sTone.place {
            myImageView.image = p.image
        }
    }
    
    
    
    @IBAction func bookTable(sender: AnyObject) {
        
      
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy/MM/dd-HH:mm"
        
        let strDate = dateFormatter.stringFromDate(DatePicker.date)
        
        chosenDate = strDate
        
        print(chosenDate)
        
        
        let httpcon = HttpCon()
        httpcon.okDelegate = self
        let idPlace = sTone.idPlace
        if let phoneNumber = phoneText.text {
        
        httpcon.get("\(myUrl)/reserve?id=\(idPlace)&idTable=\(sTone.tableID)&date=\(self.chosenDate)&phoneNumber=\(phoneNumber)")
        }

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        super.touchesBegan(touches, withEvent: event)
        view.endEditing(true)
    }
    
    func okAlert(){
        
        let alertController = UIAlertController(title: "Ваш стол забронирован!", message: "Ожидаем вас ", preferredStyle: .Alert)
        
        
        let okAction = UIAlertAction(title: "Окей", style: .Default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
        
    }
    func notOkAlert(){
        
        let alertController = UIAlertController(title: "Возникли некоторые проблемы!", message: "Проверьте, пожалуйста, интернет и попробуйте снова", preferredStyle: .Alert)
        
        
        let okAction = UIAlertAction(title: "Окей", style: .Default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
        
    }
    
}
