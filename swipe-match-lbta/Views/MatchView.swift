//
//  MatchView.swift
//  swipe-match-lbta
//
//  Created by Kārlis Bērziņš on 30/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class MatchView: UIView {
    fileprivate let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly2"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor

        return imageView
    }()

    fileprivate let cardUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "jane2"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupBlurView()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupBlurView() {
        visualEffectView.alpha = 0
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))

        addSubview(visualEffectView)
        visualEffectView.fillSuperview()

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.visualEffectView.alpha = 1
        })
    }

    fileprivate func setupLayout() {
        let imageWidth: CGFloat = 140

        addSubview(currentUserImageView)
        addSubview(cardUserImageView)

        currentUserImageView.anchor(top: nil,
                                    leading: nil,
                                    bottom: nil,
                                    trailing: centerXAnchor,
                                    padding: .init(top: 0, left: 0, bottom: 0, right: 16),
                                    size: .init(width: imageWidth, height: imageWidth))

        currentUserImageView.layer.cornerRadius = imageWidth / 2
        currentUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        cardUserImageView.anchor(top: nil,
                                 leading: centerXAnchor,
                                 bottom: nil,
                                 trailing: nil,
                                 padding: .init(top: 0, left: 16, bottom: 0, right: 0),
                                 size: .init(width: imageWidth, height: imageWidth))
        cardUserImageView.layer.cornerRadius = imageWidth / 2
        cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

extension MatchView {
    @objc fileprivate func handleTapDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
