//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit

class ToDoListViewController: UITableViewController {
    
    //MARK: - Add item to CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray : Results<Items>?
    var realm = try! Realm()
    
    var selectedCatagory : Catagories?  {
        didSet {
            loadItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Data Source
    
    //To generate the number of row in the TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray?.count ?? 1
        
    }
    
    //Initialize each of the cells with a function, or value.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // dequeueReusableCell Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCells", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        let item = itemArray?[indexPath.row]
        
        cell.textLabel?.text = item?.title ?? "There is no item added yet!"
        
        if item?.done != nil {
            cell.accessoryType = item!.done ? .checkmark : .none
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    //Tells the delegate that the specified row is now selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = itemArray?[indexPath.row] {
            do {
                try  realm.write({
                    item.done = !item.done
                })
            } catch  {
                print(error)
            }
            
            tableView.reloadData()
            
        }
        
    }
    
    
    //MARK: - add new item
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var alertText = UITextField()
        
        //MARK: - Alert
        
        //An object that displays an alert message to the user.
        let alert = UIAlertController(title: "Add new todoey items", message: "", preferredStyle: .alert)
        
        //An action that can be taken when the user taps a button in an alert.
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add Item Button on our UIAlert
            
            print("success!")
            print(alertText.text!)
            
            if let  currentCatagory = self.selectedCatagory     {
                if alertText.text! != ""  {
                    do {
                        try self.realm.write({
                            let newItem = Items()
                            newItem.title = alertText.text!
                            newItem.done = false
                            currentCatagory.items.append(newItem)
                        })
                    } catch  {
                        print("Error saving item \(error)")
                    }
                }
            }
            
            self.tableView.reloadData()
        }
        
        //Adds a text field to an alert.
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Insert new item"
            alertText = alertTextField
            
        }
        
        //Attaches an action object to the alert or action sheet.
        alert.addAction(action)
        
        //Presents a view controller modally.
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Save Item Function
    
    func saveItem (newItem: Items )  {
        do {
            try self.realm.write({
                self.realm.add(newItem)
            })
        } catch  {
            print("Error saving new Item \(error)")
        }
        
        //Reloads the rows and sections of the table view.
        self.tableView.reloadData()
    }
    
    //MARK: - Create Load Item Function
    
    func loadItem () {
        
        itemArray = selectedCatagory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }
    
    
}
//
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = selectedCatagory?.items.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

extension ToDoListViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
