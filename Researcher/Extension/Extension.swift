//
//  Extension.swift
//  Researcher
//
//  Created by Anthony Perritano on 12/19/16.
//  Copyright © 2016 Anthony Perritano. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
    }
}

let LOG: XCGLogger = {
    // Setup XCGLogger
    let LOG = XCGLogger.default
    
    let ansiColorLogFormatter: ANSIColorLogFormatter = ANSIColorLogFormatter()
    ansiColorLogFormatter.colorize(level: .verbose, with: .colorIndex(number: 244), options: [.faint])
    ansiColorLogFormatter.colorize(level: .debug, with: .black)
    ansiColorLogFormatter.colorize(level: .info, with: .blue, options: [.underline])
    ansiColorLogFormatter.colorize(level: .warning, with: .red, options: [.faint])
    ansiColorLogFormatter.colorize(level: .error, with: .red, options: [.bold])
    ansiColorLogFormatter.colorize(level: .severe, with: .white, on: .red)
    LOG.formatters = [ansiColorLogFormatter]
    return LOG
}()

extension Array {
    
    // See Swiftz: https://github.com/typelift/Swiftz/blob/master/Swiftz/ArrayExt.swift#L214
    /// Safely indexes into an array by converting out of bounds errors to nils.
    public func safeIndex(i : Int) -> Element? {
        if i < self.count && i >= 0 {
            return self[i]
        } else {
            return nil
        }
    }
}

extension UIStoryboard {
    class func viewController(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}
