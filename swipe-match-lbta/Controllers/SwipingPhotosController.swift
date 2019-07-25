//
//  SwipingPhotosController.swift
//  swipe-match-lbta
//
//  Created by Kārlis Bērziņš on 24/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController {
    var cardViewModel: CardViewModel! {
        didSet {
            print(cardViewModel.attributedString)
            controllers = cardViewModel.imageUrls.map { imageUrl -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)

                return photoController
            }

            setViewControllers([controllers.first!], direction: .forward, animated: false)
        }
    }

    var controllers = [UIViewController]()

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
