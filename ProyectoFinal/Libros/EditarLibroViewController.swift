//
//  EditarLibroViewController.swift
//  ProyectoFinal
//
//  Created by user201654 on 6/18/21.
//

import Foundation
import UIKit
import AudioToolbox

class EditarLibroViewController : UIViewController {
    
    @IBOutlet weak var txtISBN: UITextField!
    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtEdicion: UITextField!
    @IBOutlet weak var txtSeleccionarFecha: UITextField!
    @IBOutlet weak var txtAutor: UITextField!
    @IBOutlet weak var txtPais: UITextField!
    @IBOutlet weak var txtEditorial: UITextField!
    @IBOutlet weak var btnEditarLibro: UIButton!
    let datePicker = UIDatePicker()
    
    fileprivate let servicio = Service<Libro>()
    
    var libro: Libro!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtISBN.layer.cornerRadius = 22
        txtTitulo.layer.cornerRadius = 22
        txtEdicion.layer.cornerRadius = 22
        txtSeleccionarFecha.layer.cornerRadius = 22
        txtAutor.layer.cornerRadius = 22
        txtPais.layer.cornerRadius = 22
        txtEditorial.layer.cornerRadius = 22
        btnEditarLibro.layer.cornerRadius = 22
        crearDatePicker()
        
        self.txtISBN.text = libro.ISBN
        self.txtTitulo.text = libro.Titulo
        self.txtEdicion.text = libro.Edicion
        self.txtSeleccionarFecha.text = libro.Fecha
        self.txtAutor.text = libro.Autor
        self.txtPais.text = libro.Pais
        self.txtEditorial.text = libro.Editorial
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func crearDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        txtSeleccionarFecha.inputView = datePicker
        txtSeleccionarFecha.inputAccessoryView = crearToolBar()
    }
    
    func crearToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(presionarDone))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
        
    }
    
    @objc func presionarDone() {
        let formateador = DateFormatter()
        formateador.dateFormat = "YYYY-MM-dd"
        
        self.txtSeleccionarFecha.text = formateador.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    @IBAction func editarLibroAction(_ sender: Any) {
        if txtISBN.text == "" || txtTitulo.text == "" || txtEdicion.text == "" || txtSeleccionarFecha.text == "" || txtAutor.text == "" || txtPais.text == "" || txtEditorial.text == ""
        {
            mostrarAlerta(mensaje: "No se pueden dejar campos vacios", title: "Error")
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            print("Brrrrr")
        } else {
            editarLibro()
        }
        
    }
    
    fileprivate func editarLibro() {
        let url = "http://pm2-biblio.atwebpages.com/api/libros.php?ISBN=\(libro.ISBN)"
        
        let params = [
            "ISBN" : txtISBN.text!,
            "Titulo" : txtTitulo.text!,
            "Edicion" : txtEdicion.text!,
            "Fecha" : txtSeleccionarFecha.text!,
            "Autor" : txtAutor.text!,
            "Pais" : txtPais.text!,
            "Editorial" : txtEditorial.text!
        ] as [String : Any]
        
        servicio.editar(params: params, url: url) { (error) in
            if let error = error {
                print("Error al actualizar el libro: ", error)
                return
            }
            self.mostrarAlerta(mensaje: "Se actualizo el libro con exito", title: "Exito")
            let systemSoundID: SystemSoundID = 1016
            AudioServicesPlaySystemSound(systemSoundID)
            print("twitter(?")
        }
    }
    
    func mostrarAlerta(mensaje: String, title: String) {
        let alerta = UIAlertController(title: title, message: mensaje, preferredStyle: UIAlertController.Style.alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))

        self.present(alerta, animated: true, completion: nil)
    }
    
}
