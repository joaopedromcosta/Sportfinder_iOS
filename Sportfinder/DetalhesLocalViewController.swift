//
//  DetalhesLocalViewController.swift
//  Sportfinder
//
//  Created by Benjamim on 10/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

class DetalhesLocalViewController: UIViewController {

    var idRecebido = ""
    //
    var detLocal = EntityLocalDetalhes(string: "a")
    // MARK: Labels
    @IBOutlet weak var lblNomeParque: UILabel!
    @IBOutlet weak var lblDescriParque: UILabel!
    @IBOutlet weak var lblRaio: UILabel!
    // MARK: ImageView
    @IBOutlet weak var imageView: UIImageView!
    // MARK: Buttons
    @IBAction func butAdicionarFav(_ sender: Any) {
        //self.lblNomeParque.text = self.detLocal.nome
        //let url = "https://sportfinderapi.000webhostapp.com/img/" + self.detLocal.url_foto_local + ".png"
        //print(url)
        //let urlP = URL(string: url)!
        //self.setImage(from: urlP)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(idRecebido + "view did load??")
        getLocalidade()
    }
    
    func getLocalidade(){
        
        
        let urlJsonString = "https://sportfinderapi.000webhostapp.com/slim/api/getDadosLocalidade/"+self.idRecebido
        print(urlJsonString)
        guard let url = URL(string: urlJsonString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
             DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode([EntityLocalDetalhes].self, from: data)
                    for d in response {
                        print(d.nome)
                        self.detLocal = d
                        // Labels
                        self.lblNomeParque.text = self.detLocal.nome
                        self.lblDescriParque.text = self.detLocal.descricao
                        self.lblRaio.text = "Raio: " + self.detLocal.raio
                        // Image
                        let url = "https://sportfinderapi.000webhostapp.com/img/" + self.detLocal.url_foto_local + ".png"
                        let urlP = URL(string: url)!
                        self.setImage(from: urlP)
                        
                    }
                    
                } catch let jsonErr {
                    print(jsonErr)
                    }
            }
            
            }.resume()
        
        setLabels()
        //self.lblNomeParque.text = self.detLocal.nome
    }
    
    func setLabels(){
        self.lblNomeParque.text = self.detLocal.nome
    }


        
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func setImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
