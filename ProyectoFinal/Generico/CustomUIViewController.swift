//
//  CustomUIViewController.swift
//  ProyectoFinal
//
//  Created by user201654 on 6/17/21.
//

import Foundation
import UIKit

class CustomUIViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Boton de regresar
        let regresarButton = UIBarButtonItem()
        regresarButton.title = "Regresar"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = regresarButton
        
        //Configuracion del color
        self.navigationController?.navigationBar.barTintColor = UserDefaults.standard.color(forKey: UserSession.usuario)
        
    }
    
}
