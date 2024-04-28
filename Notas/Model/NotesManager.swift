//
//  NotesManager.swift
//  Notas
//
//  Created by Juan Carlos Díaz Valenzuela on 19/04/24.
//

import Foundation

class NotesManager{
    
    private var notes : [Note] = []
    
    func createNote(note: Note) {
        notes.append(note)
    }
    
    func deleteNote(at index : Int) {
        notes.remove(at: index)
    }
    
    func getNotes() -> [Note] {
        return notes
    }
    
    func getNote(at index : Int) -> Note {
        return notes[index]
    }
    
    func countNotes() -> Int {
        return notes.count
    }
    
    func updateNote(at index: Int, with note: Note) {
        notes[index] = note
    }
    
    func saveNotes() {
        //save json file with created notes
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        //print("DD: ", documentsDirectory)
        
        //v1
        let notesURL = documentsDirectory.appendingPathComponent("notes.json")
        //print("notesURL: ", notesURL)
        
        //v2
        //let notesURL2 = documentsDirectory.appending(component: "notes.json")
        //print("notesURL v2: ", notesURL2)
        
        do{
            let jsonData = try JSONEncoder().encode(notes)
            fileManager.createFile(atPath: notesURL.path, contents: jsonData)
        }
        catch let error{
            print(error)
        }
    }
    
    func loadNotes(){
        //Load notes from json file
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let notesURL = documentsDirectory.appendingPathComponent("notes.json")
        
        //Check if file exists
        if fileManager.fileExists(atPath: notesURL.path){
            do{
                let jsondata = fileManager.contents(atPath: notesURL.path)
                notes = try JSONDecoder().decode([Note].self, from: jsondata! )
            }
            catch let error{
                print("error: ", error)
            }
        }
        else{
            print("No se localizó el archivo")
        }
    }
}
