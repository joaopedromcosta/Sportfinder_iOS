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
    
    //MARK: Properties
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var txtError: UILabel!
    
    //MARK: Action
    @IBAction func btnLogin(_ sender: Any) {
        var email: String
        var pass: String
        email = txtEmail.text!
        pass = txtPassword.text!
        btnLogin(email: email,pass: pass)
    }
    
    func btnLogin (email:String,pass:String){
        print(email)
        print(pass)
        
        /*if(email.isEmpty && pass.isEmpty){
            txtError.text = "Por favor insira as credenciais"
            return
        }else if(email.isEmpty){
            txtError.text = "Insira um Email"
            return
        } else if(pass.isEmpty){
            txtError.text = "Insira uma Password"
            return
        }else {
            Auth.auth().signIn(withEmail:email, password: pass){(result,error) in
                if let error = error{
                    self.txtError.text = "Credenciais inválidas"
                    return
                }
                self.performSegue(withIdentifier: "menuPrincipal", sender: self)
                
                
                
            }
        }*/

        self.performSegue(withIdentifier: "menuPrincipal", sender: self)        
    }
}
