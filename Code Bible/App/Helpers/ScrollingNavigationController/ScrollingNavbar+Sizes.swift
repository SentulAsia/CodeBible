//
//  Copyright © 2019 Zaid M. Said. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import UIKit
import WebKit

/**
 Implements the main functions providing constants values and computed ones
 */
extension ScrollingNavigationController {

    // MARK: - View sizing

    var fullNavbarHeight: CGFloat {
        return navbarHeight + statusBarHeight
    }

    var navbarHeight: CGFloat {
        return navigationBar.frame.size.height
    }

    var statusBarHeight: CGFloat {
        var statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        if #available(iOS 11.0, *) {
            // Account for the notch when the status bar is hidden
            statusBarHeight = max(UIApplication.shared.statusBarFrame.size.height, UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0)
        }
        return statusBarHeight - extendedStatusBarDifference
    }

    // Extended status call changes the bounds of the presented view
    var extendedStatusBarDifference: CGFloat {
        return abs(view.bounds.height - (UIApplication.shared.delegate?.window??.frame.size.height ?? UIScreen.main.bounds.height))
    }

    var tabBarOffset: CGFloat {
        // Only account for the tab bar if a tab bar controller is present and the bar is not translucent
        if let tabBarController = tabBarController, !(topViewController?.hidesBottomBarWhenPushed ?? false) {
            return tabBarController.tabBar.isTranslucent ? 0 : tabBarController.tabBar.frame.height
        }
        return 0
    }

    func scrollView() -> UIScrollView? {
        if let wkWebView = self.scrollableView as? WKWebView {
            return wkWebView.scrollView
        } else {
            return scrollableView as? UIScrollView
        }
    }

    var contentOffset: CGPoint {
        return scrollView()?.contentOffset ?? CGPoint.zero
    }

    var contentSize: CGSize {
        guard let scrollView = scrollView() else {
            return CGSize.zero
        }

        let verticalInset = scrollView.contentInset.top + scrollView.contentInset.bottom
        return CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height + verticalInset)
    }

    var deltaLimit: CGFloat {
        return navbarHeight - statusBarHeight
    }
}
