//
//  SidePanelViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 17-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

@objc
protocol NoteViewControllerDelegate {
}

class SidePanelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: NoteViewControllerDelegate?
    
    var notes: Array<Note>!
    
    struct TableView {
        struct CellIdentifiers {
            static let noteCell = "noteCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.noteCell, forIndexPath: indexPath) as NoteCell
        cell.configureForNote(notes[indexPath.row])
        return cell
    }
    
    // Mark: Table View Delegate
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let selectedNote = notes[indexPath.row]
    }
    
}

class NoteCell: UITableViewCell {
    @IBOutlet weak var noteText: UILabel!
    
    func configureForNote(note: Note) {
        textLabel?.text = note.body
    }
}