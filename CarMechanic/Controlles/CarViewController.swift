//
//  CarViewController.swift
//  CarMechanic
//
//  Created by Mateusz Uszyński on 24/10/2020.
//

import UIKit
import RealmSwift

class CarViewController: UITableViewController {
    let realm = try! Realm()
    
    var cars = [Car]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext 
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadCars()
    }

    //MARK: Add new car
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new car", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Car", style: .default) { (action) in

            let newCar = Car()
            newCar.name = textField.text!
            
            self.cars.append(newCar)
            
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
        return cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarItemCell", for: indexPath)
        
        cell.textLabel?.text = cars[indexPath.row].name
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToParts", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destiantionVC = segue.destination as! PartsListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destiantionVC.selectedCar = cars[indexPath.row]
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
    
//    func loadCars(with request: NSFetchRequest<Car> = Car.fetchRequest()) {
//        do {
//            cars =  try context.fetch(request)
//        } catch {
//            print("context fetch request error \(error.localizedDescription)")
//        }
//        
//        tableView.reloadData()
//  }
}
