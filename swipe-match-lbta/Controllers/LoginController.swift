//
//  LoginController.swift
//  swipe-match-lbta
//
//  Created by Kārlis Bērziņš on 21/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol LoginControllerDelegate {
    func didFinishLoggingIn()
}

class LoginController: UIViewController {
    var delegate: LoginControllerDelegate?

    fileprivate let loginViewModel = LoginViewModel()
    fileprivate let loginHUD = JGProgressHUD(style: .dark)
    fileprivate let gradientLayer = CAGradientLayer()

    fileprivate let emailTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24, height: 50)
        textField.placeholder = "Enter email"
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)

        return textField
    }()

    fileprivate let passwordTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24, height: 50)
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)

        return textField
    }()

    fileprivate let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)

        return button
    }()

    fileprivate let backToRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)

        return button
    }()

    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            loginButton
        ])

        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradientLayer()
        setupLayout()
        setupBindables()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        gradientLayer.frame = view.bounds
    }

    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)

        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }

    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(verticalStackView)
        verticalStackView.anchor(top: nil,
                                 leading: view.leadingAnchor,
                                 bottom: nil,
                                 trailing: view.trailingAnchor,
                                 padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        view.addSubview(backToRegisterButton)
        backToRegisterButton.anchor(top: nil,
                                    leading: view.leadingAnchor,
                                    bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                    trailing: view.trailingAnchor)
    }

    fileprivate func setupBindables() {
        loginViewModel.isFormValid.bind { [unowned self] isFormValid in
            guard let isFormValid = isFormValid else { return }
            self.loginButton.isEnabled = isFormValid
            self.loginButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1) : .lightGray
            self.loginButton.setTitleColor(isFormValid ? .white : .gray, for: .normal)
        }

        loginViewModel.isLoggingIn.bind { [unowned self] isRegistering in
            if isRegistering == true {
                self.loginHUD.textLabel.text = "Logging in"
                self.loginHUD.show(in: self.view)
            } else {
                self.loginHUD.dismiss()
            }
        }
    }
}

extension LoginController {
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }

    @objc fileprivate func handleLogin() {
        loginViewModel.performLogin { [unowned self] error in
            self.loginHUD.dismiss()
            if let error = error {
                print("Failed to log in: ", error)
                return
            }

            self.dismiss(animated: true) {
                self.delegate?.didFinishLoggingIn()
            }
        }
    }

    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
