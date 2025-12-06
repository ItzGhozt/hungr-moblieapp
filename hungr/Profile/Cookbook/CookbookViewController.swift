//
//  CookbookViewController.swift
//  hungr
//
//  Cookbook screen controller
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CookbookViewController: UIViewController {
    
    let cookbookView = CookbookView()
    
    let database = Firestore.firestore()
    
    var currentUser: FirebaseAuth.User?
    var cookbookId: String?
    var cookbookName: String?
    
    var recipes: [(id: String, title: String, description: String)] = []
    
    override func loadView() {
        view = cookbookView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HelpButtonHelper.addHelpButton(to: self, message: HelpButtonHelper.cookbookHelp)

        
        title = cookbookName ?? "Cookbook"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add button to add new recipe
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onAddRecipeTapped)
        )
        
        currentUser = Auth.auth().currentUser
        
        // Update the cookbook title in the view
        cookbookView.updateCookbookTitle(cookbookName ?? "My Cookbook")
        
        // Set up table view
        cookbookView.tableViewRecipes.delegate = self
        cookbookView.tableViewRecipes.dataSource = self
        
        // Load recipes for this cookbook
        loadRecipes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload recipes when coming back from detail view
        loadRecipes()
    }
    
    
    
    
    @objc func onAddRecipeTapped() {
        let alert = UIAlertController(
            title: "New Recipe",
            message: "Enter recipe details",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Recipe Title"
            textField.autocapitalizationType = .words
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Description"
            textField.autocapitalizationType = .sentences
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            guard let title = alert.textFields?[0].text, !title.isEmpty,
                  let description = alert.textFields?[1].text, !description.isEmpty else {
                self?.showAlert(title: "Error", message: "Please enter both title and description")
                return
            }
            
            self?.createRecipe(title: title, description: description)
        })
        
        present(alert, animated: true)
    }
    
    func createRecipe(title: String, description: String) {
        guard let cookbookId = cookbookId,
              let userId = currentUser?.uid else {
            showAlert(title: "Error", message: "Unable to create recipe")
            return
        }
        
        // Create a new document reference to get the ID
        let docRef = database.collection("recipes").document()
        let recipeId = docRef.documentID
        
        let recipeData: [String: Any] = [
            "title": title,
            "description": description,
            "ingredients": [],
            "instructions": [],
            "prepTime": 0,
            "cookTime": 0,
            "servings": 0,
            "cookbookId": cookbookId,
            "userId": userId,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        docRef.setData(recipeData) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: "Failed to create recipe: \(error.localizedDescription)")
                return
            }
            
            // Reload recipes from Firestore
            self?.loadRecipes()
        }
    }
    
    func loadRecipes() {
        guard let cookbookId = cookbookId else { return }
        
        database.collection("recipes")
            .whereField("cookbookId", isEqualTo: cookbookId)
            
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error loading recipes: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                // Clear existing recipes
                self?.recipes.removeAll()
                
                // Add each recipe
                for document in documents {
                    let data = document.data()
                    let id = document.documentID
                    let title = data["title"] as? String ?? "Untitled"
                    let description = data["description"] as? String ?? ""
                    
                    self?.recipes.append((id: id, title: title, description: description))
                }
                
                // Reload table view on main thread
                DispatchQueue.main.async {
                    self?.cookbookView.tableViewRecipes.reloadData()
                }
            }
    }
    
    func deleteRecipe(recipeId: String) {
        let alert = UIAlertController(
            title: "Delete Recipe",
            message: "Are you sure you want to delete this recipe?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.database.collection("recipes").document(recipeId).delete { error in
                if let error = error {
                    self?.showAlert(title: "Error", message: "Failed to delete recipe: \(error.localizedDescription)")
                    return
                }
                
                // Reload recipes after delete
                self?.loadRecipes()
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

// MARK: - Table View Data Source
extension CookbookViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipe", for: indexPath) as! RecipeTableViewCell
        let recipe = recipes[indexPath.row]
        
        cell.labelRecipeTitle.text = recipe.title
        cell.labelRecipeDescription.text = recipe.description
        cell.recipeId = recipe.id
        cell.delegate = self
        
        return cell
    }
}

// MARK: - Table View Delegate
extension CookbookViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let recipe = recipes[indexPath.row]
        
        // Navigate to recipe detail view
        let recipeDetailVC = RecipeDetailViewController()
        recipeDetailVC.recipeId = recipe.id
        recipeDetailVC.recipeTitle = recipe.title
        recipeDetailVC.cookbookId = cookbookId
        navigationController?.pushViewController(recipeDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Recipe Cell Delegate
extension CookbookViewController: RecipeTableViewCellDelegate {
    func deleteButtonTapped(for recipeId: String) {
        deleteRecipe(recipeId: recipeId)
    }
}
