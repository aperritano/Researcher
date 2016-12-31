
import UIKit
import Material
import Koloda
import pop

private let numberOfCards: Int = 5

class NextViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    var labelTitle: String = "" {
        didSet {
            pageTabBarItem.title = labelTitle
            pageTabBarItem.titleColor = .white
        }
    }
    
    fileprivate var dataSource: [UIImage] = {
        var array: [UIImage] = []
        for index in 0..<numberOfCards {
            array.append(UIImage(named: "Card_like_\(index + 1)")!)
        }
        
        return array
    }()
    
    // MARK: IBActions
    
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        prepareNavigationItem()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        self.view.setNeedsDisplay()
    }
    
    func prepareNavigationItem() {
        navigationItem.title = "er"
        navigationItem.detail = "Detail 23"
        navigationItem.titleLabel.tintColor = .white
        navigationItem.detailLabel.tintColor = .white
    }
}

//MARK: KolodaViewDelegate
extension NextViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        let position = kolodaView.currentCardIndex
        for i in 1...4 {
            dataSource.append(UIImage(named: "Card_like_\(i)")!)
        }
        kolodaView.insertCardAtIndexRange(position..<position + 4, animated: true)
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
}

// MARK: KolodaViewDataSource
extension NextViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        
        
        let view = (Bundle.main.loadNibNamed("BasicCardView", owner: self, options: nil)?[0] as? UIView)!
        
        LOG.debug("bounds K bounds: \(koloda.bounds): \(koloda.frame) Card Bounds \(view.bounds):\(view.frame)")
        
        koloda.setNeedsDisplay()
        koloda.setNeedsLayout()
        return view
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}


