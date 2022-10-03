//
//  ViewController.swift
//  2Do
//
//  Created by Aaranan Sathiendran on 2022-10-02.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource { //ViewController conforms to UITableViewDataSource which provides methods for managing data and providing cells for table view

    //Create TableView component to show list of to do items
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? [] //Set items to the contents saved in the array ; if that array cannot be found it is set to be empty
        title = "To Do List"
        view.addSubview(table)
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd)) //Initialize plus button for adding new entries
    }
    //Handles alert for when plus button is clicked
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter new to do list item",
                                      preferredStyle: .alert)
        alert.addTextField {field in
            field.placeholder = "Enter item..." //Add text field
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) //Add cancel button
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] //Add done button
            (_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    
                    //Enter new to do list item
                    DispatchQueue.main.async {
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items")
                        ?? [] //Add new entry to current entry items
                        currentItems.append(text)
                        UserDefaults.standard.setValue(currentItems, forKey: "items")
                        self?.items.append(text)
                        self?.table.reloadData() //Append to items and reload table data
                    }
                }
            }
        }))
        
        
        
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count //Number of rows in array of items
    }
    
    /*
     Creates a cell with the ID "cell" (String used to register it) and sets the text of that cell to the nth item of the array
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

}

