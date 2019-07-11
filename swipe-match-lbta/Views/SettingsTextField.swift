//
//  SettingsTextField.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 11/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class SettingsTextField: UITextField {
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 44)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 24, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 24, dy: 0)
    }
}
