import UIKit
import SwiftCharts
import RealmSwift
import Material

class RatingViewController: UIViewController {
    
    @IBOutlet weak var placeholderView: UIView!
    
    var paperSession: PaperSession?
    
    let sideSelectorHeight: CGFloat = 50
    
    fileprivate var chart: Chart? // arc
    
    fileprivate func chart(horizontal: Bool) -> Chart {
        
        
        var likes = 0.0
        var dislikes = 0.0
        var count = 0.0
        
        if let paperSession = self.paperSession, let l = paperSession.likesCount.value, let d = paperSession.dislikesCount.value {
            likes = Double(l)
            dislikes = Double(d)
            count = Double(paperSession.papers.count)
        }
        
        
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
    
        
        let chartFrame = placeholderView.frame
        
        let likeColor = Color.green.base
        let dislikeColor = Color.blueGrey.base
        
        let zero = ChartAxisValueDouble(0)
        let barModels = [
            ChartStackedBarModel(constant: ChartAxisValueString("Likes", order: 1, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: likes, bgColor: likeColor),
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString("Dislikes", order: 2, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: dislikes, bgColor: dislikeColor)
                ])
        ]
        
        
        let (axisValues1, axisValues2) = (
            stride(from: 0, through: count, by: 2).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)},
            [ChartAxisValueString("", order: 0, labelSettings: labelSettings)] + barModels.map{$0.constant} + [ChartAxisValueString("", order: 3, labelSettings: labelSettings)]
        )
        let (xValues, yValues) = horizontal ? (axisValues1, axisValues2) : (axisValues2, axisValues1)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Paper Count", settings: labelSettings.defaultVertical()))
        
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
       let chartStackedBarsLayer = ChartStackedBarsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, barModels: barModels, horizontal: horizontal, barWidth: 75, animDuration: 1.0)
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        return Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                yAxis,
                guidelinesLayer,
                chartStackedBarsLayer
            ]
        )
    }
    
    fileprivate func showChart(horizontal: Bool) {
        self.chart?.clearView()
        
        let chart = self.chart(horizontal: horizontal)
        self.view.addSubview(chart.view)
        self.chart = chart
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.showChart(horizontal: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    class DirSelector: UIView {
        
        let horizontal: UIButton
        let vertical: UIButton
        
        weak var controller: RatingViewController?
        
        fileprivate let buttonDirs: [UIButton : Bool]
        
        init(frame: CGRect, controller: RatingViewController) {
            
            self.controller = controller
            
            self.horizontal = UIButton()
            self.horizontal.setTitle("Horizontal", for: UIControlState())
            self.vertical = UIButton()
            self.vertical.setTitle("Vertical", for: UIControlState())
            
            self.buttonDirs = [self.horizontal : true, self.vertical : false]
            
            super.init(frame: frame)
            
            self.addSubview(self.horizontal)
            self.addSubview(self.vertical)
            
            for button in [self.horizontal, self.vertical] {
                button.titleLabel?.font = ExamplesDefaults.fontWithSize(14)
                button.setTitleColor(UIColor.blue, for: UIControlState())
                button.addTarget(self, action: #selector(DirSelector.buttonTapped(_:)), for: .touchUpInside)
            }
        }
        
        func buttonTapped(_ sender: UIButton) {
            let horizontal = sender == self.horizontal ? true : false
            controller?.showChart(horizontal: horizontal)
        }
        
        override func didMoveToSuperview() {
            let views = [self.horizontal, self.vertical]
            for v in views {
                v.translatesAutoresizingMaskIntoConstraints = false
            }
            
            let namedViews = views.enumerated().map{index, view in
                ("v\(index)", view)
            }
            
            var viewsDict = Dictionary<String, UIView>()
            for namedView in namedViews {
                viewsDict[namedView.0] = namedView.1
            }
            
            let buttonsSpace: CGFloat = Env.iPad ? 20 : 10
            
            let hConstraintStr = namedViews.reduce("H:|") {str, tuple in
                "\(str)-(\(buttonsSpace))-[\(tuple.0)]"
            }
            
            let vConstraits = namedViews.flatMap {NSLayoutConstraint.constraints(withVisualFormat: "V:|[\($0.0)]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict)}
            
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: hConstraintStr, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict)
                + vConstraits)
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
