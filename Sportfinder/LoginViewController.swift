//
//  LoginViewController.swift
//  Sportfinder
//
//  Created by João Costa on 29/05/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        btnLogin()
    }
    
    func btnLogin (){
        Auth.auth().signIn(withEmail:"commov2019@gmail.com", password: "Commovido207709"){(result,error) in
            if let error = error{
                print("errorrrrrrkjfiuhfhuifhiufuihfrrr")
                return
            }
            print("deu crlh")
            
            
            
        }
       
    }
    
}

