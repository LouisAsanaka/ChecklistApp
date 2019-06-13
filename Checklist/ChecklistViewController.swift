//
//  ChecklistViewController.swift
//  Checklist
//
//  Created by Louis on 2019/6/9.
//  Copyright © 2019 Louis. All rights reserved.
//

import UIKit
import CoreData

class ChecklistViewController: UITableViewController {
    
    let todos: TodoList
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            var items = [ChecklistItem]()
            for indexPath in selectedRows {
                if let item = todos.getItem(at: indexPath.row) {
                    items.append(item)
                }
            }
            todos.removeItems(items)
            tableView.deleteRows(at: selectedRows, with: .automatic)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        todos = TodoList()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            var arr = [ChecklistItem?](repeating: nil, count: result.count)
            print("Loading \(result.count) saved tasks...")
            for data in result as! [NSManagedObject] {
                let index: Int = data.value(forKey: "index") as! Int
                arr[index] = ChecklistItem(
                    text: data.value(forKey: "title") as! String,
                    checked: data.value(forKey: "checked") as! Bool
                )
            }
            todos.todos = arr as! [ChecklistItem]
        } catch {
            print("Failed")
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(tableView.isEditing, animated: animated)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.getItemCount()
    }
    
    override func tableView(_ tableView : UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        if let item = todos.getItem(at: indexPath.row) {
            configureText(cell, with: item)
            configureCheckmark(cell, with: item)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.isEditing) {
            return
        }
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        if let item = todos.getItem(at: indexPath.row) {
            item.toggleChecked()
            configureCheckmark(cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        todos.removeItem(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let item = todos.getItem(at: sourceIndexPath.row) else {
            return
        }
        todos.move(item: item, to: destinationIndexPath.row)
    }
    
    func configureText(_ cell: UITableViewCell, with item: ChecklistItem) {
        guard let textCell = cell as? ChecklistTableViewCell else {
            return
        }
        textCell.todoTextLabel.text = item.text
    }
    
    func configureCheckmark(_ cell: UITableViewCell, with item: ChecklistItem) {
        guard let checkmarkCell = cell as? ChecklistTableViewCell else {
            return
        }
        if item.checked {
            checkmarkCell.checkmarkLabel.text = "✔️"
        } else {
            checkmarkCell.checkmarkLabel.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                itemDetailViewController.delegate = self
                itemDetailViewController.todos = todos
            }
        } else if segue.identifier == "EditItemSegue" {
            if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell) {
                    
                    let item = todos.getItem(at: indexPath.row)
                    itemDetailViewController.itemToEdit = item
                    itemDetailViewController.delegate = self
                }
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
        let rowIndex = todos.getItemCount()
        todos.addItem(item)
        
        let indexPath = IndexPath(row: rowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = todos.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

