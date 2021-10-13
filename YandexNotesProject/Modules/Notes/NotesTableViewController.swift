//
//  NotesTableViewController.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 20/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import UIKit

class NotesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func unwindToNotes(segue: UIStoryboardSegue) {}
    
    let reuseIdentifier = "NoteСell"
    let notes = Notes.initialNotes()
    var isEditingRow = false
    var navButtons = [String: UIBarButtonItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navButtons =  [
            "add": UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote)),
            "edit": UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editMode)),
            "ok": UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(stopRowEditMode)),
            "cancel": UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeEditMode))
        ]
        
        tableView.allowsMultipleSelection = false
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        tableView.tableFooterView = UIView()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Заметки"
        navigationItem.backBarButtonItem = backButton
        
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    private func updateUI() {
        
        if isEditingRow {
            navigationItem.rightBarButtonItem = navButtons["ok"]
            navigationItem.leftBarButtonItem = nil
        } else if tableView.isEditing {
            navigationItem.rightBarButtonItem = nil
            navigationItem.leftBarButtonItem = navButtons["cancel"]
        } else {
            navigationItem.leftBarButtonItem = navButtons["edit"]
            navigationItem.rightBarButtonItem = navButtons["add"]
        }
        
    }
    
    @objc private func addNote() {
        navigateToEditNote()
    }
    
    @objc private func editMode() {
        tableView.setEditing(true, animated: true)
        
        updateUI()
    }
    
    @objc private func stopRowEditMode() {
        isEditingRow = false
        tableView.setEditing(false, animated: true)
    }
    
    @objc private func closeEditMode() {
        tableView.setEditing(false, animated: true)
        
        updateUI()
    }
    
    private func navigateToEditNote() {
        performSegue(withIdentifier: "notesEdit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "notesEdit",
            let controller = segue.destination as? EditNoteViewController  {
            
            controller.delegate = self
            
            if let selectedRowIndexPath = tableView.indexPathForSelectedRow {
                let note = notes.get(selectedRowIndexPath.row)
                controller.note = note
                tableView.deselectRow(at: selectedRowIndexPath, animated: false)
            }
        }
        
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NotesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        
        let note = notes.get(indexPath.row)
        
        cell.titleLabel.text = note.title
        cell.noteLabel.text = note.content
        if note.color == .white {
            cell.colorView.isHidden = true
        } else {
            cell.colorView.isHidden = false
            cell.colorView.backgroundColor = note.color
        }
        
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        isEditingRow = true
        updateUI()
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        isEditingRow = false
        updateUI()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let deletedNote = notes.get(indexPath.row)
            notes.remove(with: deletedNote.uid)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToEditNote()
    }
    
}

// MARK: - NotesLoader
extension NotesTableViewController: NotesLoader {
    
    func loadNote(_ note: Note) {
        tableView.beginUpdates()
        let _index = notes.edit(note)
        if let index = _index {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        } else {
            notes.add(note)
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
}
