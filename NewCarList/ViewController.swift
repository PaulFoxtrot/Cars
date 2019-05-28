//
//  ViewController.swift
//  NewCarList
//
//  Created by foxtrot on 27/05/2019.
//  Copyright © 2019 foxtrot. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var carsTableView: UITableView!
    
    var cars: [Car] = []
    
    
    @IBAction func addNewCar(_ sender: Any) {
        let alert = UIAlertController(title: "New Car", message: "Add a new car", preferredStyle: .alert)

        alert.addTextField(configurationHandler: { (textFieldModel) in
            textFieldModel.placeholder = "model"
        })

        alert.addTextField(configurationHandler: { (textFieldYear) in
            textFieldYear.placeholder = "year"
        })
       
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            guard let textFieldModel = alert.textFields?[0],
                let modelToSave = textFieldModel.text
                else {
                    return
            }
            guard let textFieldYear = alert.textFields?[1],
                let yearToSave = textFieldYear.text
                else {
                    return
            }
            
            self.save(model: modelToSave, year: Int16(yearToSave)!)
            self.carsTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
   
    func save(model: String, year: Int16) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Car", in: managedContext)!
        
        let car = NSManagedObject(entity: entity, insertInto: managedContext)
        
        car.setValue(model, forKeyPath: "model")
        car.setValue(year, forKeyPath: "year")
        
        do {
            try managedContext.save()
            cars.append(car as! Car)
            carsTableView.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
    func fetchCars(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Car>(entityName: "Car")
        
        do {
            cars = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCars()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        carsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    
    func update(model:String, year: Int16, car: Car) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            car.setValue(model, forKey: "model")
            car.setValue(year, forKey: "year")
            
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                
            } catch {
                print("Error with request: \(error)")
            }
        }
    }
    func delete(car: Car){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            managedContext.delete(car)
        }
        do {
            try managedContext.save()
        } catch {
            print("Error")
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let car = cars[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = car.value(forKeyPath: "model") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let car = cars[indexPath.row]

        let alert = UIAlertController(title: "Update Car", message: "Update Car", preferredStyle: .alert)
        

        alert.addTextField(configurationHandler: { (textFieldModel) in
            
            textFieldModel.placeholder = "model"
            
            textFieldModel.text = car.value(forKey: "model") as? String
            
        })
        
        alert.addTextField(configurationHandler: { (textFieldYear) in
            
            textFieldYear.placeholder = "year"
            textFieldYear.text = "\(car.value(forKey: "year") as? Int16 ?? 0)"
        })
        
        let updateAction = UIAlertAction(title: "Update", style: .default) { [unowned self] action in
            
            guard let textFieldModel = alert.textFields?[0],
                let modelToSave = textFieldModel.text
                else {
                    return
            }
            
            guard let textFieldYear = alert.textFields?[1],
                let yearToSave = textFieldYear.text
                else {
                    return
            }
            
            self.update(model: modelToSave, year: Int16(yearToSave)!, car: car)
            
            self.carsTableView.reloadData()
            
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { [unowned self] action in
            
            self.delete(car: car)
            
            self.cars.remove(at: (self.cars.firstIndex(of: car))!)
            
            self.carsTableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
    
}

