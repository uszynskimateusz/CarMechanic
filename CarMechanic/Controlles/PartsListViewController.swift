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
    
    var selectedCar: Car? {
        didSet{
            //loadParts()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //loadParts()
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
        saveParts()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: NavigationBar Methods
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new part", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add part", style: .default) { (action) in

//            let newPart = Part(context: self.context)
//            newPart.name = textField.text!
//            newPart.parentCar = self.selectedCar
//
//            self.itemList.append(newPart)
            
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
    
//    func loadParts(with request: NSFetchRequest<Part> = Part.fetchRequest(), predicate: NSPredicate? = nil) {
//
//        let CarsPredicate = NSPredicate(format: "parentCar.name MATCHES %@", selectedCar!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [CarsPredicate, additionalPredicate])
//        } else {
//            request.predicate = CarsPredicate
//        }
//
//        do {
//            itemList =  try context.fetch(request)
//        } catch {
//            print("context fetch request error \(error.localizedDescription)")
//        }
//
//        tableView.reloadData()
//    }
}

//MARK: Search Bar Methods
//extension PartsListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Part> = Part.fetchRequest()
//
//        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//
//        loadParts(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            //loadParts()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
