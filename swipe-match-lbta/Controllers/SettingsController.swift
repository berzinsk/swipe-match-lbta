//
//  SettingsController.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 11/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUi()
        setupNavigationItems()
    }

    fileprivate func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.clipsToBounds = true

        return button
    }

    fileprivate func setupUi() {
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
    }

    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleCancel)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
}

extension SettingsController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let padding: CGFloat = 16

        header.addSubview(image1Button)
        image1Button.anchor(top: header.topAnchor,
                            leading: header.leadingAnchor,
                            bottom: header.bottomAnchor,
                            trailing: nil,
                            padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true

        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding

        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor,
                         leading: image1Button.trailingAnchor,
                         bottom: header.bottomAnchor,
                         trailing: header.trailingAnchor,
                         padding: .init(top: padding, left: padding, bottom: padding, right: padding))

        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
}

extension SettingsController {
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }

    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        print("Selecting photo with button: ", button)
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button

        present(imagePicker, animated: true)
    }
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let picker = picker as? CustomImagePickerController else { return }
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = picker.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)

        dismiss(animated: true)
    }
}
