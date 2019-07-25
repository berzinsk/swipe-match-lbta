//
//  PhotoController.swift
//  swipe-match-lbta
//
//  Created by Kārlis Bērziņš on 25/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class PhotoController: UIViewController {
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"))

    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
