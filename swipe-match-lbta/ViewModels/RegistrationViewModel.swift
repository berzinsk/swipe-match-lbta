//
//  RegistrationViewModel.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 06/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()

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

    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false &&
            email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
}
