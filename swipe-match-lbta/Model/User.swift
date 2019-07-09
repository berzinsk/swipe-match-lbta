//
//  User.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 24/06/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {
    // defining our properties for our model layer
    let name: String
    var age: Int?
    var profession: String?
    var imageUrl1: String?
    var uid: String?

    init(dictionary: [String: Any]) {
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String

        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
    }

    func toCardViewModel() -> CardViewModel {
        let ageString = age != nil ? "\(age!)" : "N\\A"
        let professionString = profession != nil ? profession! : "Not available"

        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSMutableAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSMutableAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))

        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedText, textAlignment: .left)
    }
}
