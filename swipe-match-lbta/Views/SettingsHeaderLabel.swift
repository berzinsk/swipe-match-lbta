//
//  SettingsHeaderLabel.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 11/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class SettingsHeaderLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}
