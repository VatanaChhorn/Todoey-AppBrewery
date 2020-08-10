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

class CatagoryTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var catagoryArray: Results<Catagories>?
    var rowSelected: Int = 0
    
    let realm = try! Realm() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
    }
    
    //MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCells", for: indexPath)
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
            
            self.saveItem(catagory: newCatagory)
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
