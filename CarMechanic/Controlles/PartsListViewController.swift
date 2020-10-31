//
//  ViewController.swift
//  CarMechanic
//
//  Created by Mateusz Uszyński on 17/10/2020.
//

import UIKit
import RealmSwift

class PartsListViewController: UITableViewController {

    var doParts: Results<Part>?
    let realm = try! Realm()
    
    var selectedCar: Car? {
        didSet{
            loadParts()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //loadParts()
    }
    
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doParts?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartItemCell", for: indexPath)
        
        if let item = doParts?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No parts"
        }
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let part = doParts?[indexPath.row] {
            do {
                try realm.write {
                    part.done = !part.done
                }
            } catch {
                print("Error with updating, \(error.localizedDescription)")
            }
        }
        
        self.tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: NavigationBar Methods
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new part", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add part", style: .default) { (action) in

            if let currentCar = self.selectedCar {
                do {
                    try self.realm.write {
                        let newPart = Part()
                        newPart.name = textField.text!
                        newPart.dateCreated = Date()
                        currentCar.parts.append(newPart)
                    }
                } catch {
                    print("error saving parts, \(error.localizedDescription)")
                }
            }
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new part"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadParts() {

        doParts = selectedCar?.parts.sorted(byKeyPath: "name", ascending: true)

        tableView.reloadData()
    }
}

//MARK: Search Bar Methods
extension PartsListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doParts = doParts?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadParts()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
