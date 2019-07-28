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
    fileprivate let topStackView = TopNavigationStackView()
    fileprivate let cardsDeckView = UIView()
    fileprivate let bottomControls = HomeBottomControlsStackView()
    fileprivate var topCardView: CardView?

    fileprivate var user: User?
    fileprivate let hud = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()

        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)

        setupLayout()
        fetchCurrentUser()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navController = UINavigationController(rootViewController: registrationController)
            present(navController, animated: true)
        }
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

    fileprivate func setupCardFor(user: User) -> CardView {
        let cardView = CardView()
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()

        return cardView
    }

    fileprivate func fetchUsers() {
        let minAge = user?.minSeekingAge ?? Constants.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? Constants.defaultMaxSeekingAge

        let query = Firestore.firestore().collection("users")
            .whereField("age", isGreaterThanOrEqualTo: minAge)
            .whereField("age", isLessThanOrEqualTo: maxAge)

        topCardView = nil

        query.getDocuments { [unowned self] snapshot, error in
            self.hud.dismiss()
            if let error = error {
                print("Failed to fetch users: ", error)
                return
            }

            var previousCardView: CardView?

            snapshot?.documents.forEach { documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    let cardView = self.setupCardFor(user: user)

                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView

                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
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

    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5

        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.isRemovedOnCompletion = false
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration

        let cardView = topCardView
        topCardView = cardView?.nextCardView

        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }

        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")

        CATransaction.commit()
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
        if topCardView == nil {
            fetchUsers()
        }
    }

    @objc func handleLike() {
        performSwipeAnimation(translation: 700, angle: 15)
    }

    @objc
    fileprivate func handleDislike() {
        performSwipeAnimation(translation: -300, angle: -15)
    }
}

extension HomeController: SettingsControllerDelegate {
    func didSaveSettings() {
        self.fetchCurrentUser()
    }
}

extension HomeController: LoginControllerDelegate {
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
}

extension HomeController: CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let controller = UserDetailsController()
        controller.cardViewModel = cardViewModel

        present(controller, animated: true)
    }

    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        topCardView = cardView.nextCardView
    }
}
