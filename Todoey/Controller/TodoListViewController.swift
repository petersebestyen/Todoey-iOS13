//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]() //  = [Item(title:"Find Mike", done:false), Item(title: "Buy Eggs", done:false), Item(title:"Destroy Demogorgon", done:false)]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let keys = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = [Item]()
            for key in keys {
                let array = key.components(separatedBy: "|")
                // print(array)
                itemArray.append(Item(title: array.first ?? "" , done: array.last ?? "" == "TRUE" ? true : false))
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveChanges()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType   = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        itemArray[indexPath.row].done.toggle()
        saveChanges()

        tableView.reloadData()
        // tableView.cellForRow(at: indexPath)?.accessoryType = (itemArray[indexPath.row].done ? .checkmark : .none)
        // tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert  = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            self.itemArray.append(Item(title:textField.text ?? "New Item", done: false))
            self.saveChanges()
            // print(self.itemArrayToString())
            
            self.tableView.reloadData()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func itemArrayToString() -> [String] {
        var result = [String]()
        guard !itemArray.isEmpty else { return result }
        
        for item in itemArray {
            result.append(item.title + "|" + (item.done ? "TRUE" : "FALSE"))
        }
        return result
    }
    
    func saveChanges() {
        defaults.set(itemArrayToString(), forKey: "TodoListArray")
    }
}

