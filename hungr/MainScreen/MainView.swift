//
//  MainView.swift
//  hungr
//
//  Home page UI with image
//

import UIKit

class MainView: UIView {
    
    var imageViewHome: UIImageView!
    var buttonGetStarted: UIButton!
    var labelWelcome: UILabel!
    var buttonCamera: UIButton!
    var buttonProfile: UIButton!
    var buttonFridge: UIButton!
    var buttonPantry: UIButton!
    var buttonFreezer: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupImageView()
        setupCameraButton()
        setupProfileButton()
        setupImageView()
        setupWelcomeLabel()
        setupGetStartedButton()
        setupFridgeButton()
        setupPantryButton()
        setupFreezerButton()
        
        initConstraints()
    }
    
    func setupImageView() {
           imageViewHome = UIImageView()
           imageViewHome.contentMode = .scaleAspectFill // Fill the entire screen
           imageViewHome.clipsToBounds = true
           imageViewHome.image = UIImage(named: "home_image") // Your drawn image
           imageViewHome.translatesAutoresizingMaskIntoConstraints = false
           self.addSubview(imageViewHome)
       }
    
    func setupCameraButton() {
        buttonCamera = UIButton(type: .system)
        buttonCamera.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        buttonCamera.tintColor = .systemBlue
        buttonCamera.backgroundColor = .systemGray6
        buttonCamera.layer.cornerRadius = 25
        buttonCamera.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonCamera)
    }
    
    func setupProfileButton() {
        buttonProfile = UIButton(type: .system)
        buttonProfile.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        buttonProfile.tintColor = .systemBlue
        buttonProfile.backgroundColor = .systemGray6
        buttonProfile.layer.cornerRadius = 25
        buttonProfile.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonProfile)
    }
    
    
    func setupWelcomeLabel() {
        labelWelcome = UILabel()
        labelWelcome.text = "Welcome to hungr!"
        labelWelcome.font = UIFont.boldSystemFont(ofSize: 28)
        labelWelcome.textAlignment = .center
        labelWelcome.numberOfLines = 0
        labelWelcome.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelWelcome)
    }
    
    func setupGetStartedButton() {
        buttonGetStarted = UIButton(type: .system)
        buttonGetStarted.setTitle("Get Started", for: .normal)
        buttonGetStarted.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonGetStarted.backgroundColor = .systemBlue
        buttonGetStarted.setTitleColor(.white, for: .normal)
        buttonGetStarted.layer.cornerRadius = 12
        buttonGetStarted.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonGetStarted)
    }
    
    func setupFridgeButton() {
        buttonFridge = UIButton(type: .system)
        buttonFridge.setTitle("Fridge", for: .normal)
        buttonFridge.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonFridge.backgroundColor = .systemBlue
        buttonFridge.setTitleColor(.white, for: .normal)
        buttonFridge.layer.cornerRadius = 12
        buttonFridge.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonFridge)
    }
    
    func setupPantryButton() {
        buttonPantry = UIButton(type: .system)
        buttonPantry.setTitle("Pantry", for: .normal)
        buttonPantry.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonPantry.backgroundColor = .systemBlue
        buttonPantry.setTitleColor(.white, for: .normal)
        buttonPantry.layer.cornerRadius = 12
        buttonPantry.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonPantry)
    }
    
    func setupFreezerButton() {
        buttonFreezer = UIButton(type: .system)
        buttonFreezer.setTitle("Freezer", for: .normal)
        buttonFreezer.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonFreezer.backgroundColor = .systemBlue
        buttonFreezer.setTitleColor(.white, for: .normal)
        buttonFreezer.layer.cornerRadius = 12
        buttonFreezer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonFreezer)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            //back image
            imageViewHome.topAnchor.constraint(equalTo: self.topAnchor),
                   imageViewHome.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                   imageViewHome.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                   imageViewHome.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // Camera Button - TOP LEFT CORNER
            buttonCamera.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 4),
            buttonCamera.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            buttonCamera.widthAnchor.constraint(equalToConstant: 50),
            buttonCamera.heightAnchor.constraint(equalToConstant: 50),
            
            // Profile Button - TOP RIGHT CORNER
            buttonProfile.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 4),
            buttonProfile.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            buttonProfile.widthAnchor.constraint(equalToConstant: 50),
            buttonProfile.heightAnchor.constraint(equalToConstant: 50),
            
            // Welcome Label - higher up on screen
            labelWelcome.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 80),
            labelWelcome.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            labelWelcome.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            
            // Home Image - centered
            imageViewHome.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageViewHome.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -40),
            imageViewHome.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            imageViewHome.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            imageViewHome.heightAnchor.constraint(equalTo: imageViewHome.widthAnchor, multiplier: 0.8),
            
            // Fridge Button
            buttonFridge.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -140),
            buttonFridge.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            buttonFridge.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            buttonFridge.heightAnchor.constraint(equalToConstant: 56),
            
            // Pantry Button
            buttonPantry.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -76),
            buttonPantry.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            buttonPantry.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            buttonPantry.heightAnchor.constraint(equalToConstant: 56),
            
            // Freezer Button
            buttonFreezer.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            buttonFreezer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            buttonFreezer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            buttonFreezer.heightAnchor.constraint(equalToConstant: 56),
            
            // Get Started Button - centered at bottom (only visible when logged out)
            buttonGetStarted.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            buttonGetStarted.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            buttonGetStarted.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            buttonGetStarted.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
