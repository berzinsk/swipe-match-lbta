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
            controllers = cardViewModel.imageUrls.map { imageUrl -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)

                return photoController
            }

            setViewControllers([controllers.first!], direction: .forward, animated: false)

            setupBarViews()
        }
    }


    fileprivate var controllers = [UIViewController]()
    fileprivate let barsStackView = UIStackView(arrangedSubviews: [])
    fileprivate let deselectedBarColor = UIColor(white: 0, alpha: 0.1)

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        view.backgroundColor = .white
    }

    fileprivate func setupBarViews() {
        guard cardViewModel.imageUrls.count > 1 else { return }

        cardViewModel.imageUrls.forEach { _ in
            let barView = UIView()
            barView.backgroundColor = deselectedBarColor
            barView.layer.cornerRadius = 2

            barsStackView.addArrangedSubview(barView)
        }

        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        view.addSubview(barsStackView)

        // If you constrain to safeAreaView and change frame then it will blink
        let paddingTop = UIApplication.shared.statusBarFrame.height + 8

        barsStackView.anchor(top: view.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8),
                             size: .init(width: 0, height: 4))
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

extension SwipingPhotosController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: { $0 == currentPhotoController }) {
            barsStackView.arrangedSubviews.forEach { $0.backgroundColor = deselectedBarColor }
            barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
}
