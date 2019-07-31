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

    fileprivate let itsAMatchImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You and X have liked\neach other"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0

        return label
    }()

    fileprivate let sendMessageButton: ButtonWithGradientBackground = {
        let button = ButtonWithGradientBackground(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)

        return button
    }()

    fileprivate let keepSwipingButton: ButtonWithGradientBorder = {
        let button = ButtonWithGradientBorder(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)

        return button
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

        addSubview(itsAMatchImageView)
        addSubview(descriptionLabel)
        addSubview(currentUserImageView)
        addSubview(cardUserImageView)
        addSubview(sendMessageButton)
        addSubview(keepSwipingButton)

        itsAMatchImageView.anchor(top: nil,
                                  leading: nil,
                                  bottom: descriptionLabel.topAnchor,
                                  trailing: nil,
                                  padding: .init(top: 0, left: 0, bottom: 16, right: 0),
                                  size: .init(width: 300, height: 80))
        itsAMatchImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        descriptionLabel.anchor(top: nil,
                                leading: leadingAnchor,
                                bottom: cardUserImageView.topAnchor,
                                trailing: trailingAnchor,
                                padding: .init(top: 0, left: 0, bottom: 32, right: 0),
                                size: .init(width: 0, height: 50))

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

        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor,
                                 leading: leadingAnchor,
                                 bottom: nil,
                                 trailing: trailingAnchor,
                                 padding: .init(top: 32, left: 48, bottom: 0, right: 48),
                                 size: .init(width: 0, height: 64))

        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor,
                                 leading: sendMessageButton.leadingAnchor,
                                 bottom: nil,
                                 trailing: sendMessageButton.trailingAnchor,
                                 padding: .init(top: 16, left: 0, bottom: 0, right: 0),
                                 size: .init(width: 0, height: 64))
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
