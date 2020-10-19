//
//  ViewController.swift
//  CarMechanic
//
//  Created by Mateusz Uszyński on 17/10/2020.
//

import UIKit
import CoreData

class PartsListViewController: UITableViewController {

    var itemList = [Part]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadParts()
    }
    
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartItemCell", for: indexPath)
        
        let item = itemList[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemList[indexPath.row]
        item.done = !item.done
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: NavigationBar Methods
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new part", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add part", style: .default) { (action) in

            let newPart = Part(context: self.context)
            newPart.name = textField.text!
            
            self.itemList.append(newPart)
            
            self.saveParts()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new part"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveParts() {
        do {
            try context.save()
        } catch {
            print("error context.save() \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadParts() {
        let request : NSFetchRequest<Part> = Part.fetchRequest()
        do {
            itemList =  try context.fetch(request)
        } catch {
            print("context fetch request error \(error.localizedDescription)")
        }
    }
}

