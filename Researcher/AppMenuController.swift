import UIKit
import Material

class AppMenuController: MenuController {
    fileprivate let baseSize = CGSize(width: 56, height: 56)
    fileprivate let bottomInset: CGFloat = 24
    fileprivate let rightInset: CGFloat = 24
    
    open override func prepare() {
        super.prepare()
        view.backgroundColor = Color.blue
        
        prepareMenu()
    }
    
    fileprivate var menuButton: IconButton!
    fileprivate var starButton: IconButton!
    fileprivate var searchButton: IconButton!
    
    fileprivate var nextButton: FlatButton!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareMenuButton()
        prepareStarButton()
        prepareSearchButton()
        prepareNavigationItem()
    }
    
    open override func openMenu(completion: ((UIView) -> Void)? = nil) {
        super.openMenu(completion: completion)
        menu.views.first?.animate(animation: Motion.rotate(angle: 45))
    }
    
    open override func closeMenu(completion: ((UIView) -> Void)? = nil) {
        super.closeMenu(completion: completion)
        menu.views.first?.animate(animation: Motion.rotate(angle: 0))
    }
}

extension AppMenuController {
    fileprivate func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.tintColor = .white

    }
    
    fileprivate func prepareStarButton() {
        starButton = IconButton(image: Icon.cm.star)
        starButton.tintColor = .white

    }
    
    fileprivate func prepareSearchButton() {
        searchButton = IconButton(image: Icon.cm.search)
        searchButton.tintColor = .white
    }
    
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "PapersX"
        //navigationItem.detail = "Build Beautiful Software"
        
        navigationItem.titleLabel.textColor = .white
        navigationItem.titleLabel.textAlignment = .left
        
        navigationItem.detailLabel.textColor = .white
        navigationItem.detailLabel.textAlignment = .left
        
        navigationItem.leftViews = [starButton]
        navigationItem.rightViews = [searchButton]
    }
    
}


extension AppMenuController {
    fileprivate func prepareMenu() {
        menu.baseSize = baseSize
        
        view.layout(menu)
            .size(baseSize)
            .bottom(bottomInset)
            .right(rightInset)
    }
}
