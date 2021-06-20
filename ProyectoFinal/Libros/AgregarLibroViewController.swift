//
//  AgregarLibroViewController.swift
//  ProyectoFinal
//
//  Created by user201654 on 6/19/21.
//

import Foundation
import UIKit
import AudioToolbox

class AgregarLibrosViewController : UIViewController {
    
    @IBOutlet weak var txtISBN: UITextField!
    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtEdicion: UITextField!
    @IBOutlet weak var txtSeleccionarFecha: UITextField!
    @IBOutlet weak var txtAutor: UITextField!
    @IBOutlet weak var txtPais: UITextField!
    @IBOutlet weak var txtEditorial: UITextField!
    @IBOutlet weak var btnAgregarLibro: UIButton!
    let datePicker = UIDatePicker()
    
    fileprivate let servicio = Service<Libro>()
    
    var libros = [Libro]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtISBN.layer.cornerRadius = 22
        txtTitulo.layer.cornerRadius = 22
        txtEdicion.layer.cornerRadius = 22
        txtSeleccionarFecha.layer.cornerRadius = 22
        txtAutor.layer.cornerRadius = 22
        txtPais.layer.cornerRadius = 22
        txtEditorial.layer.cornerRadius = 22
        btnAgregarLibro.layer.cornerRadius = 22
        crearDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        obtenerLibros()
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
    
    
    @IBAction func agregarLibroAction(_ sender: Any) {
        if txtISBN.text == "" || txtTitulo.text == "" || txtEdicion.text == "" || txtSeleccionarFecha.text == "" || txtAutor.text == "" || txtPais.text == "" || txtEditorial.text == ""
        {
            mostrarAlerta(mensaje: "No se pueden dejar campos vacios", title: "Error")
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            print("Brrrrr")
        } else if (existe()) {
            mostrarAlerta(mensaje: "ISBN en uso. Prueba usar otro", title: "Error")
        } else {
            agregarLibro()
        }
    }
    
    fileprivate func agregarLibro() {
        let url = "http://pm2-biblio.atwebpages.com/api/libros.php"
        
        let params = [
            "ISBN" : txtISBN.text!,
            "Titulo" : txtTitulo.text!,
            "Edicion" : txtEdicion.text!,
            "Fecha" : txtSeleccionarFecha.text!,
            "Autor" : txtAutor.text!,
            "Pais" : txtPais.text!,
            "Editorial" : txtEditorial.text!
        ] as [String : Any]
        
        servicio.crear(params: params, url: url) { (error) in
            if let error = error {
                print("Error al agregar el libro ", error)
                return
            }
            
            self.mostrarAlerta(mensaje: "Se agrego el libro con exito", title: "Exito")
            let systemSoundID: SystemSoundID = 1016
            AudioServicesPlaySystemSound(systemSoundID)
            print("twitter(?")
            self.txtISBN.text = ""
            self.txtTitulo.text = ""
            self.txtEdicion.text = ""
            self.txtSeleccionarFecha.text = ""
            self.txtAutor.text = ""
            self.txtPais.text = ""
            self.txtEditorial.text = ""
            
        }
    }
    
    func mostrarAlerta(mensaje: String, title: String) {
        let alerta = UIAlertController(title: title, message: mensaje, preferredStyle: UIAlertController.Style.alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))

        self.present(alerta, animated: true, completion: nil)
    }
    
    fileprivate func obtenerLibros() {
        let url = "http://pm2-biblio.atwebpages.com/api/libros.php"

        servicio.obtener(url: url) { (resultado) in
            switch resultado {
            case .failure(_) :
                print("Error al obtener el libro")
            case .success(let libros) :
                if(!libros.isEmpty) {
                    self.libros = libros
                }
            }
        }
    }
    
    func existe() -> Bool {
        return libros.contains(where: { (libro) in
            if libro.ISBN.uppercased() == self.txtISBN.text?.uppercased() {
                return true
            }
            return false
        })
    }
    
}
