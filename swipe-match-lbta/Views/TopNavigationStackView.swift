//
//  TopNavigationStackView.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 11/06/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {
    let settingsButton = UIButton(type: .system)
    let messagesButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "app_icon"))

    override init(frame: CGRect) {
        super.init(frame: frame)

        heightAnchor.constraint(equalToConstant: 80).isActive = true
        fireImageView.contentMode = .scaleAspectFit

        settingsButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        messagesButton.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)

        [settingsButton, fireImageView, messagesButton].forEach { v in
            addArrangedSubview(v)
        }

        distribution = .equalSpacing
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
