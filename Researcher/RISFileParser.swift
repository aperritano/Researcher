//
//  ParseFileHelper.swift
//  PaperX
//
//  Created by Anthony Perritano on 3/13/16.
//  Copyright © 2016 so.raven. All rights reserved.
//

import Foundation
import UIKit

class RISFileParser {
    static let sharedInstance = RISFileParser()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func isSectionStart(_ line: String) -> Bool {
        //LOG.debug("doing reges \(line)")
        let regex = try? NSRegularExpression(pattern: "\\b[A-Z0-9]{2}\\b\\s\\s-",
                options: [])
        let matches = regex!.matches(in: line, options: [], range: NSMakeRange(0, line.characters.count))
        //LOG.debug(matches)
        if matches.count > 0 {
            return true
        }
        return false
    }

//    class func readFile(_ filePath: String) -> [[String:AnyObject]] {
//        var lines = [String]()
//        do {
//            // Get the contents
//            let contents = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
//            lines = contents.components(separatedBy: "\n")
//
//        } catch let error as NSError {
//            ULONG.debug("Ooops! Something went wrong: \(error)")
//        }
//        return parseLines(lines)
//    }
//
//    class func writeRISFile(_ papers: [PaperEntry], filePath: String) {
//        if papers.count > 0 {
//            var fileContents = String()
//            for p in papers {
//                fileContents += p.toEndnoteString()
//            }
//
//
//            sharedInstance.appDelegate.storeFile(filePath, fileContents: fileContents, fileType: "ris")
//
//
//            //LOG.debug("File contents\n \(fileContents)")
//        }
//
//    }

    class func parseLines(_ lines: [String]) -> [[String:AnyObject]] {
        var results = [[String: AnyObject]]()
        var tempDict = [String: AnyObject]()
        var sectionKey: String?

        for index in 0 ..< lines.count {
            let line = lines[index]
//            progressView.progress = Float(index)/Float(totalLineCount)
            if sharedInstance.isSectionStart(line) {
                let sections = line.characters.split {
                    $0 == "-"
                }.map {
                    String($0)
                }
                // LOG.debug("\(index) - \(line)")
                let key = sections[0].trimmingCharacters(in: CharacterSet.whitespaces)

                var lastSection = ""
                if sections.count > 1 {

                    lastSection = sections[1].trimmingCharacters(in: CharacterSet.whitespaces)
                }

                sectionKey = key

                if key == "TY" {
                    tempDict = [String: String]() as [String : AnyObject]
                    tempDict[key] = lastSection as AnyObject?
                } else if key == "ER" {
                    tempDict[key] = "" as AnyObject?
                    results.append(tempDict)
                } else if key == "A1" {
                    //LOG.debug(line)
                    if let authors = tempDict[key] {

                        var a = authors as! [String]

                        a.append(lastSection)
                        tempDict[key] = a as AnyObject?
                    } else {
                        let n: [String] = [lastSection]
                        tempDict[key] = n as AnyObject?
                    }
                } else {
                    tempDict[key] = lastSection as AnyObject?
                }
            } else {

                let val = tempDict[sectionKey!]! as! String

                tempDict[sectionKey!] = val + " " + line as AnyObject?
            }

        }
        // do a post request and return post data
        return results
    }
}
