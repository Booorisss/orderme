//
//  DateVC.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 30.03.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class ReserveVC: UIViewController, okAlertProtocol{
    
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var phoneText: UITextField!
    
    @IBOutlet weak var numberOfPeople: UITextField!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var chosenDate = ""
    var reserve : Reserve!
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        if let p = sTone.place {
            myImageView.image = p.image
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
     nameLabel.text = sTone.place.name
        nameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
    }
    
    
    @IBAction func bookTable(_ sender: AnyObject) {
        
        if phoneText.text == "" {
            let alertController = UIAlertController(title: "Не хватает Вашего номера телефона", message: "Укажите, пожалуйста, Ваш номер телефона", preferredStyle: .alert)
            
            
            let okAction = UIAlertAction(title: "Добавить номер", style: .default) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:nil)
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy/MM/dd-HH:mm"
        
        let strDate = dateFormatter.string(from: DatePicker.date)
        
        chosenDate = strDate
  
        
        let Date = Foundation.Date()
        
        let nowDate = dateFormatter.string(from: Date)
        
        let httpcon = HttpCon()
        httpcon.okDelegate = self
        let idPlace = sTone.place.id
        if let phoneNumber = phoneText.text {
        
        httpcon.get("\(myUrl)/reserve?id=\(idPlace)&nowDate=\(nowDate)&date=\(self.chosenDate)&phoneNumber=\(phoneNumber)&numberOfPeople=\(numberOfPeople.text!)&book=true")
            
        reserve = Reserve(placeId: idPlace, placeName: sTone.place.name, date: chosenDate,nowDate: nowDate, phoneNumber: phoneNumber, numberOfPeople: numberOfPeople.text!, book: true)
            
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func okAlert(){
        //add reserve into UserDefaults
        
        let defaults = UserDefaults.standard
        
        let decoded  = defaults.object(forKey: "Reserves") as? Data ?? Data()
        var arrayReserves = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Reserve] ?? [Reserve]()
        
        arrayReserves.append(reserve)
        
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: arrayReserves)
        
        defaults.set(encodedData, forKey: "Reserves")
        defaults.synchronize()
        
        // вывести уведомление, что стол забронирован
        
        
        let alertController = UIAlertController(title: "Ваш стол забронирован!", message: "Ожидаем вас ", preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "Окей", style: .default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion:nil)
        
    }
    func notOkAlert(){
        
        let alertController = UIAlertController(title: "Ooops", message: "Проверьте, пожалуйста, интернет и попробуйте снова", preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "Окей", style: .default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
      _ =  self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gest(_ sender: AnyObject) {
      _ =   self.navigationController?.popViewController(animated: true)
    }
    
    
}
