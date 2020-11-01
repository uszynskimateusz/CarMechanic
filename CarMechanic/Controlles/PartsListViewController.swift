//
//  ViewController.swift
//  CarMechanic
//
//  Created by Mateusz Uszyński on 17/10/2020.
//

import UIKit
import RealmSwift
import ChameleonFramework

class PartsListViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
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
        
        tableView.rowHeight = 90
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex = selectedCar?.colour {
            title = selectedCar!.name
            
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controller not exist")}
            
            if let navBarColour = UIColor(hexString: colourHex) {
                navBar.barTintColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                
                navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                
                searchBar.barTintColor = navBarColour
            }

        }
    }
    
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doParts?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = doParts?[indexPath.row] {
            cell.textLabel?.text = item.name
            
            if let colour = UIColor(hexString: selectedCar!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(doParts!.count)) {
                cell.backgroundColor = colour
            
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let partForDeletion = self.doParts?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(partForDeletion)
                }
            } catch {
                print("error with deletion. \(error.localizedDescription)")
            }
        }
    }
}
