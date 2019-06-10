//
//  VCParquesFiltrados.swift
//  Sportfinder
//
//  Created by Pedro Couto on 10/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

class VCParquesFiltrados: UIViewController {
    
    var arrayIdDesporto:[String] =  [""]
    
    override func viewDidLoad() {
        print("pedroentreiaqui")
        for des in arrayIdDesporto {
            print ("pedroseque123 " + des)
        }

    }
    
    func getArrayDesportos(){
        
        guard let  jsonData = try? JSONSerialization.data(withJSONObject: arrayIdDesporto, options: []) else {
            return
        }
        var concat = ""
        var urlString = "https://sportfinderapi.000webhostapp.com/slim/api/locais"
        guard let url =  URL (string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        URLSession.shared.getAllTasks{(openTasks: [URLSessionTask]) in
            NSLog("open task: \(openTasks)")
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (responseData: Data?, response: URLResponse?, error: Error?) in
            NSLog("\(response)")
        })
        task.resume()
    }
}


