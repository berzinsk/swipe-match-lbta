//
//  User.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 24/06/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {
    // defining our properties for our model layer
    let name: String
    let age: Int
    let profession: String
    let imageName: String

    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSMutableAttributedString(string: "  \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSMutableAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))

        return CardViewModel(imageName: imageName, attributedString: attributedText, textAlignment: .left)
    }
}
