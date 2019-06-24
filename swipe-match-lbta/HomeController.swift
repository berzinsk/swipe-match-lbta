//
//  ViewController.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 10/06/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()

    let users = [
        User(name: "Kelly", age: 23, profession: "Music DJ", imageName: "lady5c"),
        User(name: "Jane", age: 18, profession: "Teacher", imageName: "lady4c")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupDummyCards()
    }

    fileprivate func setupDummyCards() {
        users.forEach { user in
            let cardView = CardView()
            cardView.imageView.image = UIImage(named: user.imageName)
            cardView.informationLabel.text = "\(user.name) \(user.age) \n \(user.profession)"

            let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
            attributedText.append(NSMutableAttributedString(string: "  \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
            attributedText.append(NSMutableAttributedString(string: "\n\(user.profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))

            cardView.informationLabel.attributedText = attributedText

            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }

    // MARK:- Fileprivate
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)

        overallStackView.bringSubviewToFront(cardsDeckView)
    }
}

