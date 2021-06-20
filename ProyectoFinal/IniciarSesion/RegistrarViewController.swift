//
//  RegistrarViewController.swift
//  ProyectoFinal
//
//  Created by user201654 on 6/19/21.
//

import Foundation
import UIKit
import AudioToolbox

class RegistrarViewController : CustomUIViewController {
    
    @IBOutlet weak var txtNombreUsuario: UITextField!
    @IBOutlet weak var txtContrasena: UITextField!
    @IBOutlet weak var txtConfirmar: UITextField!
    @IBOutlet weak var btnCrearUsuario: UIButton!
    
    fileprivate let servicio = Service<Usuario>()
    var usuarios = [Usuario]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtNombreUsuario.layer.cornerRadius = 22
        txtContrasena.layer.cornerRadius = 22
        txtConfirmar.layer.cornerRadius = 22
        btnCrearUsuario.layer.cornerRadius = 22
        
        txtNombreUsuario.text = ""
        txtContrasena.text = ""
        txtConfirmar.text = ""
        
        obtenerUsuarios()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Configuracion del color
        self.navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func crearUsuarioAction(_ sender: Any) {
        if(txtNombreUsuario.text == "" || txtContrasena.text == "" || txtConfirmar.text == "") {
            self.mostrarAlertaError(mensaje: "No se pueden dejar campos vacios")
        } else if (txtContrasena.text != txtConfirmar.text) {
            self.mostrarAlertaError(mensaje: "Las contraseñas no coinciden")
        } else if existe() {
            self.mostrarAlertaError(mensaje: "Nombre de usuario en uso")
        } else {
            self.crearUsuario()
        }
    }
    
    fileprivate func crearUsuario() {
        let url = "http://pm2-biblio.atwebpages.com/api/usuarios.php"
        
        let params = [
            "NombreUsuario" : txtNombreUsuario.text!,
            "Contrasena" : txtContrasena.text!
        ] as [String : Any]
        
        servicio.crear(params: params, url: url) { (error) in
            if let error = error {
                self.mostrarAlertaError(mensaje: "Nombre de usuario en uso")
                print("Error al agregar el usuario ", error)
                return
            }
            
            let alerta = UIAlertController(title: "Exito", message: "Se creo el usuario exitosamente. Sera redirigido a la pantalla de iniciar sesion", preferredStyle: UIAlertController.Style.alert)

            alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))

            self.present(alerta, animated: true, completion: nil)
            let systemSoundID: SystemSoundID = 1016
            AudioServicesPlaySystemSound(systemSoundID)
            print("twitter(?")

        }
    }
    
    fileprivate func obtenerUsuarios() {
        let url = "http://pm2-biblio.atwebpages.com/api/usuarios.php"

        servicio.obtener(url: url) { (resultado) in
            switch resultado {
            case .failure(_) :
                print("Error al obtener el usuario ")
            case .success(let usuarios) :
                if(!usuarios.isEmpty) {
                    self.usuarios = usuarios
                    print(usuarios)
                }
            }
        }
    }
    
    func existe() -> Bool{
        return usuarios.contains(where: { (usuario) in
            if usuario.NombreUsuario == self.txtNombreUsuario.text {
                return true
            }
            return false
        })
    }
    
    func mostrarAlertaError(mensaje: String) {
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: UIAlertController.Style.alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        print("Brrrrr")
        self.present(alerta, animated: true, completion: nil)
    }
    
}
