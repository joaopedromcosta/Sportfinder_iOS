//
//  VCParquesFiltrados.swift
//  Sportfinder
//
//  Created by Pedro Couto on 10/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

class VCParquesFiltrados: UIViewController {
    var lat = "41.692640"
    var lng = "-8.847505"
    var arrayIdDesporto:[String] =  [""]
    var arrayIdAux = [Sport]()
    
    override func viewDidLoad() {
        construirJSON()
        getLocais()
        
    }
    
    func construirJSON(){
        print(arrayIdDesporto)
        var idTMP: Sport
        for d in arrayIdDesporto {
            idTMP = Sport(id: d)
            arrayIdAux.append(idTMP)
        }
        var jsonFinal: JSONData
        jsonFinal = JSONData()
        jsonFinal.lat = lat
        jsonFinal.lng = lng
        jsonFinal.sports = arrayIdAux
        print(jsonFinal)
    }
    
    func getLocais(){
        var request = URLRequest(url: URL(string: "https://sportfinderapi.000webhostapp.com/slim/api/getlocais2")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let dados = JSONData(lat: self.lat, lng: self.lng, sports: self.arrayIdAux)
            let jsonBody = try JSONEncoder().encode(dados)
            request.httpBody = jsonBody
            print("JSON body: ", String(bytes: jsonBody, encoding: .utf8)!)
        }catch {
            print("Erro na preparação dos dados")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            //Check for errors
            if(err != nil){
                print("Error in request: \(String(describing: err))")
            }
            //check for status 200 ok
            if let httpresponse = response as? HTTPURLResponse {
                if httpresponse.statusCode != 200{
                    print("Bad request!")
                    return
                }else{
                    print("Request status code: \(httpresponse.statusCode)")
                }
            }
            var aux = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(aux)
            //Executar mudanca na BD
            //FavoritosCell.delete(id: id_local, appDel: self.delegate!)
            //self.loadLocaisFromCoreData()
            //
            //let alert = UIAlertController(title: "Favorito Removido", message: "Local removido dos favoritos", preferredStyle: .alert)
            //alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil))
            //self.present(alert,animated: true)
        }
        task.resume()
    }
    
    
}
struct JSONData: Codable {
    var lat: String?
    var lng: String?
    var sports: [Sport]?
}
// MARK: - Sport
struct Sport: Codable {
    let id: String
}
