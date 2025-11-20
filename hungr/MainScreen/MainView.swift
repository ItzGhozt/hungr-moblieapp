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
    var buttonCamera: UIButton!
    var buttonProfile: UIButton!
    var buttonFridge: UIButton!
    var buttonPantry: UIButton!
    var buttonFreezer: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupImageView()
        setupGetStartedButton()
        setupFridgeButton()
        setupPantryButton()
        setupFreezerButton()
        setupCameraButton()
        setupProfileButton()
        
        initConstraints()
    }
    
    func setupImageView() {
        imageViewHome = UIImageView()
        imageViewHome.contentMode = .scaleAspectFit // Changed to fit - shows entire image
        imageViewHome.clipsToBounds = true
        imageViewHome.image = UIImage(named: "home_image")
        imageViewHome.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageViewHome)
    }
    
    func setupCameraButton() {
        buttonCamera = UIButton(type: .system)
        buttonCamera.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        buttonCamera.tintColor = .systemBlue
        buttonCamera.backgroundColor = .white.withAlphaComponent(0.9)
        buttonCamera.layer.cornerRadius = 25
        buttonCamera.layer.shadowColor = UIColor.black.cgColor
        buttonCamera.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonCamera.layer.shadowRadius = 4
        buttonCamera.layer.shadowOpacity = 0.2
        buttonCamera.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonCamera)
    }
    
    func setupProfileButton() {
        buttonProfile = UIButton(type: .system)
        buttonProfile.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        buttonProfile.tintColor = .systemBlue
        buttonProfile.backgroundColor = .white.withAlphaComponent(0.9)
        buttonProfile.layer.cornerRadius = 25
        buttonProfile.layer.shadowColor = UIColor.black.cgColor
        buttonProfile.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonProfile.layer.shadowRadius = 4
        buttonProfile.layer.shadowOpacity = 0.2
        buttonProfile.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonProfile)
    }
    
    func setupGetStartedButton() {
        buttonGetStarted = UIButton(type: .system)
        buttonGetStarted.setTitle("Get Started", for: .normal)
        buttonGetStarted.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonGetStarted.backgroundColor = .systemBlue
        buttonGetStarted.setTitleColor(.white, for: .normal)
        buttonGetStarted.layer.cornerRadius = 12
        buttonGetStarted.layer.shadowColor = UIColor.black.cgColor
        buttonGetStarted.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonGetStarted.layer.shadowRadius = 4
        buttonGetStarted.layer.shadowOpacity = 0.2
        buttonGetStarted.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonGetStarted)
    }
    
    func setupFridgeButton() {
        buttonFridge = UIButton(type: .system)
        buttonFridge.setTitle("Fridge", for: .normal)
        buttonFridge.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonFridge.backgroundColor = .systemBlue.withAlphaComponent(0.9)
        buttonFridge.setTitleColor(.white, for: .normal)
        buttonFridge.layer.cornerRadius = 12
        buttonFridge.layer.shadowColor = UIColor.black.cgColor
        buttonFridge.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonFridge.layer.shadowRadius = 4
        buttonFridge.layer.shadowOpacity = 0.2
        buttonFridge.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonFridge)
    }
    
    func setupPantryButton() {
        buttonPantry = UIButton(type: .system)
        buttonPantry.setTitle("Pantry", for: .normal)
        buttonPantry.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonPantry.backgroundColor = .systemBlue.withAlphaComponent(0.9)
        buttonPantry.setTitleColor(.white, for: .normal)
        buttonPantry.layer.cornerRadius = 12
        buttonPantry.layer.shadowColor = UIColor.black.cgColor
        buttonPantry.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonPantry.layer.shadowRadius = 4
        buttonPantry.layer.shadowOpacity = 0.2
        buttonPantry.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonPantry)
    }
    
    func setupFreezerButton() {
        buttonFreezer = UIButton(type: .system)
        buttonFreezer.setTitle("Freezer", for: .normal)
        buttonFreezer.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonFreezer.backgroundColor = .systemBlue.withAlphaComponent(0.9)
        buttonFreezer.setTitleColor(.white, for: .normal)
        buttonFreezer.layer.cornerRadius = 12
        buttonFreezer.layer.shadowColor = UIColor.black.cgColor
        buttonFreezer.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonFreezer.layer.shadowRadius = 4
        buttonFreezer.layer.shadowOpacity = 0.2
        buttonFreezer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonFreezer)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Background Image - FULL SCREEN but maintains aspect ratio
            imageViewHome.topAnchor.constraint(equalTo: self.topAnchor),
            imageViewHome.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageViewHome.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageViewHome.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // Camera Button - TOP LEFT CORNER (Brought to front with higher z-index)
            buttonCamera.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            buttonCamera.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            buttonCamera.widthAnchor.constraint(equalToConstant: 50),
            buttonCamera.heightAnchor.constraint(equalToConstant: 50),
            
            // Profile Button - TOP RIGHT CORNER (Brought to front with higher z-index)
            buttonProfile.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            buttonProfile.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            buttonProfile.widthAnchor.constraint(equalToConstant: 50),
            buttonProfile.heightAnchor.constraint(equalToConstant: 50),
            
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
            buttonGetStarted.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),            buttonGetStarted.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
