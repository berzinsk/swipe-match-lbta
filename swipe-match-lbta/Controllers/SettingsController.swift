//
//  SettingsController.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 11/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsControllerDelegate {
    func didSaveSettings()
}

class SettingsController: UITableViewController {
    var delegate: SettingsControllerDelegate?

    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))

    lazy var header: UIView = {
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
    }()

    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationItems()
        Firestore.firestore().fetchCurrentUser { [unowned self] user, error in
            if let error = error {
                print("Failed to fetch user: ", error)
                return
            }
            
            self.user = user
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
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

    fileprivate func setupTableView() {
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
    }

    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }

    fileprivate func loadUserPhotos() {
        loadPhoto(imageUrl: user?.imageUrl1, forButton: image1Button)
        loadPhoto(imageUrl: user?.imageUrl2, forButton: image2Button)
        loadPhoto(imageUrl: user?.imageUrl3, forButton: image3Button)
    }

    fileprivate func loadPhoto(imageUrl: String?, forButton button: UIButton) {
        guard let urlString = imageUrl, let url = URL(string: urlString) else { return }

        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
}

extension SettingsController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            ageRangeCell.minLabel.text = "Min: \(user?.minSeekingAge ?? -1)"
            ageRangeCell.maxLabel.text = "Max: \(user?.maxSeekingAge ?? -1)"
            ageRangeCell.minSlider.value = Float(user?.minSeekingAge ?? 18)
            ageRangeCell.maxSlider.value = Float(user?.maxSeekingAge ?? 18)

            return ageRangeCell
        }

        let cell = SettingsCell(style: .default, reuseIdentifier: nil)

        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = "\(age)"
            }
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
        default:
            cell.textField.placeholder = "Enter Bio"
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }

        let headerLabel = SettingsHeaderLabel()
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Bio"
        default:
            headerLabel.text = "Seeking Age Range"
        }

        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)

        return headerLabel
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }

        return 40
    }

    // TODO: this should be called only when saving
    fileprivate func upload(image: UIImage?, fromButtom button: UIButton?) {
        guard let uploadData = image?.jpegData(compressionQuality: 0.7) else { return }

        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")

        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)

        ref.putData(uploadData, metadata: nil) { [unowned self] _, error in
            if let error = error {
                hud.dismiss()
                print("Failed to upload image to storage: ", error)
                return
            }

            print("Finished uploading image")
            ref.downloadURL { url, error in
                hud.dismiss()

                if let error = error {
                    print("Failed to retrieve image download URL:", error)
                    return
                }

                print("Finished getting download url: ", url?.absoluteString ?? "")
                if button == self.image1Button {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if button == self.image2Button {
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
            }
        }
    }

    fileprivate func updateSliders() {
        guard let ageRangeCell = tableView.cellForRow(at: [5, 0]) as? AgeRangeCell else { return }

        let minValue = Int(ageRangeCell.minSlider.value)
        var maxValue = Int(ageRangeCell.maxSlider.value)
        maxValue = max(minValue, maxValue)
        ageRangeCell.maxSlider.value = Float(maxValue)
        ageRangeCell.minLabel.text = "Min: \(minValue)"
        ageRangeCell.maxLabel.text = "Max: \(maxValue)"

        user?.minSeekingAge = minValue
        user?.maxSeekingAge = maxValue
    }
}

extension SettingsController {
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }

    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button

        present(imagePicker, animated: true)
    }

    @objc fileprivate func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String: Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "imageUrl1": user?.imageUrl1 ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "minSeekingAge": user?.minSeekingAge ?? -1,
            "maxSeekingAge": user?.maxSeekingAge ?? -1
        ]

        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)

        Firestore.firestore().collection("users").document(uid).setData(docData) { error in
            hud.dismiss()
            if let error = error {
                print("Failed to save user settings: ", error)
                return
            }

            self.dismiss(animated: true) {
                self.delegate?.didSaveSettings()
            }
        }
    }

    @objc fileprivate func handleNameChange(textField: UITextField) {
        user?.name = textField.text
    }

    @objc fileprivate func handleProfessionChange(textField: UITextField) {
        user?.profession = textField.text
    }

    @objc fileprivate func handleAgeChange(textField: UITextField) {
        user?.age = Int(textField.text ?? "")
    }

    @objc fileprivate func handleMinAgeChange(slider: UISlider) {
        updateSliders()
    }

    @objc fileprivate func handleMaxAgeChange(slider: UISlider) {
        updateSliders()
    }
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let picker = picker as? CustomImagePickerController else { return }
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = picker.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)

        dismiss(animated: true)

        // TODO: refactor so that image is uploaded only when saving instead of when image selected
        self.upload(image: selectedImage, fromButtom: imageButton)
    }
}
