//
//  AppSnackbarController.swift
//  Researcher
//
//  Created by Anthony Perritano on 12/21/16.
//  Copyright © 2016 Anthony Perritano. All rights reserved.
//

import Foundation
import UIKit
import Material

class AppSnackbarController: SnackbarController {
    open override func prepare() {
        super.prepare()
        delegate = self
    }
}

extension AppSnackbarController: SnackbarControllerDelegate {
    func snackbarController(snackbarController: SnackbarController, willShow snackbar: Snackbar) {
        print("snackbarController will show")
    }
    
    func snackbarController(snackbarController: SnackbarController, willHide snackbar: Snackbar) {
        print("snackbarController will hide")
    }
    
    func snackbarController(snackbarController: SnackbarController, didShow snackbar: Snackbar) {
        print("snackbarController did show")
    }
    
    func snackbarController(snackbarController: SnackbarController, didHide snackbar: Snackbar) {
        print("snackbarController did hide")
    }
}
