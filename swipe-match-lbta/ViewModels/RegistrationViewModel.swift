//
//  RegistrationViewModel.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 06/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit
import Firebase

enum UserError: Error {
    case userNotFound
}

class RegistrationViewModel {
    typealias Completion = (Error?) -> ()

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

    func performRegistration(completion: @escaping Completion) {
        guard let email = email, let password = password else { return }

        bindableIsRegistering.value = true

        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] res, error in
            if let error = error {
                completion(error)
                return
            }

            self.storeImage(completion: completion)
        }
    }

    fileprivate func storeImage(completion: @escaping Completion) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
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

                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            }
        }
    }

    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping Completion) {
        guard let uid = Auth.auth().currentUser?.uid, let fullName = fullName else {
            completion(UserError.userNotFound)
            return
        }

        let documentData = ["uid": uid, "fullName": fullName, "imageUrl1": imageUrl]

        Firestore.firestore().collection("users").document(uid).setData(documentData) { error in
            if let error = error {
                completion(error)
                return
            }

            self.bindableIsRegistering.value = false
            completion(nil)
        }
    }

    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false &&
            email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
}
