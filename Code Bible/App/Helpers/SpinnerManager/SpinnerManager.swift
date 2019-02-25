/// Copyright © 2018 Zaid M. Said
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

struct SpinnerManager {
    static var shared = SpinnerManager()
    private var loadingIndicator: UIView?

    private init() {}

    mutating func startLoadingIndicator(_ sender: UIViewController) {
        let loadingIndicator = UIView()
        loadingIndicator.frame = CGRect(x: 0, y: -20, width: sender.view.frame.size.width, height: sender.view.frame.size.height + 20)
        loadingIndicator.backgroundColor = UIColor.clear

        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        loadingView.center = sender.view.center
        loadingView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style =
            UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2.0, y: loadingView.frame.size.height / 2.0)
        activityIndicator.startAnimating()

        loadingView.addSubview(activityIndicator)
        loadingIndicator.addSubview(loadingView)
        sender.view.addSubview(loadingIndicator)

        self.loadingIndicator = loadingIndicator
    }

    mutating func stopLoadingIndicatior() {
        self.loadingIndicator?.removeFromSuperview()
    }
}
