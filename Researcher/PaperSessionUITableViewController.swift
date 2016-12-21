//
//  PaperSessionUITableViewController.swift
//  Researcher
//
//  Created by Anthony Perritano on 12/20/16.
//  Copyright © 2016 Anthony Perritano. All rights reserved.
//

import Foundation
import RealmSwift

class PaperSessionUITableViewController: UITableViewController {

    
    var paperSessionResults: Results<PaperSession>?
    var paperSessionNotification: NotificationToken? = nil
    var notificationTokens = [NotificationToken]()
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    deinit {
        paperSessionNotification?.stop()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Mark: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNotifications()
    }
    
    
    func prepareNotifications() {
        
        if let realm = realm {
            paperSessionResults = realm.paperSessions
            paperSessionNotification = paperSessionResults?.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    // Results are now populated and can be accessed without blocking the UI
                    tableView.reloadData()
                    break
                case .update(_, let deletions, let insertions, let modifications):
                    // Query results have changed, so apply them to the UITableView
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                         with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.endUpdates()
                    break
                case .error(let error):
                    // An error occurred while opening the Realm file on the background worker thread
                    fatalError("\(error)")
                    break
                }
            }
        }
    }
}

extension PaperSessionUITableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let er = paperSessionResults {
            return er.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            if (self.paperSessionResults?[indexPath.row]) != nil {
//                self.experiment = experiment
//                self.selectedExperimentIndex = indexPath.row
            }
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PaperSessionTableCell = self.tableView.dequeueReusableCell(withIdentifier: "paperSessionCell") as! PaperSessionTableCell
        
        if let paperSession = self.paperSessionResults?[indexPath.row] {
            cell.titleLabel.text = paperSession.title.uppercased()
        }
        return cell
    }
    
}
