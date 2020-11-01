//
//  CarViewController.swift
//  CarMechanic
//
//  Created by Mateusz Uszyński on 24/10/2020.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CarViewController: SwipeTableViewController {
    let realm = try! Realm()
    
    var cars: Results<Car>?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 90
        loadCars()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller not exist")}

        navBar.barTintColor = UIColor(hexString: "#FE584E")

    }

    //MARK: Add new car
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new car", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Car", style: .default) { (action) in

            let newCar = Car()
            newCar.name = textField.text!
            newCar.colour = UIColor.randomFlat().hexValue()
            
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let car = cars?[indexPath.row] {
            cell.textLabel?.text = car.name
            
            guard let carColour =  UIColor(hexString: car.colour) else {
                fatalError("fatal error in car view controller, do car colour in cellforat")
            }
            cell.backgroundColor = carColour
            cell.textLabel?.textColor = ContrastColorOf(carColour, returnFlat: true)
        }
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
    
    override func updateModel(at indexPath: IndexPath) {
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
}
