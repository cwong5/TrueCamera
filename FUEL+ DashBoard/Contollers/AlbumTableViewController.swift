//
//  AlbumTableViewController.swift
//  FUEL+ DashBoard
//
//  Created by Chester Wong on 2018-08-13.
//  Copyright © 2018 CWC. All rights reserved.
//

import UIKit
import CoreData


class AlbumTableViewController: UITableViewController {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var albumArray = [Album]()
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Name Your Album", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            let tempAlbum = Album(context: self.context)
            tempAlbum.name = textField.text!
            self.albumArray.append(tempAlbum)
            self.saveAlbum()
            
            
            
        }
        alert.addTextField { (alertTextdField) in
            alertTextdField.placeholder = "Create Album"
            textField = alertTextdField
            
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
 
        
    }
    
    
    
    func loadAlbum(with request:NSFetchRequest<Album> = Album.fetchRequest()) {
        
        do {
            
            albumArray = try context.fetch(request)
            
        } catch {
            
            print (error)
            
        }
        tableView.reloadData()
    }
    
    
    
    
    
    func saveAlbum() {
        
        do {
            try context.save()
        } catch {
            
            print (error)
        }
        
        tableView.reloadData()
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadAlbum()
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath)
        
        let album = albumArray[indexPath.row]
        cell.textLabel?.text = album.name
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumArray.count
    }


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            context.delete(albumArray[indexPath.row])
            albumArray.remove(at: indexPath.row)
            saveAlbum()
        }
    }
    

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToRolls", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToRolls" {
            
            let destinationVC = segue.destination as! RollListTableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedAlbum = albumArray[indexPath.row]
            }
        }
        
    }
    
    
}


