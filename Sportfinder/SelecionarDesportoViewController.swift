//
//  MenuViewController.swift
//  Sportfinder
//
//  Created by João Costa on 29/05/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//


import UIKit

class SelecionarDesportoViewController: UIViewController, UITableViewDataSource {
    
    
    
    var arrayDesportos = [EntityReturnDesportos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //getArrayDesportos()
        teste()
        getArrayDesportos()
        
        /*for d in arrayDesportos {
            print("pedro: " + d.nome)
        }*/
        print(arrayDesportos.count)
    }
    
        func getArrayDesportos(){
        
        var  arrayDesportosAux = [EntityReturnDesportos]()
        var concat = ""
        var urlString = "https://sportfinderapi.000webhostapp.com/slim/api/getDesportos"
        guard let url =  URL (string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response,error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode([EntityReturnDesportos].self, from: data)
                DispatchQueue.main.async {
                    for d in response {
                       concat = concat + d.nome
                        self.arrayDesportos.append(d)
                        //print(arrayDesportosAux.count)
                    }
                    //self.txtTeste.text = concat
                }
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    func teste() {
        print("teste")
        print(arrayDesportos.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDesportos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = arrayDesportos[indexPath.row + 1].nome
        cell.detailTextLabel?.text = "info"
        return cell
    }
}

