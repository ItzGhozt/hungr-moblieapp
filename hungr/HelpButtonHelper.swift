//
//  HelpButtonHelper.swift
//  hungr
//
//  Helper to add info/help buttons to screens
//

import UIKit

class HelpButtonHelper {
    
    static func addHelpButton(to viewController: UIViewController, message: String) {
        let helpButton = UIButton(type: .custom)
        helpButton.setImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)
        helpButton.tintColor = .systemGray
        helpButton.translatesAutoresizingMaskIntoConstraints = false
        helpButton.alpha = 0.6
        
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        helpButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        
        helpButton.addAction(UIAction { _ in
            showHelpAlert(on: viewController, message: message)
        }, for: .touchUpInside)
        
        viewController.view.addSubview(helpButton)
        
        NSLayoutConstraint.activate([
            helpButton.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            helpButton.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -24),
            helpButton.widthAnchor.constraint(equalToConstant: 80),
            helpButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private static func showHelpAlert(on viewController: UIViewController, message: String) {
        let alert = UIAlertController(
            title: "ℹ️ Screen Guide",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Got it!", style: .default))
        
        viewController.present(alert, animated: true)
    }
}

extension HelpButtonHelper {
    
    static let profileHelp = """
    📚 Profile Screen
    
    • Tap any cookbook to open it
    • Tap "+" to create a new cookbook
    • Tap "Edit" to delete cookbooks
    • Tap "Logout" to sign out
    """
    
    static let cookbookHelp = """
    📖 Cookbook Screen
    
    • Tap "+" to add a new recipe
    • Tap any recipe to view/edit details
    • Tap trash icon to delete a recipe
    """
    
    static let recipeDetailHelp = """
    🍳 Recipe Details
    
    • Edit any field to update the recipe
    • Add ingredients (one per line)
    • Add instructions (one per line)
    • Tap "Save" to keep your changes
    """
    
    static let freezerHelp = """
    ❄️ Fridge Screen
    
    • Tap "+" to add fridge items
    • Enter item name and quantity
    • Optionally add expiry date
    • Tap trash icon to remove items
    """
    
    static let fridgeHelp = """
    🧊 Freezer Screen
    
    • Tap "+" to add freezer items
    • Enter item name and quantity
    • Optionally add expiry date
    • Tap trash icon to remove items
    """
    
    static let pantryHelp = """
    🥫 Pantry Screen
    
    • Tap "+" to add pantry items
    • Enter item name and quantity
    • Optionally add expiry date
    • Tap trash icon to remove items
    """
    
    static let homeHelp = """
    🏠 Home Screen
    
    • Tap the profile icon to view cookbooks 
    • Tap camera to scan receipts 
    • Tap the freezer/fridge to view items
    • Tap the pantry to view items
    """
}
