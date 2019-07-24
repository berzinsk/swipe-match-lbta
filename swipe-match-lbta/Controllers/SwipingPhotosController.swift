//
//  SwipingPhotosController.swift
//  swipe-match-lbta
//
//  Created by Kārlis Bērziņš on 24/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController {
    let controllers = [
        PhotoController(image: #imageLiteral(resourceName: "boost_circle")),
        PhotoController(image: #imageLiteral(resourceName: "refresh_circle")),
        PhotoController(image: #imageLiteral(resourceName: "like_circle")),
        PhotoController(image: #imageLiteral(resourceName: "super_like_circle")),
        PhotoController(image: #imageLiteral(resourceName: "dismiss_circle"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        view.backgroundColor = .white

        setViewControllers([controllers.first!], direction: .forward, animated: false)
    }
}

extension SwipingPhotosController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex { $0 == viewController } ?? 0
        if index == 0 { return nil }

        return controllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex { $0 == viewController } ?? 0
        if index == controllers.count - 1 { return nil }

        return controllers[index + 1]
    }
}

class PhotoController: UIViewController {
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"))

    init(image: UIImage) {
        imageView.image = image

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFit
    }
}
