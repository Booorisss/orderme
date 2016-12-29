//
//  ReservesController.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 6/2/16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class ReservesController: UIViewController, RepeatQuestionProtocol {
    
    @IBOutlet weak var reservesTable: UITableView!
    
    var pastReserves :[Reserve]?
    var futureReserves: [Reserve]?
    var deleteReserve : Reserve?
    
    
    override func viewDidLoad() {
        reservesTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(){
        // TODO download reserves from API
        reservesTable.reloadData()
    }
    
 
    func repeatQuestion(_ reserve: Reserve){
        let alertController = UIAlertController(title: "Cancel", message: "Are you sure that you want to cancel your reservation in \(reserve.place?.name)?" , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Хочу отменить", style: .default) { (action:UIAlertAction!) in
        self.deleteReserve = reserve
        
        // TODO send to api cancelation of reserve
            
        }
        let cancelAction = UIAlertAction(title: "I don`t want to cancel", style: .default, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
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


// Mark : UITableViewDataSource
extension ReservesController : UITableViewDataSource{
    
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
        guard let pastReserves = pastReserves,
            let futureReserves = futureReserves else {
                return 0
        }
        if section == 0 {
            return futureReserves.count
        }
        else {
            return pastReserves.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let pastReserves = pastReserves,
            let futureReserves = futureReserves else {
                return UITableViewCell()
        }
        
        switch ((indexPath as NSIndexPath).section) {
        case 0  :  // Future cells
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FutureCell",for: indexPath) as? FutureReserve {
                let myreserve = futureReserves[(indexPath as NSIndexPath).row]
                
                cell.placename.text = myreserve.place?.name
                cell.data.text = myreserve.date?.description
                cell.reserve = myreserve
                cell.repquestion = self
                return cell
            }
        
        case 1  : // Past cells
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PastCell",for: indexPath) as? PastReserve {
                let numberOfPastReserveInArray = (indexPath as NSIndexPath).row - futureReserves.count
                let myreserve = pastReserves[numberOfPastReserveInArray]
                cell.placeName.text = myreserve.place?.name
                cell.data.text = myreserve.date?.description
                
                return cell
            }
            
        default : return UITableViewCell()
        }
        return UITableViewCell()
    }
}
