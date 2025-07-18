//
//  Utilities.swift
//  rich
//
//  Created by snow on 2025/7/18.
//

import Foundation
import UIKit

final class Utilities {
    static let shared = Utilities()

    private init() {}

    @MainActor

    // Copied from: https://stackoverflow.com/questions/26667009/get-top-most-uiviewcontroller
    func getTopViewController(
        controller: UIViewController? = nil
    ) -> UIViewController? {

        let controller =
            controller
            ?? UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController

        if let nav = controller as? UINavigationController {
            return getTopViewController(controller: nav.visibleViewController)

        } else if let tab = controller as? UITabBarController,
            let selected = tab.selectedViewController
        {
            return getTopViewController(controller: selected)

        } else if let presented = controller?.presentedViewController {
            return getTopViewController(controller: presented)
        }
        return controller
    }
}
