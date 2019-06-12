//
//  VCParquesFiltrados.swift
//  Sportfinder
//
//  Created by Pedro Couto on 10/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

class VCParquesFiltrados: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
    
    var arrayDataLocais = [EntityReturnDataLocais]()
    var filteredArrayLocais = [EntityReturnDataLocais]()
    var lat = "41.692640"
    var lng = "-8.847505"
    var arrayIdDesporto:[String] =  [""]
    var arrayIdAux = [Sport]()
    
    @IBOutlet var tvLocais: UITableView!
    
    override func viewDidLoad() {
        construirJSON()
        getLocais()
        self.tvLocais.rowHeight = 150.0
        
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
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            //Check for errors
            if(err != nil){
                print("Error in request: \(String(describing: err))")
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                do{
                    let response = try JSONDecoder().decode([EntityReturnDataLocais].self, from: data)
                    for l in response {
                        print("-------Pedro")
                        print(l)
                        print("-------Pedro")
                        self.arrayDataLocais.append(l)
                    }
                    self.filteredArrayLocais =  self.arrayDataLocais
                    print("reloading data...")
                     self.tvLocais.reloadData()
                } catch let jsonError {
                    print(jsonError)
                }
               
            }
        }.resume()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDataLocais.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellLocal", for: indexPath) as! TableViewCellLocais
        let ec:EntityReturnDataLocais = arrayDataLocais[indexPath.row] as! EntityReturnDataLocais
        
        cell.lblNomeLocal.text = ec.nome
        cell.lblDistancia.text = String(Int(ec.distancia))+" m"
        let url = URL(string: "https://sportfinderapi.000webhostapp.com/img/compressed/" + ec.urlfotolocal + ".png")
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.IVFotoLocal.image = UIImage(data: data!)
        
        return cell
    }
    
    //searchbar
    override func viewWillAppear(_ animated: Bool) {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder =  "Pesquisar"
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.barTintColor =  UIColor.white
        searchController.searchBar.delegate = self
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtrarTableLocais(searchText: searchText)
    }
    
    func filtrarTableLocais(searchText: String){
        arrayDataLocais.removeAll()
        if(searchText.isEmpty){
            arrayDataLocais.append(contentsOf: filteredArrayLocais)
        } else {
            for d in filteredArrayLocais {
                if d.nome.lowercased().contains(searchText.lowercased()) {
                    arrayDataLocais.append(d)
                }
            }
        }
        tvLocais.reloadData()
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
