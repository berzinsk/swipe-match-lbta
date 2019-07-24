//
//  UserDetailsController.swift
//  swipe-match-lbta
//
//  Created by Kārlis Bērziņš on 22/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit
import SDWebImage

class UserDetailsController: UIViewController {
    // Better would be to create different vm for user details controller (ie UserDetailsViewModel)
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString

            guard let firstImageUrl = cardViewModel.imageUrls.first, let url = URL(string: firstImageUrl) else { return }
            imageView.sd_setImage(with: url)
        }
    }

    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self

        return scrollView
    }()

    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    fileprivate let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "User name 30\nDoctor\nSome bio text down below"
        label.numberOfLines = 0

        return label
    }()

    fileprivate let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)

        return button
    }()

    lazy var dislikeButton = self.createButton(image: #imageLiteral(resourceName: "dismiss_circle"), selector: #selector(handleDislike))
    lazy var superLikeButton = self.createButton(image: #imageLiteral(resourceName: "super_like_circle"), selector: #selector(handleDislike))
    lazy var likeButton = self.createButton(image: #imageLiteral(resourceName: "like_circle"), selector: #selector(handleDislike))

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupVisualBlurEffectView()
        setupBottomControls()
    }

    fileprivate func setupLayout() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.fillSuperview()

        scrollView.addSubview(imageView)
        imageView.frame = .init(x: 0, y: 0, width: view.frame.width, height: view.frame.width)

        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: imageView.bottomAnchor,
                         leading: scrollView.leadingAnchor,
                         bottom: nil,
                         trailing: scrollView.trailingAnchor,
                         padding: .init(top: 16, left: 16, bottom: 0, right: 16))

        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: imageView.bottomAnchor,
                             leading: nil,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             padding: .init(top: -25, left: 0, bottom: 0, right: 24),
                             size: .init(width: 50, height: 50))
    }

    fileprivate func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)

        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.topAnchor,
                                trailing: view.trailingAnchor)
    }

    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill

        return button
    }

    fileprivate func setupBottomControls() {
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        stackView.distribution = .fillEqually
        stackView.spacing = -32

        view.addSubview(stackView)
        stackView.anchor(top: nil,
                         leading: nil,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         trailing: nil,
                         padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                         size: .init(width: 300, height: 80))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension UserDetailsController {
    @objc fileprivate func handleTapDismiss() {
        dismiss(animated: true)
    }

    @objc fileprivate func handleDislike() {
        print("Disliking")
    }
}

extension UserDetailsController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
        let position = min(0, -changeY)

        imageView.frame = .init(x: position, y: position, width: width, height: width)
    }
}
