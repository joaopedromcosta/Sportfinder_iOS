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
        tableView.allowsSelection = false
        // Do any additional setup after loading the view.
        loadUsersFromDB()
        
        print(listUsers.count)
        //createListUsersForArray()
    }
    
    func hasConnectivity() -> Bool {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            return true
        }else{
            print("Internet Connection not Available!")
            return false
        }
    }
    
    
    func loadUsersFromDB(){
        var concat = ""
        let urlString =  "https://sportfinderapi.000webhostapp.com/slim/api/getUtilizadores"
        guard let url = URL(string: urlString) else{return}
        
        var listUtilizadores = [Utilizador]()
        listUtilizadores = Utilizador.getUser(appDel: self.delegate!)!
        
        if(!self.hasConnectivity()){
            print("Nao tem internet")
            for u in listUtilizadores{
                var user1 = User()
                user1.id = u.id
                user1.nome = u.nome
                user1.email = u.email
                user1.morada = u.morada
                user1.total_pontos = u.total_pontos
                self.listUsers.append(user1)
            
                self.tableView.reloadData()
            }
        }
        else{
            print("Tem internet")
            
            for u in listUtilizadores{
                Utilizador.delete(id: u.id, appDel: self.delegate!)
            }
            
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
        cell.lblPosicao.text = String(indexPath.row + 1)
        cell.lblUserName.text = user.nome
        cell.lblpontuacao.text = user.total_pontos + " pts"

        if(indexPath.row != 0){
            cell.imgFirstPlaceIcon.isHidden = true
        }
        
        var viewProfileArrow = UIButton(type: .custom) as UIButton
        viewProfileArrow.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        viewProfileArrow.addTarget(self, action: #selector(accessoryButtonTapped), for: .touchUpInside)
        viewProfileArrow.setImage(UIImage(named: "arrowRow"), for: UIControl.State.normal)
        
        cell.accessoryView = viewProfileArrow as UIView

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("SENDER: \(indexPath)")
        self.performSegue(withIdentifier: "openProfileSegue", sender: indexPath)
    }
    
    /*
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let viewProfile = UITableViewRowAction(style: .default, title: "Ver Perfil") {
            action, index in
            print("Ver: " + String(index.row))
            print("SENDER: \(indexPath)")
            self.performSegue(withIdentifier: "openProfileSegue", sender: indexPath)
        }
        viewProfile.backgroundColor = UIColor.blue;
        
        return [viewProfile]
    }
 */
    @objc func accessoryButtonTapped(sender: UIButton!) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        if(self.hasConnectivity()){
            self.performSegue(withIdentifier: "openProfileSegue", sender: indexPath)
        } else{
            showAlert(title: "Sem internet", message: "Por favor ligue-se à internet")
        }
    }
    
    //MARK: prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openProfileSegue"){
            let id = sender as! IndexPath
            let userProfileDetails = (segue.destination as! UserProfileDetails)
            userProfileDetails.id = listUsers[id.row].id
            userProfileDetails.nome = listUsers[id.row].nome
            userProfileDetails.email = listUsers[id.row].email
            userProfileDetails.morada = listUsers[id.row].morada
            userProfileDetails.total_pontos = listUsers[id.row].total_pontos
        }	
    }
    
    
    func showAlert(title:String, message:String){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}
