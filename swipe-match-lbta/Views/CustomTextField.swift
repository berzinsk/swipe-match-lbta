//
//  CustomTextField.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 05/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    let padding: CGFloat
    let height: CGFloat

    init(padding: CGFloat, height: CGFloat = 44) {
        self.padding = padding
        self.height = height
        super.init(frame: .zero)

        layer.cornerRadius = height / 2
        backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: height)
    }
}
