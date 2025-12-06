//
//  PantryViewController.swift
//  hungr
//
//  Pantry screen controller
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PantryViewController: UIViewController {
    
    let pantryView = PantryView()
    
    let database = Firestore.firestore()
    
    var currentUser: FirebaseAuth.User?
    
    var items: [(id: String, name: String, quantity: String, expiryDate: String?)] = []
    
    override func loadView() {
        view = pantryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HelpButtonHelper.addHelpButton(to: self, message: HelpButtonHelper.pantryHelp)

        
        title = "Pantry"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onAddItemTapped)
        )
        
        currentUser = Auth.auth().currentUser
        
        pantryView.tableViewItems.delegate = self
        pantryView.tableViewItems.dataSource = self
        
        loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItems()
    }
    
    @objc func onAddItemTapped() {
        let alert = UIAlertController(
            title: "Add Pantry Item",
            message: "Enter item details",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Item Name"
            textField.autocapitalizationType = .words
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Quantity (e.g., 3 cans, 1 box)"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Expiry Date (optional)"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let name = alert.textFields?[0].text, !name.isEmpty,
                  let quantity = alert.textFields?[1].text, !quantity.isEmpty else {
                self?.showAlert(title: "Error", message: "Please enter item name and quantity")
                return
            }
            
            let expiryDate = alert.textFields?[2].text
            self?.createItem(name: name, quantity: quantity, expiryDate: expiryDate)
        })
        
        present(alert, animated: true)
    }
    
    func createItem(name: String, quantity: String, expiryDate: String?) {
        guard let userId = currentUser?.uid else {
            showAlert(title: "Error", message: "Unable to add item")
            return
        }
        
        let docRef = database.collection("pantry_items").document()
        let itemId = docRef.documentID
        
        var itemData: [String: Any] = [
            "name": name,
            "quantity": quantity,
            "userId": userId,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        if let expiryDate = expiryDate, !expiryDate.isEmpty {
            itemData["expiryDate"] = expiryDate
        }
        
        docRef.setData(itemData) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: "Failed to add item: \(error.localizedDescription)")
                return
            }
            
            self?.loadItems()
        }
    }
    
    func loadItems() {
        guard let userId = currentUser?.uid else { return }
        
        database.collection("pantry_items")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error loading items: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                self?.items.removeAll()
                
                for document in documents {
                    let data = document.data()
                    let id = document.documentID
                    let name = data["name"] as? String ?? "Untitled"
                    let quantity = data["quantity"] as? String ?? ""
                    let expiryDate = data["expiryDate"] as? String
                    
                    self?.items.append((id: id, name: name, quantity: quantity, expiryDate: expiryDate))
                }
                
                DispatchQueue.main.async {
                    self?.pantryView.tableViewItems.reloadData()
                }
            }
    }
    
    func deleteItem(itemId: String) {
        let alert = UIAlertController(
            title: "Delete Item",
            message: "Are you sure you want to delete this item?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.database.collection("pantry_items").document(itemId).delete { error in
                if let error = error {
                    self?.showAlert(title: "Error", message: "Failed to delete item: \(error.localizedDescription)")
                    return
                }
                
                self?.loadItems()
            }
        })
        
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension PantryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pantryItem", for: indexPath) as! PantryItemTableViewCell
        let item = items[indexPath.row]
        
        cell.labelItemName.text = item.name
        cell.labelQuantity.text = item.quantity
        
        if let expiryDate = item.expiryDate {
            cell.labelExpiryDate.text = "Expires: \(expiryDate)"
            cell.labelExpiryDate.isHidden = false
        } else {
            cell.labelExpiryDate.isHidden = true
        }
        
        cell.itemId = item.id
        cell.delegate = self
        
        return cell
    }
}

extension PantryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension PantryViewController: PantryItemTableViewCellDelegate {
    func deleteButtonTapped(for itemId: String) {
        deleteItem(itemId: itemId)
    }
}
