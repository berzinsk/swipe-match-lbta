//
//  CardView.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 13/06/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didRemoveCard(cardView: CardView)
    func didSwipe(likeStatus: LikeStatus)
}

class CardView: UIView {
    var delegate: CardViewDelegate?

    var nextCardView: CardView?

    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)

        return button
    }()

    var cardViewModel: CardViewModel! {
        didSet {
            swipingPhotosController.cardViewModel = cardViewModel
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
        }
    }

    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()

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

        let swipingPhotosView = swipingPhotosController.view!

        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()

        setupGradientLayer()

        addSubview(informationLabel)

        informationLabel.anchor(top: nil,
                                leading: leadingAnchor,
                                bottom: bottomAnchor,
                                trailing: trailingAnchor,
                                padding: .init(top: 0, left: 16, bottom: 16, right: 16))

        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0

        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil,
                              leading: nil,
                              bottom: bottomAnchor,
                              trailing: trailingAnchor,
                              padding: .init(top: 0, left: 0, bottom: 16, right: 16),
                              size: .init(width: 44, height: 44))
    }

    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]

        layer.addSublayer(gradientLayer)
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

        if shouldDismissCard {
            delegate?.didSwipe(likeStatus: translationDirection == 1 ? .like : .dislike)
        } else {
            UIView.animate(withDuration: 1,
                           delay: 0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.1,
                           options: .curveEaseOut,
                           animations: {
                            self.transform = .identity
            })
        }
    }
}

extension CardView {
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
        guard let vm = cardViewModel, vm.imageUrls.count > 1 else { return }

        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false

        if shouldAdvanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }

    @objc fileprivate func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: cardViewModel)
    }
}
