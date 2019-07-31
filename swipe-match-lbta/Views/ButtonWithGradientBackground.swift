//
//  ButtonWithGradientBackground.swift
//  swipe-match-lbta
//
//  Created by karlis.berzins on 31/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class ButtonWithGradientBackground: UIButton {
    override func draw(_ rect: CGRect) {
        let leftColor = #colorLiteral(red: 1, green: 0.01176470588, blue: 0.4470588235, alpha: 1)
        let rightColor = #colorLiteral(red: 1, green: 0.3921568627, blue: 0.3176470588, alpha: 1)

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = .init(x: 0, y: 0.5)
        gradientLayer.endPoint = .init(x: 1, y: 0.5)
        gradientLayer.frame = rect

        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
    }
}
