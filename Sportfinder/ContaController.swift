//
//  ContaController.swift
//  Sportfinder
//
//  Created by pedro on 11/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit
import FirebaseAuth

class ContaController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(GlobalVariables.loggedUserId)
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        try! Auth.auth().signOut()
        //Destroy UserDefaults and MySingleton Data
        UserDefaults.standard.set("", forKey: "userName")
        UserDefaults.standard.synchronize()
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginPage") as! LoginViewController
            
            self.present(loginViewController, animated:true, completion:nil)
        }
    }
    
}
