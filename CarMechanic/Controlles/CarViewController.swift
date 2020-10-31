//
//  CarViewController.swift
//  CarMechanic
//
//  Created by Mateusz Uszyński on 24/10/2020.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CarViewController: UITableViewController {
    let realm = try! Realm()
    
    var cars: Results<Car>?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 90
        loadCars()
    }

    //MARK: Add new car
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new car", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Car", style: .default) { (action) in

            let newCar = Car()
            newCar.name = textField.text!
            
            self.saveCars(car: newCar)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Car"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarItemCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        cell.textLabel?.text = cars?[indexPath.row].name ?? "Brak samochodów"
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToParts", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destiantionVC = segue.destination as! PartsListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destiantionVC.selectedCar = cars?[indexPath.row]
        }
    }
    
    //MARK: Data Manipulation Methods
    func saveCars(car: Car) {
        do {
            try realm.write{
                realm.add(car)
            }
        } catch {
            print("error context.save() \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCars() {

        cars = realm.objects(Car.self)
        
        tableView.reloadData()
  }
}
//MARK: Swipe Cell Delegate Methods
extension CarViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                if let carForDeletion = self.cars?[indexPath.row] {
                    do {
                        try self.realm.write {
                            self.realm.delete(carForDeletion)
                        }
                    } catch {
                        print("error with deletion. \(error.localizedDescription)")
                    }
                }
            }

            // customize the action appearance
            deleteAction.image = UIImage(named: "trash-small")

            return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
