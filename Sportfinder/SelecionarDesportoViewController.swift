//
//  MenuViewController.swift
//  Sportfinder
//
//  Created by João Costa on 29/05/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//


import UIKit

class SelecionarDesportoViewController: UIViewController, UITableViewDataSource {
    
    //MARK:outlet
    @IBOutlet var tvDesportos: UITableView!
    
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
            
            
            DispatchQueue.main.async {
                do{
                    let response = try JSONDecoder().decode([EntityReturnDesportos].self, from: data)
                    for d in response {
                        concat = concat + d.nome
                        self.arrayDesportos.append(d)
                        //print(arrayDesportosAux.count)
                    }
                    print("Reloading table data..."	)
                    self.tvDesportos.reloadData()
                }catch let jsonError {
                    print(jsonError)
                }
            }
        }.resume()
    }
    
    func teste() {
        print("teste")
        print(arrayDesportos.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("entrei na func number of rows " + String(arrayDesportos.count))
        return arrayDesportos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = arrayDesportos[indexPath.row].nome
        cell.detailTextLabel?.text = "info"
        return cell
    }
}

