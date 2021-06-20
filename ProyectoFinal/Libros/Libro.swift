//
//  Libro.swift
//  ProyectoFinal
//
//  Created by user201654 on 6/17/21.
//

import Foundation

struct Libro : Decodable {
    let ISBN : String
    let Titulo : String
    let Edicion : String
    let Fecha : String
    let Autor : String
    let Pais : String
    let Editorial : String
}
