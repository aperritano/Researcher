
import UIKit
import Material
import Koloda
import PopupDialog
import RealmSwift
import EasyAnimation

private let numberOfCards: Int = 1

class NextViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    @IBOutlet weak var toolbarView: View!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var cardStackView: UIStackView!
    
    var lastPaperIndex = 0
    var paperSession: PaperSession? {
        didSet {
            if let paperSession = self.paperSession {
                
                if let lastPaperIndex = paperSession.lastPaperIndex.value {
                    
                    self.lastPaperIndex = lastPaperIndex
                    let predicate = NSPredicate(format: "index >= \(lastPaperIndex)")
                    
                    paperDatasource = paperSession.papers.filter(predicate).sorted(byKeyPath: "index")
                    
                    LOG.debug("Papers \(self.paperDatasource?.count)")
                } else {
                    
                    self.lastPaperIndex = 0
                    let predicate = NSPredicate(format: "index >= 0")
                    paperDatasource = paperSession.papers.filter(predicate).sorted(byKeyPath: "index")
                    
                    LOG.debug("NO SAVED Papers \(self.paperDatasource?.count)")
                    
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
    
    @IBOutlet weak var graphButton: UIButton!
    
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
    
    @IBAction func showGraphPopup() {
        
        // Create a custom view controller
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //
        //        let graphViewController =  storyboard.instantiateViewController(withIdentifier: "graphViewController") as! GraphViewController
        
        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
        
        if let paperSession = self.paperSession {
            ratingVC.paperSession = paperSession
            LOG.debug("paperSession \(paperSession)")
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
    
    //MARK: CONTROLLER DID
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.view.setNeedsDisplay()
        
        if let ps = self.paperSession, ps.isDone == true {
            dismissButtons()
        } else {
            showButtons()
        }
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
    
    fileprivate func showSnackbar(withText text: String) {
        guard let sc = snackbarController else {
            return
        }
        
        sc.snackbar.text = text
        
        _ = sc.animate(snackbar: .visible, delay: 1)
        _ = sc.animate(snackbar: .hidden, delay: 4)
    }
    
    func updatePaperTotals(withIndex index:Int) {
        if totalCountLabel != nil, let paperTotal = paperSession?.papers.count {
            totalCountLabel.text = "#\(index) of \(paperTotal)"
        }
    }
    
    func showButtons() {
        
        self.cardStackView.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.cardStackView.alpha = 1.0
            
        }, completion: {(finished: Bool) in
            
        })
    }

    func dismissButtons() {
        
        UIView.animate(withDuration: 0.5, animations: {
        
            self.cardStackView.alpha = 0.0

        }, completion: {(finished: Bool) in
        
            self.cardStackView.isHidden = true
            
            let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
            
            ratingVC.paperSession = self.paperSession
            ratingVC.view.alpha = 0.0
            ratingVC.view.center = self.view.center
            ratingVC.allCorners()
            
            self.view.addSubview(ratingVC.view)
            
            self.visualEffectView.alpha = 0.0
            self.visualEffectView.isHidden = false
            self.backgroundImage.alpha = 0.0
            self.backgroundImage.isHidden = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.backgroundImage.alpha = 1.0
                self.visualEffectView.alpha = 1.0
                ratingVC.view.alpha = 1.0
            })
        })
    }
}

//MARK: KolodaViewDelegate
extension NextViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        if let paperSession = self.paperSession, let paper = self.paperDatasource?[index] {
            if let realm = realm {
                try! realm.write {
                    
                    switch direction {
                    case .left:
                        paper.isLiked.value = false
                    default:
                        paper.isLiked.value = true
                    }
                    
                    if paper.index >= paperSession.papers.count - 1 {
                        paperSession.isDone = true
                        
                        dismissButtons()
                        
                        self.showSnackbar(withText: "Congratulations! Complete! \(paperSession.papers.count) papers swiped.")
                    }
                    
                    paperSession.lastPaperIndex.value = paper.index + 1
                    
                    switch paper.index {
                    case 0:
                        self.updatePaperTotals(withIndex: 2)
                    default:
                        self.updatePaperTotals(withIndex: paper.index + 2)

                    }
                    
                    realm.add(paper, update: true)
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
        
        if let paperSession = self.paperSession {
            if paperSession.isDone {
                return 0
            }
        }
        
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


