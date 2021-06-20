//
//  PreferenciasViewController.swift
//  ProyectoFinal
//
//  Created by user201654 on 6/17/21.
//

import Foundation
import UIKit

class PreferenciasViewController : CustomUIViewController, UIColorPickerViewControllerDelegate {
    
    @IBOutlet weak var colorSeleccionado: UITextField!
    @IBOutlet weak var btnSeleccionarColor: UIButton!
    
    var color: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        color = UserDefaults.standard.color(forKey: UserSession.usuario)
        colorSeleccionado.backgroundColor = color
    }
    
    @IBAction func seleccionarColor(_ sender: Any) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        present(colorPicker, animated: true)
    }
    
    @IBAction func guardarCambiosAction(_ sender: Any) {
        UserDefaults.standard.set(color, forKey: UserSession.usuario)
        let alerta = UIAlertController(title: "Exito", message: "Se guardaron los cambios con exito", preferredStyle: UIAlertController.Style.alert)

        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))

        self.present(alerta, animated: true, completion: nil)
    }
    
    
    @IBAction func defaultAction(_ sender: Any) {
        color = .systemBackground
        self.navigationController?.navigationBar.barTintColor = color
        colorSeleccionado.backgroundColor = color
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.color = viewController.selectedColor
        self.navigationController?.navigationBar.barTintColor = color
        colorSeleccionado.backgroundColor = color

    }
    
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.color = viewController.selectedColor
        self.navigationController?.navigationBar.barTintColor = color
        colorSeleccionado.backgroundColor = color
    }
    
}
