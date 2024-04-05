//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController /*, UISearchBarDelegate */{
    
    var itemArray = [Item]() //  = [Item(title:"Find Mike", done:false), Item(title: "Buy Eggs", done:false), Item(title:"Destroy Demogorgon", done:false)]
    //  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    // let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveItems()
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
        saveItems()

        tableView.reloadData()
        // tableView.cellForRow(at: indexPath)?.accessoryType = (itemArray[indexPath.row].done ? .checkmark : .none)
        // tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert  = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            let item            = Item(context: self.context)
            item.title          = textField.text ?? "New Item"
            item.done           = false
            item.parentCategory = self.selectedCategory
            
            self.itemArray.append(item)
            self.saveItems()
            // print(self.itemArrayToString())
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
//    func itemArrayToString() -> [String] {
//        var result = [String]()
//        guard !itemArray.isEmpty else { return result }
//        
//        for item in itemArray {
//            result.append(item.title + "|" + (item.done ? "TRUE" : "FALSE"))
//        }
//        return result
//    }
    
    func saveItems() {
        // defaults.set(itemArrayToString(), forKey: "TodoListArray")
        
        //        let encoder = PropertyListEncoder()
        //        do {
        //            let data = try encoder.encode(itemArray)
        //            try data.write(to: dataFilePath!)
        //        } catch {
        //            print("Error encoding item array " + error.localizedDescription)
        //        }
        
        do {
            try context.save()
        } catch {
            print("Error saving context " + error.localizedDescription)
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate = NSPredicate(format: "1=1")) {
        //        if let keys = defaults.array(forKey: "TodoListArray") as? [String] {
        //            itemArray = [Item]()
        //            for key in keys {
        //                let array = key.components(separatedBy: "|")
        //                // print(array)
        //                itemArray.append(Item(title: array.first ?? "" , done: array.last ?? "" == "TRUE" ? true : false))
        //            }
        //        }
        
        //        let decoder = PropertyListDecoder()
        //        do {
        //            let data = try Data(contentsOf: dataFilePath!)
        //            itemArray = try decoder.decode([Item].self, from: data)
        //        } catch {
        //            print("Error decoding item array " + error.localizedDescription)
        //        }
        let categoryPredicate       = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name ?? "")
        let compoundPredicate       = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])

        request.predicate           = compoundPredicate
        request.sortDescriptors     = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context " + error.localizedDescription)
        }
        
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !searchBar.text!.isEmpty {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "")
            loadItems(predicate: predicate)
        } else {
            loadItems()
        }
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

