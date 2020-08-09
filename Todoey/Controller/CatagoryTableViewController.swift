//
//  CatagoryTableViewController.swift
//  Todoey
//
//  Created by Chhorn Vatana on 8/8/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData


class CatagoryTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var catagoryArray = [Catagory]()
    var rowSelected: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
    }
    
    //MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCells", for: indexPath)
        cell.textLabel?.text = self.catagoryArray[indexPath.row].name
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
        destinationVC.selectedCatagory = catagoryArray[rowSelected]
    }
    
    
    
    //MARK: - Add new catagories
    
    @IBAction func AddCatagoryItemClicked(_ sender: UIBarButtonItem) {
        
        var addNewCatagoriesText = UITextField()
        
        let alert = UIAlertController(title: "Add New Catagories", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Done", style: .default) { (uiAlertAction) in
            print(addNewCatagoriesText.text!)
            
            let newCatagory = Catagory(context: self.context )
            newCatagory.name = addNewCatagoriesText.text!
            
            if addNewCatagoriesText.text?.count != 0 {
                self.catagoryArray.append(newCatagory)
            }
            self.saveItem()
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
        let request : NSFetchRequest<Catagory> = Catagory.fetchRequest()
        do {
            catagoryArray = try context.fetch(request)
        } catch  {
            print(error)
        }
    }
    
    func saveItem()  {
        do {
            try context.save()
        } catch  {
            print("Save item error: \(error)")
        }
        
        tableView.reloadData()
    }
    
}
