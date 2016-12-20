//
//  ReservesController.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 6/2/16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class ReservesController: UIViewController, okAlertProtocol, repeatQuest {
    
    @IBOutlet weak var reservesTable: UITableView!
    
    var pastReserves :[Reserve]! = []
    var futureReserves: [Reserve]! = []
    var deleteReserve : Reserve!
    
    
    override func viewDidLoad() {
        reservesTable.delegate = self
        reservesTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(){
        pastReserves = []
        futureReserves = []
        let defaults = UserDefaults.standard
        let decoded  = defaults.object(forKey: "Reserves") as? Data ?? Data()
        let arrayReserves = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Reserve] ?? [Reserve]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd-HH:mm"
        let dateNow = Date()
        for reserve in arrayReserves {
            let dateOfReserve = dateFormatter.date(from: reserve.date)
            if dateOfReserve! < dateNow {
                
                pastReserves.append(reserve)
                
            }
            else {
                futureReserves.append(reserve)
                
            }
        }
    reservesTable.reloadData()
    }
    
 
    func repeatQuestion(_ reserve: Reserve){
        let alertController = UIAlertController(title: "Отмена резерва", message: "Вы уверены, что хотите отменить резерв в " + reserve.placeName + ", " + reserve.date , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Хочу отменить", style: .default) { (action:UIAlertAction!) in
        
            self.deleteReserve = reserve
            
            let httpcon = HttpCon()
            httpcon.okDelegate = self
            
            httpcon.get("\(myUrl)/reserve?id=\(reserve.placeId)&nowDate=\(reserve.nowDate)&date=\(reserve.date)&phoneNumber=\(reserve.phoneNumber)&numberOfPeople=\(reserve.numberOfPeople)&book=false")
            
            
        }
        let cancel = UIAlertAction(title: "Не хочу отменять", style: .default) { (action:UIAlertAction!) in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    
    func okAlert(){
        let defaults = UserDefaults.standard
        
        let decoded  = defaults.object(forKey: "Reserves") as? Data ?? Data()
        var arrayReserves = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Reserve] ?? [Reserve]()
        
        var i = 0
        for res in arrayReserves {
            if res == deleteReserve {
                arrayReserves.remove(at: i)
            }
            i = i + 1
        }
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: arrayReserves)
        
        defaults.set(encodedData, forKey: "Reserves")
        defaults.synchronize()
        loadData()
        
        showAlert(title: "Cancelation", message: "Thank you! Your reservation was canceled")
        
        
    }
    
    func notOkAlert() {
        showAlert(title: "Ooops", message: "Some problems with connection")

    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
    }
    

    
}


// Mark : UITableViewDataSource,  UITableViewDelegate
extension ReservesController : UITableViewDataSource, UITableViewDelegate{
    
    // 1 section - Future reservatoins
    // 2 section - Past reservations
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Future reservations"
        }
        return "History of reservations"
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return futureReserves.count
        }
        else {
            return pastReserves.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FutureCell",for: indexPath) as? FutureReserve {
                let myreserve = futureReserves[(indexPath as NSIndexPath).row]
                
                cell.placename.text = myreserve.placeName
                cell.data.text = myreserve.date
                cell.reserve = myreserve
                
                cell.repquestion = self
                return cell
            }
        }
        else if (indexPath as NSIndexPath).section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PastCell",for: indexPath) as? PastReserve {
                let myreserve = pastReserves[(indexPath as NSIndexPath).row]
                
                cell.placeName.text = myreserve.placeName
                cell.data.text = myreserve.date
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
}
