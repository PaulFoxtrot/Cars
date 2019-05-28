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
        let alert = UIAlertController(title: "Новая машина", message: "Заполните все поля", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (nameTextField) in
            nameTextField.placeholder = "Имя"
        })
        alert.addTextField(configurationHandler: { (manufacturerTextField) in
            manufacturerTextField.placeholder = "Производитель"
        })
        alert.addTextField(configurationHandler: { (modelTextField) in
            modelTextField.placeholder = "Модель"
        })
        alert.addTextField(configurationHandler: { (clasTextField) in
            clasTextField.placeholder = "Класс"
        })
        alert.addTextField(configurationHandler: { (typeTextField) in
            typeTextField.placeholder = "Тип"
        })
        alert.addTextField(configurationHandler: { (yearTextField) in
            yearTextField.placeholder = "Год выпуска"
        })
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [unowned self] action in
            
            guard let nameTextField = alert.textFields?[0],
                let nameSave = nameTextField.text
                else {
                    return
            }
            guard let manufacturerTextField = alert.textFields?[1],
                let manufacturerSave = manufacturerTextField.text
                else {
                    return
            }
            guard let modelTextField = alert.textFields?[2],
                let modelSave = modelTextField.text
                else {
                    return
            }
            guard let clasTextField = alert.textFields?[3],
                let clasSave = clasTextField.text
                else {
                    return
            }
            guard let typeTextField = alert.textFields?[4],
                let typeSave = typeTextField.text
                else {
                    return
            }
            guard let yearTextField = alert.textFields?[5],
                let yearSave = yearTextField.text
                else {
                    return
            }
            // saving data
            self.save(name: nameSave, manufacturer: manufacturerSave, model: modelSave, clas: clasSave, type: typeSave, year: Int16(yearSave)!)
            self.carsTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    func save(name: String, manufacturer: String, model: String, clas: String, type: String, year: Int16) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Car", in: managedContext)!
        let car = NSManagedObject(entity: entity, insertInto: managedContext)
        
        car.setValue(name, forKeyPath: "Name")
        car.setValue(manufacturer, forKeyPath: "Manufacturer")
        car.setValue(model, forKeyPath: "Model")
        car.setValue(clas, forKeyPath: "Clas")
        car.setValue(type, forKeyPath: "Type")
        car.setValue(year, forKeyPath: "Year")
        
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
            else { return }
        
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
        carsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func update(name: String, manufacturer: String, model: String, clas: String, type: String, year: Int16, car: Car) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            car.setValue(name, forKeyPath: "Name")
            car.setValue(manufacturer, forKeyPath: "Manufacturer")
            car.setValue(model, forKeyPath: "Model")
            car.setValue(clas, forKeyPath: "Clas")
            car.setValue(type, forKeyPath: "Type")
            car.setValue(year, forKeyPath: "Year")
            
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
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = cars[indexPath.row].name
        
        cell.detailTextLabel?.text = String("\(cars[indexPath.row].manufacturer!), \(cars[indexPath.row].model!), \(cars[indexPath.row].clas!), \(cars[indexPath.row].type!), \(String(cars[indexPath.row].year))")
        
        return cell
    }
    // when user tap on a row — pop-up updating/deleting alert
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let car = cars[indexPath.row]
        let alert = UIAlertController(title: "Изменить данные", message: "Заполните все поля", preferredStyle: .alert)
        
        
        alert.addTextField(configurationHandler: { (nameTextField) in
            nameTextField.placeholder = "Имя"
            nameTextField.text = car.value(forKey: "Name") as? String
        })
        alert.addTextField(configurationHandler: { (manufacturerTextField) in
            manufacturerTextField.placeholder = "Производитель"
            manufacturerTextField.text = car.value(forKey: "Manufacturer") as? String
        })
        alert.addTextField(configurationHandler: { (modelTextField) in
            modelTextField.placeholder = "Модель"
            modelTextField.text = car.value(forKey: "Model") as? String
        })
        alert.addTextField(configurationHandler: { (clasTextField) in
            clasTextField.placeholder = "Класс"
            clasTextField.text = car.value(forKey: "Clas") as? String
        })
        alert.addTextField(configurationHandler: { (typeTextField) in
            typeTextField.placeholder = "Тип"
            typeTextField.text = car.value(forKey: "Type") as? String
        })
        alert.addTextField(configurationHandler: { (yearTextField) in
            yearTextField.placeholder = "Год выпуска"
            yearTextField.text = "\(car.value(forKey: "Year") as? Int16 ?? 0)"
        })
        
        let updateAction = UIAlertAction(title: "Изменить", style: .default) { [unowned self] action in
            
            guard let nameTextField = alert.textFields?[0],
                let nameSave = nameTextField.text
                else { return }
            guard let manufacturerTextField = alert.textFields?[1],
                let manufacturerSave = manufacturerTextField.text
                else { return }
            guard let modelTextField = alert.textFields?[2],
                let modelSave = modelTextField.text
                else { return }
            guard let yearTextField = alert.textFields?[3],
                let yearSave = yearTextField.text
                else { return }
            guard let clasTextField = alert.textFields?[4],
                let clasSave = clasTextField.text
                else { return }
            guard let typeTextField = alert.textFields?[5],
                let typeSave = typeTextField.text
                else { return }
            
            self.update(name: nameSave, manufacturer: manufacturerSave, model: modelSave, clas: clasSave, type: typeSave, year: Int16(yearSave)!, car: car)
            
            self.carsTableView.reloadData()
        }
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .default) { [unowned self] action in
            
            self.delete(car: car)
            self.cars.remove(at: (self.cars.firstIndex(of: car))!)
            self.carsTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        
        alert.addAction(updateAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}

