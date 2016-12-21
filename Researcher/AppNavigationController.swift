import UIKit
import Material

class AppNavigationController: NavigationController {
    
    private func prepareStatusBar() {
               
    }
    
    open override func prepare() {
        super.prepare()
        guard let v = navigationBar as? NavigationBar else {
            return
        }
        
        v.depthPreset = .none
        v.dividerColor = Color.grey.lighten3
        v.tintColor = .white
        v.backgroundColor = Color.blue.darken2

    }
}

