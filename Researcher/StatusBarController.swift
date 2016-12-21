//
//  StatusBarController.swift
//  Researcher
//
//  Created by Anthony Perritano on 12/21/16.
//  Copyright © 2016 Anthony Perritano. All rights reserved.
//

import UIKit
import Material

class AppStatusBarController: StatusBarController {
    open override func prepare() {
        super.prepare()
        
        prepareStatusBar()
    }
}

extension AppStatusBarController {
    fileprivate func prepareStatusBar() {
        statusBarStyle = .lightContent
        statusBar.backgroundColor = Color.blue.base
    }
}
