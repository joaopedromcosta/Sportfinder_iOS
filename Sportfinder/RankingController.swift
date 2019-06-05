//
//  RankingController.swift
//  Sportfinder
//
//  Created by pedro on 04/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

class RankingController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var delegate: AppDelegate?
    
    var listUsers = [User]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as! AppDelegate
        tableView.rowHeight = 100.0
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
            DispatchQueue.main.async {
                do{
                    let response = try JSONDecoder().decode([User].self, from: data)
                    for user in response{
                        self.listUsers.append(user)
                        concat = concat + "[" + user.id + " / " + user.total_pontos + " pts] " + user.nome + " - " + user.email + " --- "
                        
                        Utilizador.getUser(appDel: self.delegate!)
                        Utilizador.saveUser(nome: user.nome, id: user.id, email: user.email, morada: user.morada, total_pontos: user.total_pontos, appDel: self.delegate!)
                        
                    }
                    print("Reloading data table")
                    self.tableView.reloadData()
                    print(concat)
                } catch let jsonError{
                    print(jsonError)
                }
            }
        }.resume()
    }
    
    
    //MARK: CoreData Functions
    func addUsersToCoreData(){
        
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        let user:User = listUsers[indexPath.row]
        cell.lblUserName.text = user.nome
        cell.lblpontuacao.text = user.total_pontos
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
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
