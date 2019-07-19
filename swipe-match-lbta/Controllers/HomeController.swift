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
    fileprivate var user: User?
    fileprivate let hud = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()

        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)

        setupLayout()
        fetchCurrentUser()
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
        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else { return }

        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)

        query.getDocuments { [unowned self] snapshot, error in
            self.hud.dismiss()
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

    fileprivate func fetchCurrentUser() {
        hud.textLabel.text = "Loading"
        hud.show(in: view)

        cardsDeckView.subviews.forEach { $0.removeFromSuperview() }

        Firestore.firestore().fetchCurrentUser { [unowned self] user, error in
            if let error = error {
                print("Failed to fetch current user: ", error)
                self.hud.dismiss()
                return
            }

            self.user = user
            self.fetchUsers()
        }
    }
}

extension HomeController {
    @objc func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        settingsController.modalPresentationStyle = .fullScreen

        let navController = UINavigationController(rootViewController: settingsController)

        present(navController, animated: true, completion: nil)
    }

    @objc func handleRefresh() {
        fetchUsers()
    }
}

extension HomeController: SettingsControllerDelegate {
    func didSaveSettings() {
        self.fetchCurrentUser()
    }
}
