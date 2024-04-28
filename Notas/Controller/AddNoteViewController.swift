//
//  AddNoteViewController.swift
//  Notas
//
//  Created by Juan Carlos Díaz Valenzuela on 20/04/24.
//

import UIKit

protocol AddNoteDelegate: AnyObject {
    func didUpdateNote()
}

class AddNoteViewController: UIViewController, UITextViewDelegate {
    
    var detailNote: Note?
    
    var indexNoteSend = -1
    
    @IBOutlet weak var noteTitle: UITextField!
    
    @IBOutlet weak var noteContent: UITextView!
    
    override func viewDidLoad() {
        // Configurar el delegado de noteContent
        noteContent.delegate = self

        super.viewDidLoad()
        if detailNote != nil {
            noteTitle.text = detailNote?.title
            noteContent.text = detailNote?.content
            
        }
        else{
            noteContent.text = "Ingrese el contenido deseado"
            noteContent.textColor = .gray
        }
        // Do any additional setup after loading the view.
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //detailNote = Note(title: noteTitle.text ?? "", content: noteContent.text, date: Date())
        let destination = segue.destination as! NotesViewController
        
        if detailNote == nil {
            detailNote = Note(title: noteTitle.text ?? "", content: noteContent.text, date: Date())
        }
        else{
            detailNote?.title = noteTitle.text!
            detailNote?.content = noteContent.text
        }
        destination.indexNoteReceive = indexNoteSend
        destination.note = detailNote
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Validate note info
        guard let title = noteTitle.text, !title.isEmpty,
              let content = noteContent.text, !content.isEmpty,
              content != "Ingrese el contenido deseado" else {
            // Si el título o el contenido están vacíos, o el contenido es igual a "Ingrese el contenido deseado",
            // mostrar alerta y no permitir la transición
            showAlert(message: "Por favor, completa todos los campos y cambia el contenido.")
            return false
        }
        // Permitir la transición si tanto el título como el contenido no están vacíos
        return true
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        // Cerrar el modal sin realizar ninguna acción
        let isModal = self.presentingViewController is UINavigationController
        //print("isModal: ",isModal)
        if isModal {
            self.dismiss(animated: true)
        }
        else{
            navigationController?.popViewController(animated: true)
        }
    }
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Ingrese el contenido deseado" {
            textView.text = ""
            textView.textColor = .label // Cambiar a color de texto predeterminado
        }
    }
}
