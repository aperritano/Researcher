//
//  BasicCardView.swift
//  Researcher
//
//  Created by Anthony Perritano on 12/29/16.
//  Copyright © 2016 Anthony Perritano. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class BasicCardView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorsLabel: UILabel!
    
    @IBOutlet weak var abstractLabel: UITextView!
    
    let kDefaultFontSize = 15.0
    
    var paper: Paper? {
        didSet {            
            if let p = paper {
                self.titleLabel.text = p.title
                
                let joinedAuthors = p.authors.stringByDecodingHTMLEntities
                
                self.authorsLabel.text = joinedAuthors
                self.abstractLabel.text = p.abstract
                self.checkTextSize()
            }
            
        }
    }
    
    func checkTextSize() {
        abstractLabel.font = UIFont.systemFont(ofSize: CGFloat(kDefaultFontSize))
        //setup text resizing check here
        if abstractLabel.contentSize.height > abstractLabel.frame.size.height {
            var fontIncrement = 1.0
            while abstractLabel.contentSize.height > abstractLabel.frame.size.height {
                abstractLabel.font = UIFont.systemFont(ofSize: CGFloat(kDefaultFontSize - fontIncrement))
                fontIncrement += 1
            }
        }

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
