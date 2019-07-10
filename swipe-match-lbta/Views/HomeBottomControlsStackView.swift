//
//  HomeBottomControlsStackView.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 11/06/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    let refreshButton = createButton(image: #imageLiteral(resourceName: "refresh_circle"))
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle"))
    let superLikeButton = createButton(image: #imageLiteral(resourceName: "super_like_circle"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "like_circle"))
    let specialButton = createButton(image: #imageLiteral(resourceName: "boost_circle"))

    override init(frame: CGRect) {
        super.init(frame: frame)

        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true

        [refreshButton, dislikeButton, superLikeButton, likeButton, specialButton].forEach { button in
            self.addArrangedSubview(button)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill

        return button
    }
}
