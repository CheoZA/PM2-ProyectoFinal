//
//  ViewController.swift
//  ProyectoFinal
//
//  Created by user201654 on 6/15/21.
//

import UIKit
import AudioToolbox

class IniciarSesionViewController: UIViewController {

    @IBOutlet weak var txtContrasena: UITextField!
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var btnIniciarSesion: UIButton!

    fileprivate let servicio = Service<Usuario>()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtUsuario.layer.cornerRadius = 22
        txtContrasena.layer.cornerRadius = 22
        btnIniciarSesion.layer.cornerRadius = 22
        
        self.navigationController?.navigationBar.barTintColor = .systemBackground

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    @IBAction func inicarSesion(_ sender: Any) {
        if txtUsuario.text == "" || txtContrasena.text == "" {
            mostrarAlertaError(mensaje: "No se pueden dejar campos vacios")
        } else {
            inicarSesion()
        }

    }

    fileprivate func inicarSesion() {
        let nombreUsuario = txtUsuario.text
        let contrasena = txtContrasena.text
        let url = "http://pm2-biblio.atwebpages.com/api/usuarios.php?NombreUsuario=\(nombreUsuario!)"

        
        servicio.obtener(url: url) { (resultado) in
            switch resultado {
            case .failure(_) :
                self.mostrarAlertaError(mensaje: "Usuario o contraseña incorrectos")
            case .success(let usuarios) :
                if(!usuarios.isEmpty && contrasena == usuarios[0].Contrasena) {
                    //Sesion iniciada
                    UserSession.usuario = usuarios[0].NombreUsuario
                    let vista = self.storyboard?.instantiateViewController(identifier: "vTabBar") as? TabBarController

                    self.navigationController?.pushViewController(vista!, animated: true)
                    self.txtUsuario.text = ""
                    self.txtContrasena.text = ""
                } else {
                    self.mostrarAlertaError(mensaje: "Usuario o contraseña incorrectos")
                }
            }
        }
    }
    
    func mostrarAlertaError(mensaje: String) {
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: UIAlertController.Style.alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        print("Brrrrr")
        self.present(alerta, animated: true, completion: nil)
    }
}

