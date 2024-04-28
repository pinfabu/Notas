//
//  NotesViewController.swift
//  Notas
//
//  Created by Juan Carlos Díaz Valenzuela on 19/04/24.
//

import UIKit

class NotesViewController: UITableViewController {
    
    @IBOutlet var noteList: UITableView!
    
    @IBOutlet var emptyNotesView: UIView!
    
    var notesManager = NotesManager()
    
    var note : Note!
    
    var indexNoteReceive = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesManager.loadNotes()
        updateEmptyNotesViewVisibility()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateEmptyNotesViewVisibility()
    }
    
    func updateEmptyNotesViewVisibility() {
        if notesManager.countNotes() == 0 {
            emptyNotesView.isHidden = false
            noteList.backgroundView = emptyNotesView
        } else {
            emptyNotesView.isHidden = true
        }
    }
    
    // Dentro de NotesViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNote" {
            //print("Segue edit note")
            let destination = segue.destination as! AddNoteViewController
            //destination.detailNote =
            destination.detailNote = notesManager.getNote(at: noteList.indexPathForSelectedRow!.row)
            destination.indexNoteSend = noteList.indexPathForSelectedRow!.row
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notesManager.countNotes()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NoteCell
        cell?.noteTitle.text = notesManager.getNote(at: indexPath.row).title
        cell?.noteDate.text = notesManager.getNote(at: indexPath.row).date.iso8601String
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editNote", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Eliminar la nota de la fuente de datos
            notesManager.deleteNote(at: indexPath.row)
            notesManager.saveNotes()
            
            // Eliminar la fila de la tabla
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if notesManager.countNotes() == 0 {
                // Si no hay más notas después de eliminar, muestra la vista emptyNotesView
                emptyNotesView.isHidden = false
                noteList.backgroundView = emptyNotesView
            }
            tableView.endUpdates()
        }
    }
    
    //Unwind segue
    @IBAction func unwidToNotesViewController(_ segue : UIStoryboardSegue){
        let source = segue.source as! AddNoteViewController
        if indexNoteReceive == -1{
            notesManager.createNote(note: note!)
        }
        else{
            notesManager.updateNote(at: indexNoteReceive, with: source.detailNote!)
        }
        notesManager.saveNotes()
        noteList.reloadData()
        updateEmptyNotesViewVisibility()
        
    }
    
}
