//
//  RankingController.swift
//  Sportfinder
//
//  Created by pedro on 04/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

class RankingController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var listUsers = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadUsersFromDB()
        
        print(listUsers.count)
        //createListUsersForArray()
    }
    
    
    func loadUsersFromDB(){
        var concat = ""
        let urlString =  "https://sportfinderapi.000webhostapp.com/slim/api/getUtilizadores"
        guard let url = URL(string: urlString) else{return}
        
        URLSession.shared.dataTask(with: url){ (data, response, error ) in
            if error != nil{
                print(error!.localizedDescription)
            }
            
            guard let data = data else{return}
            
            do{
                let response = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    for user in response{
                        self.listUsers.append(user)
                        concat = concat + "[" + user.id + " / " + user.total_pontos + " pts] " + user.nome + " - " + user.email + " --- "
                    }
                    print(concat)
                    self.tableView.reloadData()
                }
            } catch let jsonError{
                print(jsonError)
            }
        }.resume()
    }
    
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        let user:User = listUsers[indexPath.row]
        cell.lblUserName.text = user.nome
        cell.lblpontuacao.text = user.total_pontos //String(user.pontuacao)
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.performSegue(withIdentifier: "openProfileSegue", sender: tableView)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let viewProfile = UITableViewRowAction(style: .default, title: "Ver Perfil") {
            action, index in print("Ver: " + String(index.row))
        }
        viewProfile.backgroundColor = UIColor.blue;
        
        return [viewProfile]
    }
    
}
