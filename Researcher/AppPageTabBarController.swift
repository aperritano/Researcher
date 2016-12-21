
import UIKit
import Material

class AppPageTabBarController: PageTabBarController {
    open override func prepare() {
        super.prepare()
        view.backgroundColor = Color.blueGrey.lighten5
        
        delegate = self
        preparePageTabBar()
    }
    
    private func preparePageTabBar() {
        pageTabBarAlignment = .top
        pageTabBar.dividerColor = nil
        pageTabBar.lineColor = Color.blue.lighten3
        pageTabBar.lineAlignment = .bottom
        pageTabBar.backgroundColor = Color.blue.darken2
    }
}

extension AppPageTabBarController: PageTabBarControllerDelegate {
    func pageTabBarController(pageTabBarController: PageTabBarController, didTransitionTo viewController: UIViewController) {
        print("pageTabBarController", pageTabBarController, "didTransitionTo viewController:", viewController)
    }
}
