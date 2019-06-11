//
//  ViewController.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 10/06/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let topStackView = TopNavigationStackView()
    let blueView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()



    override func viewDidLoad() {
        super.viewDidLoad()

        blueView.backgroundColor = .blue
        setupLayout()
    }

    // MARK:- Fileprivate
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, blueView, buttonsStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: view.trailingAnchor)
    }
}

