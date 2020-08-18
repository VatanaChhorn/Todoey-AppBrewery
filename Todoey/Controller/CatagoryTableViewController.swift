//
//  CatagoryTableViewController.swift
//  Todoey
//
//  Created by Chhorn Vatana on 8/8/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit

class CatagoryTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var catagoryArray: Results<Catagories>?
    var rowSelected: Int = 0
    
    let realm = try! Realm() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
        view.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.4274509804, blue: 0.4274509804, alpha: 1)
        
    }
    
    //MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCells", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.numberOfLines = 0
        cell.alpha = 0.5
        cell.backgroundColor = #colorLiteral(red: 1, green: 0.6666666667, blue: 0.4431372549, alpha: 1)
        cell.textLabel?.text = self.catagoryArray?[indexPath.row].name ?? "No catagory added yet!"
        return cell
    }
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.rowSelected = indexPath.row
        performSegue(withIdentifier: "performItemScreen", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination  as! ToDoListViewController
        destinationVC.selectedCatagory = catagoryArray?[rowSelected]
    }
    
    
    
    //MARK: - Add new catagories
    
    @IBAction func AddCatagoryItemClicked(_ sender: UIBarButtonItem) {
        
        var addNewCatagoriesText = UITextField()
        
        let alert = UIAlertController(title: "Add New Catagories", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Done", style: .default) { (uiAlertAction) in
            print(addNewCatagoriesText.text!)
            
            let newCatagory = Catagories()
            newCatagory.name = addNewCatagoriesText.text!
            if addNewCatagoriesText.text?.count != 0 {
                self.saveItem(catagory: newCatagory)
            }
        }
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "New catagorys name"
            addNewCatagoriesText = textfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation 
    func loadItem ()  {
        
        catagoryArray = realm.objects(Catagories.self)
        tableView.reloadData()
    }
    
    func saveItem(catagory: Catagories)  {
        do {
            try realm.write {
                realm.add(catagory)
            }
        } catch  {
            print("Save item error: \(error)")
        }
        
        tableView.reloadData()
    }
    
}

extension CatagoryTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            try! self.realm.write {
                if let currentCatagory = self.catagoryArray?[indexPath.row]
                {
                    self.realm.delete(currentCatagory)
                }
                
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
