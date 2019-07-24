//
//  CardViewModel.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 01/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    // we'll define the properties that our view will display/render out
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment

    // Reactive programming
    var imageIndexObserver: ((Int, String?) -> ())?

    fileprivate var imageIndex = 0 {
        didSet {
            let imageUrl = imageUrls[imageIndex]
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }

    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }

    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }

    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}
