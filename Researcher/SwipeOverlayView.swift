//
//  ExampleOverlayView.swift
//  KolodaView
//
//  Created by Eugene Andreyev on 6/21/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda

private let overlayRightImageName = "ic_like_heart"
private let overlayLeftImageName = "ic_dislike_close"

class SwipeOverlayView: OverlayView {
    
    @IBOutlet weak var swipeImageView: UIImageView!
    
    @IBOutlet weak var backgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left? :
                
                backgroundView.backgroundColor = UIColor.red
                
                swipeImageView.image = UIImage(named: overlayLeftImageName)
            case .right? :
                
                 backgroundView.backgroundColor = UIColor.green
                 
                swipeImageView.image = UIImage(named: overlayRightImageName)
            default:
                swipeImageView.image = nil
            }
        }
    }

}
