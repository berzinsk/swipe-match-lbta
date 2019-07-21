//
//  LoginViewModel.swift
//  swipe-match-lbta
//
//  Created by Kārlis Bērziņš on 21/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import Foundation
import Firebase

class LoginViewModel {
    var isLoggingIn = Bindable<Bool>()
    var isFormValid = Bindable<Bool>()

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

    fileprivate func checkFormValidity() {
        let isValid = email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }

    func performLogin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        isLoggingIn.value = true

        Auth.auth().signIn(withEmail: email, password: password) { res, error in
            completion(error)
        }
    }
}
