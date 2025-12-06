//
//  RecipeDetailViewController.swift
//  hungr
//
//  Recipe detail screen controller
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RecipeDetailViewController: UIViewController {
    
    let recipeDetailView = RecipeDetailView()
    
    let database = Firestore.firestore()
    
    var currentUser: FirebaseAuth.User?
    var recipeId: String?
    var recipeTitle: String?
    var cookbookId: String?
    
    var recipe: Recipe?
    
    override func loadView() {
        view = recipeDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = recipeTitle ?? "Recipe"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(onSaveTapped)
        )
        
        currentUser = Auth.auth().currentUser
        
        recipeDetailView.textViewIngredients.delegate = self
        recipeDetailView.textViewInstructions.delegate = self
        
        loadRecipeDetails()
    }
    
    func loadRecipeDetails() {
        guard let recipeId = recipeId else { return }
        
        database.collection("recipes").document(recipeId).getDocument { [weak self] document, error in
            if let error = error {
                print("Error loading recipe: \(error)")
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                return
            }
            
            let title = data["title"] as? String ?? ""
            let description = data["description"] as? String ?? ""
            let ingredients = data["ingredients"] as? [String] ?? []
            let instructions = data["instructions"] as? [String] ?? []
            let prepTime = data["prepTime"] as? Int ?? 0
            let cookTime = data["cookTime"] as? Int ?? 0
            let servings = data["servings"] as? Int ?? 0
            
            self?.recipe = Recipe(
                id: recipeId,
                title: title,
                description: description,
                ingredients: ingredients,
                instructions: instructions,
                prepTime: prepTime,
                cookTime: cookTime,
                servings: servings
            )
            
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    func updateUI() {
        guard let recipe = recipe else { return }
        
        recipeDetailView.textFieldTitle.text = recipe.title
        recipeDetailView.textViewDescription.text = recipe.description
        recipeDetailView.textFieldPrepTime.text = recipe.prepTime > 0 ? "\(recipe.prepTime)" : ""
        recipeDetailView.textFieldCookTime.text = recipe.cookTime > 0 ? "\(recipe.cookTime)" : ""
        recipeDetailView.textFieldServings.text = recipe.servings > 0 ? "\(recipe.servings)" : ""
        
        if !recipe.ingredients.isEmpty {
            recipeDetailView.textViewIngredients.text = recipe.ingredients.joined(separator: "\n")
            recipeDetailView.textViewIngredients.textColor = .label
        }
        
        if !recipe.instructions.isEmpty {
            recipeDetailView.textViewInstructions.text = recipe.instructions.joined(separator: "\n")
            recipeDetailView.textViewInstructions.textColor = .label
        }
    }
    
    @objc func onSaveTapped() {
        guard let recipeId = recipeId else { return }
        
        let title = recipeDetailView.textFieldTitle.text ?? ""
        let description = recipeDetailView.textViewDescription.text ?? ""
        let prepTime = Int(recipeDetailView.textFieldPrepTime.text ?? "") ?? 0
        let cookTime = Int(recipeDetailView.textFieldCookTime.text ?? "") ?? 0
        let servings = Int(recipeDetailView.textFieldServings.text ?? "") ?? 0
        
        var ingredients: [String] = []
        if recipeDetailView.textViewIngredients.textColor != .lightGray {
            ingredients = recipeDetailView.textViewIngredients.text
                .components(separatedBy: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
        
        var instructions: [String] = []
        if recipeDetailView.textViewInstructions.textColor != .lightGray {
            instructions = recipeDetailView.textViewInstructions.text
                .components(separatedBy: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
        
        guard !title.isEmpty, !description.isEmpty else {
            showAlert(title: "Error", message: "Title and description are required")
            return
        }
        
        let recipeData: [String: Any] = [
            "title": title,
            "description": description,
            "ingredients": ingredients,
            "instructions": instructions,
            "prepTime": prepTime,
            "cookTime": cookTime,
            "servings": servings,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        database.collection("recipes").document(recipeId).updateData(recipeData) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: "Failed to save recipe: \(error.localizedDescription)")
                return
            }
            
            let alert = UIAlertController(title: "Success", message: "Recipe saved!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self?.navigationController?.popViewController(animated: true)
            })
            self?.present(alert, animated: true)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension RecipeDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == recipeDetailView.textViewIngredients {
                textView.text = "Enter ingredients (one per line)"
                textView.textColor = .lightGray
            } else if textView == recipeDetailView.textViewInstructions {
                textView.text = "Enter instructions (one per line)"
                textView.textColor = .lightGray
            }
        }
    }
}

struct Recipe {
    let id: String
    let title: String
    let description: String
    let ingredients: [String]
    let instructions: [String]
    let prepTime: Int
    let cookTime: Int
    let servings: Int
}
