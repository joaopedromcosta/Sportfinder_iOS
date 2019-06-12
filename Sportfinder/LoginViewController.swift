//
//  LoginViewController.swift
//  Sportfinder
//
//  Created by João Costa on 29/05/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordTxt.delegate = self
        emailTxt.delegate = self
        if((Auth.auth().currentUser) != nil){
            print("COM LOGIN FEITO")
            GlobalVariables.loggedUserId = UserDefaults.standard.value(forKey: "userID") as! String
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "menuPrincipal", sender: self)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
        
        if(email.isEmpty && pass.isEmpty){
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
                var concat = ""
                var userEmail:String!
                userEmail = Auth.auth().currentUser?.email
                var emailAspas = "\"" + userEmail! + "\""
                print(emailAspas)
                let urlString =  "https://sportfinderapi.000webhostapp.com/slim/api/getIdFromEmail/\(userEmail!)"

                print(urlString)
                guard let url = URL(string: urlString) else{return}
                
                
                URLSession.shared.dataTask(with: url){ (data, response, error ) in
                    if error != nil{
                        print(error!.localizedDescription)
                    }
                    
                    guard let data = data else{return}
                    //print(data)
                    //self.performSegue(withIdentifier: "menuPrincipal", sender: self)
                    
                    DispatchQueue.main.async {
                        do{
                            //let response = try JSONDecoder().decode([String].self, from: data)
                            let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                            GlobalVariables.loggedUserId = responseString! as String
                            UserDefaults.standard.set(GlobalVariables.loggedUserId, forKey: "userID")
                            UserDefaults.standard.synchronize()
                            self.performSegue(withIdentifier: "menuPrincipal", sender: self)
                        } catch let jsonError{
                            print(jsonError)
                        }
                    }
                    }.resume()
                
            }
        }

        //self.performSegue(withIdentifier: "menuPrincipal", sender: self)
    }
}
