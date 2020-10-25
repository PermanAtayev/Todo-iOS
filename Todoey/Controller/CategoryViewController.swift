//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Perman Atayev on 26.09.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    var categories : Results<Category>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add a Category", message: "", preferredStyle: .alert)
        var categoryName = UITextField()
        
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter a category"
            categoryName = textField
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
            let newCategory = Category()
            newCategory.name = categoryName.text!
            self.save(newCategory)
        }))
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func loadData(){
        categories = realm.objects(Category.self)
        self.tableView.reloadData()
    }
    
    func save(_ category: Category){
        do{
            try realm.write {
                  realm.add(category)
              }
        }
        catch{
            print("Error: ", error)
        }
        self.tableView.reloadData()
    }
    
}

extension CategoryViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
       
        cell.textLabel!.text = categories?[indexPath.row].name ?? "No categories added yet"
           
       return cell
    }
}

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        destinationVC.selectedCategory = categories![tableView.indexPathForSelectedRow!.row]
    }
    
    
    
}
