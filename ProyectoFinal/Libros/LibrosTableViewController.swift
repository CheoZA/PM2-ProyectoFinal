//
//  LibrosTableViewController.swift
//  ProyectoFinal
//
//  Created by user201654 on 6/17/21.
//

import Foundation
import UIKit

class LibrosTableViewController : UITableViewController {
    
    fileprivate var servicio = Service<Libro>()
    var libros = [Libro]()
    var seElimino: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        obtenerLibros()
    }
    
    fileprivate func obtenerLibros() {
        let url = "http://pm2-biblio.atwebpages.com/api/libros.php"

        
        servicio.obtener(url: url) { (resultado) in
            switch resultado {
            case .failure(let error) :
                print("Error al obtener los libros. Causa: ", error)
            case .success(let libros) :
                if(!libros.isEmpty) {
                    self.libros = libros
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func eliminarLibro(id: String) {
        let url = "http://pm2-biblio.atwebpages.com/api/libros.php?ISBN=\(id)"
        
        servicio.eliminar(url: url) { (error) in
            if let error = error {
                print("Error al eliminar el libro: ", error)
                return
            }
            self.mostrarAlerta(mensaje: "Se elimino el libro con exito", titulo: "Exito")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libros.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alerta = UIAlertController(title: "Se requiere confirmacion", message: "¿Estas seguro que deseas eliminar este libro?", preferredStyle: UIAlertController.Style.alert)

            alerta.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
                let libro = self.libros[indexPath.row]
                self.eliminarLibro(id: libro.ISBN)
                self.obtenerLibros()
            }))
            alerta.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))

            self.present(alerta, animated: true, completion: nil)

        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let libro = self.libros[indexPath.row]
        celda.textLabel?.text = libro.Titulo
        celda.detailTextLabel?.text = libro.Autor
        return celda
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vista = storyboard?.instantiateViewController(withIdentifier: "vEditarLibro") as? EditarLibroViewController
        vista?.libro = self.libros[indexPath.row]
        self.navigationController?.pushViewController(vista!, animated: true)
    }
    
    func mostrarAlerta(mensaje: String, titulo: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
        
    }
}

