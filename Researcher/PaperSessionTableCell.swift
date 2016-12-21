//
//  File.swift
//  BeaconTerminal
//
//  Created by Anthony Perritano on 8/18/16.
//  Copyright © 2016 aperritano@gmail.com. All rights reserved.
//

import Foundation
import UIKit
import Material

class PaperSessionTableCell: UITableViewCell {
    
    @IBOutlet weak var shareButton: FabButton!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var favButton: FabButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let reuseIdentifier = "paperSessionCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
