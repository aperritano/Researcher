//
//  BlurredOverlayView.swift
//  Researcher
//
//  Created by Anthony Perritano on 1/14/17.
//  Copyright © 2017 Anthony Perritano. All rights reserved.
//

import Foundation
import PopupDialog

class BlurredOverlayView: UIView {
    
    // MARK: - Appearance
    
    ///  The blur radius of the overlay view
    public dynamic var blurRadius: Float {
        get { return Float(blurView.blurRadius) }
        set { blurView.blurRadius = CGFloat(newValue) }
    }
    
    /// Turns the blur of the overlay view on or off
    public dynamic var blurEnabled: Bool {
        get { return blurView.isBlurEnabled }
        set {
            blurView.isBlurEnabled = newValue
            blurView.alpha = newValue ? 1 : 0
        }
    }
    
    /// Whether the blur view should allow for
    /// dynamic rendering of the background
    public dynamic var liveBlur: Bool {
        get { return blurView.isDynamic }
        set { return blurView.isDynamic = newValue }
    }
    
    /// The background color of the overlay view
    public dynamic var color: UIColor? {
        get { return overlay.backgroundColor }
        set { overlay.backgroundColor = newValue }
    }
    
    /// The opacity of the overay view
    public dynamic var opacity: Float {
        get { return Float(overlay.alpha) }
        set { overlay.alpha = CGFloat(newValue) }
    }
    
    // MARK: - Views
    
    internal lazy var blurView: FXBlurView = {
        let blurView = FXBlurView(frame: .zero)
        blurView.blurRadius = 8
        blurView.isDynamic = false
        blurView.tintColor = UIColor.clear
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return blurView
    }()
    
    internal lazy var overlay: UIView = {
        let overlay = UIView(frame: .zero)
        overlay.backgroundColor = UIColor.black
        overlay.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        overlay.alpha = 0.7
        return overlay
    }()
    
    // MARK: - Inititalizers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View setup
    
    fileprivate func setupView() {
        
        // Self appearance
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.backgroundColor = UIColor.clear
        self.alpha = 0
        
        // Add subviews
        addSubview(blurView)
        addSubview(overlay)
    }
    
}
