//
//  UserDefaults.swift
//  ProyectoFinal
//
//  Created by user201654 on 6/18/21.
//

import Foundation
import UIKit

extension UserDefaults {
    
    func color(forKey key: String) -> UIColor? {
        guard let colorData = data(forKey: key) else { return nil }
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }

    func set(_ value: UIColor?, forKey key: String) {
        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print(error.localizedDescription)
        }

      }
}
