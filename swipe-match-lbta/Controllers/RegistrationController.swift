//
//  RegistrationController.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 05/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {

    // UI Components
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 272).isActive = true
        button.layer.cornerRadius = 16

        return button
    }()

    let fullNameTextField: CustomTextField = {
        let textField = CustomTextField(padding: 16)
        textField.placeholder = "Enter full name"
        textField.backgroundColor = .white

        return textField
    }()

    let emailTextField: CustomTextField = {
        let textField = CustomTextField(padding: 16)
        textField.placeholder = "Enter email"
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .white

        return textField
    }()

    let passwordTextField: CustomTextField = {
        let textField = CustomTextField(padding: 16)
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white

        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradientLayer()

        let stackView = UIStackView(arrangedSubviews: [
            selectPhotoButton,
            fullNameTextField,
            emailTextField,
            passwordTextField
        ])

        view.addSubview(stackView)

        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil,
                         leading: view.leadingAnchor,
                         bottom: nil,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 0, left: 48, bottom: 0, right: 48))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    fileprivate func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]

        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
}
