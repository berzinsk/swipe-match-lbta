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

    fileprivate let isCardViewMode: Bool

    init(isCardViewMode: Bool = false, transitionStyle: UIPageViewController.TransitionStyle = .scroll, navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal, options: [UIPageViewController.OptionsKey: Any]? = nil) {
        self.isCardViewMode = isCardViewMode
        super.init(transitionStyle: transitionStyle, navigationOrientation: navigationOrientation, options: options)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        view.backgroundColor = .white

        if isCardViewMode {
            disableSwipingAvailability()
        }

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
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
        var paddingTop: CGFloat = 8
        if !isCardViewMode {
            paddingTop += UIApplication.shared.statusBarFrame.height
        }

        barsStackView.anchor(top: view.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8),
                             size: .init(width: 0, height: 4))
    }

    fileprivate func disableSwipingAvailability() {
        view.subviews.forEach { v in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
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

extension SwipingPhotosController {
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        guard controllers.count > 1, let currentController = viewControllers?.first, let index = controllers.firstIndex(of: currentController) else { return }
        let movingForward = gesture.location(in: view).x > view.frame.width / 2

        let nextIndex = movingForward ? min(index + 1, controllers.count - 1) : max(0, index - 1)
        let controller = controllers[nextIndex]
        setViewControllers([controller], direction: .forward, animated: false)

        barsStackView.arrangedSubviews.forEach { $0.backgroundColor = deselectedBarColor }
        barsStackView.arrangedSubviews[nextIndex].backgroundColor = .white
    }
}
