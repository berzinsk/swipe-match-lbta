//
//  ViewController.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 10/06/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()

    var cardViewModels = [CardViewModel]()
    var lastFetchedUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)

        setupLayout()
        setupUserCards()
        fetchUsers()
    }

    // MARK:- Fileprivate
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
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

    fileprivate func setupUserCards() {
        cardViewModels.forEach { cardVM in
            let cardView = CardView()
            cardView.cardViewModel = cardVM

            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }

    fileprivate func setupCardFor(user: User) {
        let cardView = CardView()
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }

    fileprivate func fetchUsers() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)

        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)

        query.getDocuments { [unowned self] snapshot, error in
            hud.dismiss()
            if let error = error {
                print("Failed to fetch users: ", error)
                return
            }

            snapshot?.documents.forEach { documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCardFor(user: user)
            }
        }
    }
}

extension HomeController {
    @objc func handleSettings() {
        let settingsController = SettingsController()
        let navController = UINavigationController(rootViewController: settingsController)
        settingsController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }

    @objc func handleRefresh() {
        fetchUsers()
    }
}

