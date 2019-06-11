//
//  UserProfileDetails.swift
//  Sportfinder
//
//  Created by pedro on 06/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

class UserProfileDetails: UIViewController{
    var id:String = ""
    var email:String = ""
    var nome:String = ""
    var morada:String = ""
    var total_pontos:String = ""
    
    var listSemanas = [Week]()
    
    @IBOutlet weak var lblNomeUser: UILabel!
    @IBOutlet weak var lblEmailUser: UILabel!
    @IBOutlet weak var lblTotalPontos: UILabel!
    @IBOutlet weak var lblSemanas: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(nome)
        
        setLabelValues()
        getWeekPointsUser(userId: id)
    }
    
    func setLabelValues(){
        lblNomeUser.text = nome
        lblEmailUser.text = email
        lblTotalPontos.text = total_pontos
    }
    
    
    func getWeekPointsUser(userId: String){
        
        var concat = ""
        let urlString =  "https://sportfinderapi.000webhostapp.com/slim/api/getPontoSemana/\(userId)"
        guard let url = URL(string: urlString) else{return}
        
        URLSession.shared.dataTask(with: url){ (data, response, error ) in
            if error != nil{
                print(error!.localizedDescription)
            }
            
            guard let data = data else{return}
            DispatchQueue.main.async {
                do{
                    let response = try JSONDecoder().decode([Week].self, from: data)
                    for week in response{
                        self.listSemanas.append(week)
                        concat = concat + "Semana " + week.pontos + ": " + week.semana_registo + " pontos\n"
                    }
                    self.lblSemanas.text = concat
                    print("Reloading data table")
                    print(concat)
                } catch let jsonError{
                    print(jsonError)
                }
            }
        }.resume()
    }
}
