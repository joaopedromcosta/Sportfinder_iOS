//
//  UserProfileDetails.swift
//  Sportfinder
//
//  Created by pedro on 06/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

class UserProfileDetails: UIViewController{
    var email:String = ""
    var nome:String = ""
    var morada:String = ""
    var total_pontos:String = ""
    
    @IBOutlet weak var lblNomeUser: UILabel!
    @IBOutlet weak var lblEmailUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(nome)
        
        setLabelValues()
    }
    
    func setLabelValues(){
        lblNomeUser.text = nome
        lblEmailUser.text = email
    }
    
}
