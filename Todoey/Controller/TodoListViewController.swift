
import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!

    var selectedCategory: Category? {
        didSet{
            loadData()
        }
    }
    let realm = try! Realm()
    var items : Results<Item>?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addButtonIsPressed(_ sender: Any) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add item", style: .default) { (action)
            in

            do{
                try self.realm.write(){
                    let newItem = Item()
                    newItem.title =  textField.text!
                    newItem.dateCreated = Date();
                    self.selectedCategory!.items.append(newItem)
                }
            }
            catch{
                print("Error: ", error)
            }

            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)

        self.present(alert, animated: true)
    }
    
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }

    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.accessoryType = items![indexPath.row].done ? .checkmark : .none
        cell.textLabel!.text = items![indexPath.row].title
           
       return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            try! realm.write{
                item.done = !item.done
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

    
    func loadData(){
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

}

extension TodoListViewController: UISearchBarDelegate{
    func loadDataFromSearchBar(){
        let input = searchBar.text!
        items = items!.filter("title CONTAINS[cd] %@", input).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadDataFromSearchBar()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if the search bar is emptied
        if searchBar.text!.count > 0{
            loadDataFromSearchBar()
        }
        else{
            
            loadData()
        }
        tableView.reloadData()
    }
}


