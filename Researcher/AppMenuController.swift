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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
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
    fileprivate func prepareMenu() {
        menu.baseSize = baseSize
        
        view.layout(menu)
            .size(baseSize)
            .bottom(bottomInset)
            .right(rightInset)
    }
}
