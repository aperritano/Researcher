
import UIKit
import Material

class NextViewController: UIViewController {
    
    var labelTitle: String = "" {        
        didSet {
            pageTabBarItem.title = labelTitle
            pageTabBarItem.titleColor = .white
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        prepareNavigationItem()
    }
    
    func prepareNavigationItem() {
        navigationItem.title = "er"
        navigationItem.detail = "Detail 23"
        navigationItem.titleLabel.tintColor = .white
        navigationItem.detailLabel.tintColor = .white
    }
}

