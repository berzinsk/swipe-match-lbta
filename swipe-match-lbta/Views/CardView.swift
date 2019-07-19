//
//  CardView.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 13/06/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit
import SDWebImage

class CardView: UIView {
    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageNames.first ?? ""
            imageView.sd_setImage(with: URL(string: imageName))
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment

            guard cardViewModel.imageNames.count > 1 else { return }

            cardViewModel.imageNames.forEach { _ in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }

            barsStackView.arrangedSubviews.first?.backgroundColor = .white

            setupImageIndexObserver()
        }
    }

    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    fileprivate let barsStackView = UIStackView()

    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)

    // Configurations
    fileprivate let treshold: CGFloat = 100

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        gradientLayer.frame = frame
    }

    fileprivate func setupLayout() {
        // custom drawing code
        layer.cornerRadius = 10
        clipsToBounds = true

        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()

        setupBarsStackView()
        setupGradientLayer()

        addSubview(informationLabel)

        informationLabel.anchor(top: nil,
                                leading: leadingAnchor,
                                bottom: bottomAnchor,
                                trailing: trailingAnchor,
                                padding: .init(top: 0, left: 16, bottom: 16, right: 16))

        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
    }

    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor,
                             leading: leadingAnchor,
                             bottom: nil,
                             trailing: trailingAnchor,
                             padding: .init(top: 8, left: 8, bottom: 8, right: 8),
                             size: .init(width: 0, height: 4))

        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }

    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]

        layer.addSublayer(gradientLayer)
    }

    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [unowned self] (idx, imageUrl) in
            self.imageView.sd_setImage(with: URL(string: imageUrl ?? ""))
            self.barsStackView.arrangedSubviews.forEach { $0.backgroundColor = self.barDeselectedColor }
            self.barsStackView.arrangedSubviews[idx].backgroundColor = .white
        }
    }

    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            // remove animations when dragging to stop weird behavior when card randomly appears when dragging
            superview?.subviews.forEach { $0.layer.removeAllAnimations() }
        case .changed:
            handleChanged(gesture: gesture)
        case .ended:
            handleEnded(gesture: gesture)
        default:
            break
        }
    }

    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        guard let vm = cardViewModel, vm.imageNames.count > 1 else { return }

        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false

        if shouldAdvanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }

    fileprivate func handleChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        // rotation
        // convert radiants to degrees
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180

        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }

    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > treshold

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.frame = .init(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
        }, completion: { _ in
            // bring card back to screen
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
//            self.frame = .init(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
        })
    }
}
