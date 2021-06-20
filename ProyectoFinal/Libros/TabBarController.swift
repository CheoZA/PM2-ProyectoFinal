//
//  TabBarController.swift
//  ProyectoFinal
//
//  Created by user201654 on 6/17/21.
//

import Foundation
import UIKit

class TabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if (self.selectedIndex) < 2 {
                self.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.selectedIndex) > 0 {
                self.selectedIndex -= 1
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true

        //Boton cerrar sesion
        let cerrarSesionButton = UIBarButtonItem(title: "Cerrar Sesion", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cerrarSesion(sender:)))
        self.navigationItem.leftBarButtonItem = cerrarSesionButton
        
        //Boton de preferencias
        let preferenciasButton = UIBarButtonItem(title: "Preferencias >", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.mostrarPreferencias(sender:)))
        self.navigationItem.rightBarButtonItem = preferenciasButton
        
        //Configuracion del color
        self.navigationController?.navigationBar.barTintColor = UserDefaults.standard.color(forKey: UserSession.usuario)
        self.tabBar.backgroundColor = UserDefaults.standard.color(forKey: UserSession.usuario)
        
    }
    
    @objc func cerrarSesion(sender: UIBarButtonItem) {
        let alerta = UIAlertController(title: "Cerrar sesion", message: "¿Estas seguro que deseas cerrar sesion?", preferredStyle: UIAlertController.Style.alert)

        alerta.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
            print("Se cerro sesion")
        }))
        alerta.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))

        self.present(alerta, animated: true, completion: nil)
    }
    
    @objc func mostrarPreferencias(sender: UIBarButtonItem) {
        let vista = storyboard?.instantiateViewController(identifier: "vPreferencias") as? PreferenciasViewController

        self.navigationController?.pushViewController(vista!, animated: true)
    }
}
