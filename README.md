# hungr

A comprehensive iOS recipe and food inventory management application built with Swift and Firebase.

## Overview

hungr is a mobile application designed to help users organize their recipes, manage their kitchen inventory, and streamline meal planning. The app provides an intuitive interface for creating digital cookbooks, tracking food items across different storage locations, and managing recipe details.

## Features

### User Authentication
- Secure user registration and login using Firebase Authentication
- Profile management with customizable profile pictures
- User-specific data storage and retrieval

### Recipe Management
- Create and organize multiple cookbooks
- Add recipes with detailed information including:
  - Recipe title and description
  - Ingredients list
  - Step-by-step instructions
  - Preparation and cooking times
  - Serving sizes
- Edit and update existing recipes
- Delete recipes and cookbooks
- Visual cookbook organization with color-coded icons

### Food Inventory Tracking
The app includes three separate inventory management sections:

**Freezer**
- Track frozen food items
- Record item names, quantities, and expiry dates
- Add and remove items as needed

**Fridge**
- Manage refrigerated items
- Monitor quantities and expiration dates
- Keep track of perishable goods

**Pantry**
- Organize dry goods and pantry staples
- Track quantities and shelf life
- Maintain a complete pantry inventory

### User Interface
- Clean, intuitive design with custom background images
- Context-sensitive help buttons throughout the app
- Easy navigation between different sections
- Visual feedback for all user interactions

## Technical Stack

### Frontend
- **Language**: Swift
- **UI Framework**: UIKit (programmatic UI, no storyboards)
- **Architecture**: MVC (Model-View-Controller)

### Backend
- **Authentication**: Firebase Authentication
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage (for profile images)

### Key Technologies
- Auto Layout for responsive UI design
- UIImagePickerController for photo selection
- URLSession for image downloading
- Base64 encoding for profile image storage

## Project Structure

```
hungr/
├── Login-Register/
│   ├── LoginView.swift
│   ├── LoginViewController.swift
│   ├── RegisterView.swift
│   └── RegisterViewController.swift
├── MainScreen/
│   ├── MainView.swift
│   └── MainViewController.swift
├── Profile/
│   ├── ProfileView.swift
│   ├── ProfileViewController.swift
│   └── Cookbook/
│       ├── CookbookView.swift
│       ├── CookbookViewController.swift
│       └── Recipe/
│           ├── RecipeDetailView.swift
│           ├── RecipeDetailViewController.swift
│           └── RecipeTableViewCell.swift
├── Freezer/
│   ├── FreezerView.swift
│   ├── FreezerViewController.swift
│   └── FreezerItemTableViewCell.swift
├── Fridge/
│   ├── FridgeView.swift
│   ├── FridgeViewController.swift
│   └── FridgeItemTableViewCell.swift
├── Pantry/
│   ├── PantryView.swift
│   ├── PantryViewController.swift
│   └── PantryItemTableViewCell.swift
└── HelpButtonHelper.swift
```

## Database Schema

### Collections

**users**
- userId (document ID)
- name: String
- email: String
- profileImage: String (base64 encoded)

**cookbooks**
- cookbookId (document ID)
- name: String
- color: String
- userId: String
- createdAt: Timestamp

**recipes**
- recipeId (document ID)
- title: String
- description: String
- ingredients: Array of Strings
- instructions: Array of Strings
- prepTime: Integer
- cookTime: Integer
- servings: Integer
- cookbookId: String
- userId: String
- createdAt: Timestamp

**freezer_items**
- itemId (document ID)
- name: String
- quantity: String
- expiryDate: String (optional)
- userId: String
- createdAt: Timestamp

**fridge_items**
- itemId (document ID)
- name: String
- quantity: String
- expiryDate: String (optional)
- userId: String
- createdAt: Timestamp

**pantry_items**
- itemId (document ID)
- name: String
- quantity: String
- expiryDate: String (optional)
- userId: String
- createdAt: Timestamp

## Setup Instructions

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0 or later
- CocoaPods or Swift Package Manager
- Firebase account

### Firebase Configuration

1. Create a new Firebase project at https://console.firebase.google.com
2. Add an iOS app to your Firebase project
3. Download the `GoogleService-Info.plist` file
4. Add the file to your Xcode project

### Dependencies

Add the following Firebase dependencies to your project:

```swift
dependencies: [
    .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.0.0")
]
```

Required Firebase modules:
- FirebaseAuth
- FirebaseFirestore
- FirebaseStorage

### Installation

1. Clone the repository
2. Open the project in Xcode
3. Add your `GoogleService-Info.plist` file
4. Install dependencies using Swift Package Manager or CocoaPods
5. Build and run the project

### Firebase Setup

1. Enable Email/Password authentication in Firebase Console
2. Create a Firestore database in production mode
3. Enable Firebase Storage
4. Set up the following Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /cookbooks/{cookbookId} {
      allow read, write: if request.auth != null;
    }
    
    match /recipes/{recipeId} {
      allow read, write: if request.auth != null;
    }
    
    match /{collection}_items/{itemId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Usage

### Getting Started
1. Launch the app and tap "Get Started"
2. Register a new account or log in with existing credentials
3. Complete your profile by adding a profile picture

### Managing Cookbooks
1. Navigate to the Profile section
2. Tap the plus button to create a new cookbook
3. Enter a cookbook name
4. Tap any cookbook to view its recipes

### Adding Recipes
1. Open a cookbook
2. Tap the plus button in the navigation bar
3. Enter recipe title and description
4. Edit the recipe to add detailed ingredients and instructions
5. Save your changes

### Managing Inventory
1. Navigate to Freezer, Fridge, or Pantry from the home screen
2. Tap the plus button to add items
3. Enter item name, quantity, and optional expiry date
4. Tap the trash icon to remove items

### Help System
- Each screen features a help button in the bottom right corner
- Tap the help button to see screen-specific instructions
- Help buttons are only visible when logged in

## Features in Development

- Recipe search and filtering
- Meal planning calendar
- Shopping list generation from recipes
- Recipe sharing between users
- Barcode scanning for inventory management
- Nutrition information tracking
- Recipe ratings and reviews

## Known Issues

- Firestore queries require composite indexes for ordering operations
- Profile images are stored as base64 strings (consider migrating to Firebase Storage URLs for better performance)
- Help buttons persist across view controller transitions in some cases

## Contributing

This is an academic project. Contributions are not currently being accepted.

## License

This project is developed as part of a mobile application development course.

## Authors

Developed by Isabel Yeow as part of the Khoury College of Computer Sciences curriculum at Northeastern University.

## Acknowledgments

- Firebase documentation and SDKs
- UIKit framework documentation
- iOS Human Interface Guidelines
