//
//  SettingsCell.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 11/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    let textField: SettingsTextField = {
        let textField = SettingsTextField()
        textField.placeholder = "Enter Name"

        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(textField)
        textField.fillSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
