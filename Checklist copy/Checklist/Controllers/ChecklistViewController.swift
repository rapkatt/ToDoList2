//
//  ViewController.swift
//  Checklist
//
//  Created by Brian on 6/18/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var todoList: TodoList
    var searchList: [ChecklistItem] = []
    var searching = false
    var item: ChecklistItem?
    
    @IBAction func addItem(_ sender: Any) {
        performSegue(withIdentifier: "AddItemSegue", sender: nil)
    }
    @IBOutlet var menuButton:UIBarButtonItem!
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tbView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        todoList = TodoList()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchList.count
        }else{
            return todoList.todos.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        if searching {
            cell.textLabel?.text = searchList[indexPath.row].text
            let item = searchList[indexPath.row]
            
            if item.checked ?? false {
                cell.imageView?.image = UIImage(named: "image")
            }else{
                cell.imageView?.image = UIImage(named: "")
            }
            configureText(for: cell, with: item)
        }else{
            let item = todoList.todos[indexPath.row]
            
            if item.checked ?? false {
                cell.imageView?.image = UIImage(named: "image")
            }else{
                cell.imageView?.image = UIImage(named: "")
            }
            configureText(for: cell, with: item)
        }
        
        return cell
    }
    func cheaker(){
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = todoList.todos[indexPath.row]
        if searching {
            item = searchList[indexPath.row]
        }else{
            item = todoList.todos[indexPath.row]
        }
        item.toggleChecked()
        tableView.reloadData()
        saveData()
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        todoList.todos.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveData()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if searching {
            item = searchList[indexPath.row]
        }else{
            item = todoList.todos[indexPath.row]
        }
        performSegue(withIdentifier: "EditItemSegue", sender: nil)
    }
    

    
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        cell.textLabel?.text = item.text
        cell.detailTextLabel?.text = item.extraText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                itemDetailViewController.delegate = self
                itemDetailViewController.todoList = todoList
            }
        } else if segue.identifier == "EditItemSegue" {
            if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                    itemDetailViewController.itemToEdit = item
                    itemDetailViewController.delegate = self
            }
        }
    }
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
        saveData()
        
    }
    
    func saveData() {
        let placesData = NSKeyedArchiver.archivedData(withRootObject: todoList.todos)
        UserDefaults.standard.set(placesData, forKey: "SavedArray")
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = todoList.todos.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        saveData()
        navigationController?.popViewController(animated: true)
    }
    
    func loadData(){

        if let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "SavedArray") as! Data) as? [ChecklistItem] {
            todoList.todos = decodedArray
        }
        
        tableView.reloadData()
    }
}
extension ChecklistViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchList = todoList.todos.filter({$0.text!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
}

