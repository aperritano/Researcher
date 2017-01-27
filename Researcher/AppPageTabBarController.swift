
import UIKit
import Material

class AppPageTabBarController: PageTabBarController {
    
    var titleLabel = "" {
        didSet {
            navigationItem.title = titleLabel
            navigationItem.titleLabel.tintColor = .white
        }
    }
    
    var titleDetailLabel = "" {
        didSet {
            navigationItem.title = titleDetailLabel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()

    }
    
    open override func prepare() {
        super.prepare()
       // view.backgroundColor = Color.blue.darken2
        delegate = self
        preparePageTabBar()
    }
    
    private func preparePageTabBar() {
        pageTabBarAlignment = .top
        pageTabBar.tintColor = .white
        pageTabBar.dividerColor = Color.blue.darken2
        pageTabBar.lineColor = Color.white
        pageTabBar.lineAlignment = .bottom
        pageTabBar.backgroundColor = Color.blue.darken2
    }
    
    private func prepareNavigationItem() {
        navigationItem.title = ""
        navigationItem.detail = ""
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.detailLabel.textAlignment = .left
        navigationItem.titleLabel.textColor = .white
        navigationItem.detailLabel.textColor = .white
        navigationItem.backButton.tintColor = .white
    }
}

extension AppPageTabBarController: PageTabBarControllerDelegate {
    func pageTabBarController(pageTabBarController: PageTabBarController, didTransitionTo viewController: UIViewController) {
        
        viewController.view.setNeedsLayout()
        viewController.view.setNeedsDisplay()
        print("pageTabBarController", pageTabBarController, "didTransitionTo viewController:", viewController)
    }
}
