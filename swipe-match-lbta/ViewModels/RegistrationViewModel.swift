//
//  RegistrationViewModel.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 06/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()

    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }

    var email: String? {
        didSet {
            checkFormValidity()
        }
    }

    var password: String? {
        didSet {
            checkFormValidity()
        }
    }

    func performRegistration(completion: @escaping (Error?) ->()) {
        guard let email = email, let password = password else { return }

        bindableIsRegistering.value = true

        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] res, error in
            if let error = error {
                completion(error)
                return
            }

            let filename = UUID().uuidString
            let ref = Storage.storage().reference(withPath: "/images/\(filename)")
            let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
            ref.putData(imageData, metadata: nil) { [unowned self] _, error in
                if let error = error {
                    completion(error)
                    return
                }

                ref.downloadURL { [unowned self] url, error in
                    if let error = error {
                        completion(error)
                        return
                    }

                    self.bindableIsRegistering.value = false
                    completion(nil)
                }
            }
        }
    }

    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false &&
            email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
}
