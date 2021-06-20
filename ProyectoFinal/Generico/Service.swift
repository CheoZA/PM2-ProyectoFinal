//
//  Service.swift
//  ProyectoFinal
//
//  Created by user201654 on 6/18/21.
//

import Foundation

class Service<T : Decodable> : NSObject {
    
    //Obtener todos o uno
    func obtener(url: String, completion: @escaping(Result<[T], Error>) -> ()) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, resp, error) in DispatchQueue.main.async {
                if let error = error {
                    print("Error al tratar de obtener todos. Causa: ", error)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let resultados = try JSONDecoder().decode([T].self, from: data)
                    completion(.success(resultados))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func crear(params: [String : Any], url: String, completion: @escaping(Error?) -> ()) {
        guard let url = URL(string: url) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: .init())
            urlRequest.httpBody = data
            
            URLSession.shared.dataTask(with: urlRequest) {
                (data, response, error) in DispatchQueue.main.async {
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    //Esto es por si ocurre algun error 404 o algo por el estilo
                    if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                        let mensajeError = String(data: data ?? Data(), encoding: .utf8) ?? ""
                        completion(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : mensajeError]))
                        return
                    }
                    completion(nil)
                    
                }
            }.resume()
        } catch {
            completion(error)
        }
    }
    
    func editar(params: [String : Any], url: String, completion: @escaping(Error?) -> ()) {
        guard let url = URL(string: url) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: .init())
            urlRequest.httpBody = data
            
            URLSession.shared.dataTask(with: urlRequest) {
                (data, response, error) in DispatchQueue.main.async {
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    //Esto es por si ocurre algun error 404 o algo por el estilo
                    if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                        let mensajeError = String(data: data ?? Data(), encoding: .utf8) ?? ""
                        completion(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : mensajeError]))
                        return
                    }
                    
                    completion(nil)
                }
            }.resume()
        } catch {
            completion(error)
        }
    }
    
    func eliminar(url: String, completion: @escaping(Error?) -> ()) {
        guard let url = URL(string: url) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                }
                
                //Esto es por si ocurre algun error 404 o algo por el estilo
                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                    let mensajeError = String(data: data ?? Data(), encoding: .utf8) ?? ""
                    completion(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : mensajeError]))
                    return
                }
                
                completion(nil)
            }
        }.resume()
    }
}
