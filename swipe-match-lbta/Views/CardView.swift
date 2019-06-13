//
//  CardView.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 13/06/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class CardView: UIView {
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))

    override init(frame: CGRect) {
        super.init(frame: frame)

        // custom drawing code
        layer.cornerRadius = 10
        clipsToBounds = true

        addSubview(imageView)
        imageView.fillSuperview()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handleChanged(gesture: gesture)
        case .ended:
            handleEnded()
        default:
            break
        }
    }

    fileprivate func handleChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }

    fileprivate func handleEnded() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.transform = .identity
        }, completion: nil)
    }
}
