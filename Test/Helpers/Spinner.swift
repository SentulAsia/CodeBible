//
//  Spinner.swift
//  Test
//
//  Created by Zaid M. Said on 03/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

struct Spinner {
    static var shared = Spinner()
    fileprivate var loadingIndicator: UIView?

    mutating func startLoadingIndicator(forViewController controller: UIViewController) {
        let loadingIndicator = UIView()
        loadingIndicator.frame = CGRect(x: 0, y: -20, width: controller.view.frame.size.width, height: controller.view.frame.size.height + 20)
        loadingIndicator.backgroundColor = UIColor.clear

        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        loadingView.center = controller.view.center
        loadingView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2.0, y: loadingView.frame.size.height / 2.0)
        activityIndicator.startAnimating()

        loadingView.addSubview(activityIndicator)
        loadingIndicator.addSubview(loadingView)
        controller.view.addSubview(loadingIndicator)

        self.loadingIndicator = loadingIndicator
    }

    mutating func stopLoadingIndicatior() {
        self.loadingIndicator?.removeFromSuperview()
    }
}
