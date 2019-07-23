//
//  UserDetailsController.swift
//  swipe-match-lbta
//
//  Created by Kārlis Bērziņš on 22/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class UserDetailsController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()

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

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
}

extension UserDetailsController {
    @objc fileprivate func handleTapDismiss() {
        dismiss(animated: true)
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
