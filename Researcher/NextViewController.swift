
import UIKit
import Material
import Koloda
import PopupDialog
import RealmSwift

private let numberOfCards: Int = 1

class NextViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    var paperIndex = 0
    var paperSession: PaperSession? {
        didSet {
            if let paperSession = self.paperSession {
                
                if let lastPaperIndex = paperSession.lastPaperIndex.value {
                    
                    paperIndex = lastPaperIndex
                    let predicate = NSPredicate(format: "index >= \(lastPaperIndex)")
                    
                    paperDatasource = paperSession.papers.filter(predicate)
                    
                    LOG.debug("Papers \(self.paperDatasource?.count)")
                } else {
                    
                    let predicate = NSPredicate(format: "index >= 0")
                    paperDatasource = paperSession.papers.filter(predicate)
                    
                    LOG.debug("Papers \(self.paperDatasource?.count)")
                }
            }
        }
    }
    var paperDatasource: Results<Paper>?
    var papersDatasource: [Paper]?
    
    // MARK: IBActions
    
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var dislikeCountLabel: UILabel!
    
    @IBOutlet weak var graphButton: FabButton!
    
    var labelTitle: String = "" {
        didSet {
            pageTabBarItem.title = labelTitle
            pageTabBarItem.titleColor = .white
        }
    }
    
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    @IBAction func showGraphPopup(_ sender: Button) {
        
        // Create a custom view controller
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let graphViewController =  storyboard.instantiateViewController(withIdentifier: "graphViewController") as! GraphViewController

        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
        
        if let paperSession = self.paperSession {
            ratingVC.paperSession = paperSession
        }
    
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        // Create first button
        let buttonOne = DefaultButton(title: "CLOSE", height: 50) {
            //self.label.text = "You canceled the rating dialog"
        }
    
        // Add buttons to dialog
        popup.addButtons([buttonOne])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    //MARK: INIT
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.view.setNeedsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let lastPaperIndex = paperSession?.lastPaperIndex.value {
            self.updatePaperTotals(withIndex: lastPaperIndex + 1)
        } else {
            self.updatePaperTotals(withIndex: 1)
        }
    }
    
    func prepareNavigationItem() {
        navigationItem.title = "er"
        navigationItem.detail = "Detail 23"
        navigationItem.titleLabel.tintColor = .white
        navigationItem.detailLabel.tintColor = .white
    }
    
    func updatePaperTotals(withIndex index:Int) {
        if totalCountLabel != nil, let paperTotal = paperDatasource?.count {
            totalCountLabel.text = "#\(index) of \(paperTotal)"
        }
    }
}

//MARK: KolodaViewDelegate
extension NextViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        //        self.paperDatasource
        //        let position = kolodaView.currentCardIndex
        //        for i in 1...4 {
        //            dataSource.append(UIImage(named: "Card_like_\(i)")!)
        //        }
        //        kolodaView.insertCardAtIndexRange(position..<position + 4, animated: true)
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        
        if let paperSession = self.paperSession, let paperTotal = paperDatasource?.count {
            if let realm = realm {
                try! realm.write {
                    
                    switch direction {
                    case .left:
                        if var dislikes = paperSession.dislikesCount.value {
                            dislikes += 1
                            paperSession.dislikesCount.value = dislikes
                        } else {
                            paperSession.dislikesCount.value = 0
                        }
                    default:
                        if var likes = paperSession.likesCount.value {
                            likes += 1
                            paperSession.likesCount.value = likes
                        } else {
                            paperSession.likesCount.value = 0
                        }
                    }
                    
                    paperIndex += 1
                    
                    if paperIndex >= paperTotal {
                        paperSession.isDone.value = true
                    } else {
                        paperSession.lastPaperIndex.value = paperIndex
                        self.updatePaperTotals(withIndex: paperIndex + 1)
                    }
                    
                    realm.add(paperSession, update: true)
                }
            }
        }
        
        
    }
    
    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) {
        
    }
}

// MARK: KolodaViewDataSource
extension NextViewController: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        if let paperTotal = self.paperDatasource?.count {
            return paperTotal
        }
        return 0
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = (Bundle.main.loadNibNamed("BasicCardView", owner: self, options: nil)?[0] as? BasicCardView)!
        if let paper = self.paperDatasource?[index] {
            view.paper = paper
        }
        return view
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}


