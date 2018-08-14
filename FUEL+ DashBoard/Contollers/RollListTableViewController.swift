//
//  RollListTableViewController.swift
//  FUEL+ DashBoard
//
//  Created by Chester Wong on 2018-08-13.
//  Copyright © 2018 CWC. All rights reserved.
//

import UIKit
import CoreData

class RollListTableViewController: UITableViewController {
    
    var rollArray = [Roll]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedAlbum :Album? {
        
        didSet {
            loadRolls()
            
        }
    }
    
    
    func loadRolls(with request:NSFetchRequest<Roll> = Roll.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let albumPredicate = NSPredicate(format: "parentAlbum.name MATCHES %@", selectedAlbum!.name!)
        
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [albumPredicate, additionalPredicate])
            
        } else {
            request.predicate = albumPredicate
            
        }
        
        
        do {
            
            rollArray = try context.fetch(request)
            
        } catch {
            
            print (error)
            
        }
        
        
        tableView.reloadData()
        
        
    }
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rollArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rollListCell", for: indexPath)
        let roll = rollArray[indexPath.row]
        cell.textLabel?.text = roll.name
        cell.detailTextLabel?.text = ("Number of photo(s) taken: \(roll.numberOfPhotos)")
        return cell
    }

    
    @IBAction func addRollButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Name Your Roll", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            let tempRoll = Roll(context: self.context)
            tempRoll.name = textField.text!
            tempRoll.exposed = false
            tempRoll.nextframe = 0
            tempRoll.numberOfPhotos = 0
            tempRoll.parentAlbum = self.selectedAlbum
        
            self.rollArray.append(tempRoll)
            self.saveRoll()
       
            
        }
        
        alert.addTextField { (alertTextdField) in
            alertTextdField.placeholder = "Name Roll"
            textField = alertTextdField
            
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func saveRoll() {
        
        do {
            try context.save()
        } catch {
            print (error)
        }
        tableView.reloadData()
   
    }
}
