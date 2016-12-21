//
//  AppDelegate.swift
//  Researcher
//
//  Created by Anthony Perritano on 12/18/16.
//  Copyright © 2016 Anthony Perritano. All rights reserved.
//

import UIKit
import Material
import XCGLogger
import RealmSwift

var realm: Realm?

let SCHEMEA_VER: UInt64 = 1

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setDefaultRealm()
        
        
        self.testData()
        
        window = UIWindow(frame:UIScreen.main.bounds)
        
//        let pageTabBarController = AppPageTabBarController(viewControllers: viewControllers, selectedIndex: 0)
  
  
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "paperSessionUITableViewController") as! PaperSessionUITableViewController
        
        
        let toolbarController = AppToolbarController(rootViewController: rootViewController)
        
        let menuController = AppMenuController(rootViewController: toolbarController)

        
        window!.rootViewController = menuController
        window!.makeKeyAndVisible()
        
//        UIApplication.shared.statusBarStyle = .default
        
        return true
    }
    
    func setDefaultRealm(withSectionName dbName: String = "default") {
        
        if Platform.isSimulator {
            let testRealmURL = URL(fileURLWithPath: "/Users/aperritano/Desktop/Realm/Researcher\(dbName).realm")
            
            var config = Realm.Configuration(
                // Set the new schema version. This must be greater than the previously used
                // version (if you've never set a schema version before, the version is 0).
                schemaVersion: SCHEMEA_VER,
                
                // Set the block which will be called automatically when opening a Realm with
                // a schema version lower than the one set above
                migrationBlock: { migration, oldSchemaVersion in
                    // We haven’t migrated anything yet, so oldSchemaVersion == 0
                    if (oldSchemaVersion < 1) {
                        // Nothing to do!
                        // Realm will automatically detect new properties and removed properties
                        // And will update the schema on disk automatically
                    }
            })
            
            // Use the default directory, but replace the filename with the username
            config.fileURL = testRealmURL
            
            
            realm = try! Realm(configuration: config)
        } else {
            
            
            var config = Realm.Configuration(
                // Set the new schema version. This must be greater than the previously used
                // version (if you've never set a schema version before, the version is 0).
                schemaVersion: SCHEMEA_VER,
                
                // Set the block which will be called automatically when opening a Realm with
                // a schema version lower than the one set above
                migrationBlock: { migration, oldSchemaVersion in
                    // We haven’t migrated anything yet, so oldSchemaVersion == 0
                    if (oldSchemaVersion < 1) {
                        // Nothing to do!
                        // Realm will automatically detect new properties and removed properties
                        // And will update the schema on disk automatically
                    }
            })
            
            // Use the default directory, but replace the filename with the username
            config.fileURL = config.fileURL!.deletingLastPathComponent()
                .appendingPathComponent("\(dbName).realm")
            
            // Set this as the configuration used for the default Realm
            //Realm.Configuration.defaultConfiguration = config
            
            realm = try! Realm(configuration: config)
            
            LOG.debug("REALM FILE: \(Realm.Configuration.defaultConfiguration.fileURL)")
        }
    }
    
    func testData() {
        let filePath = Bundle.main.path(forResource: "test-cites", ofType: "ris")
        
        let testData = RISFileParser.readFile(filePath!)
        
        
        for (key,value) in testData.enumerated() {
            LOG.debug("\(key) = \(value)")
        }
        
        if let realm = realm {
            try! realm.write {
                let paperSession = PaperSession()
                paperSession.title = "Some Title"
                realm.add(paperSession, update: true)
            }
        }
        
        
        //LOG.debug(testData)
        //self.dataController?.saveResults("TESTER", results: items)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

