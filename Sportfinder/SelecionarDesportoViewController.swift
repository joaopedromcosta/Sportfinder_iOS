//
//  MenuViewController.swift
//  Sportfinder
//
//  Created by João Costa on 29/05/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//


import UIKit

class SelecionarDesportoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, CellDesportoDelegate{
    
    func didClickInDesportoCell(nomeDesporto: String, selecionou: Bool) {
        if(selecionou){
            arraYDesportosSelected.append(nomeDesporto)
        } else {
            print(arraYDesportosSelected)
            var index = arraYDesportosSelected.firstIndex(of: nomeDesporto)
            print("pedroindex: " + String(index!))
            arraYDesportosSelected.remove(at: index!)
            print(arraYDesportosSelected)
        }
        
    }
    
    
    
    //MARK:outlet
    @IBOutlet var tvDesportos: UITableView!
    
    //MARK:actions
    
    @IBAction func btnPesquisar(_ sender: Any) {
        desportosSelectNomeToId()
    
        if(!self.hasConnectivity()){
             showAlert(title: "Sem internet", message: "Por favor ligue-se à internet")
            return
        } else if(arraYDesportosSelected.count < 1){
            showAlert(title: "Selecionar Desporto", message: "Tem de selecionar pelo menos um desporto!")
            return
        }
       
        
    }
    
    
    var arrayDesportos = [EntityReturnDesportos]()
    var arraYDesportosSelected = [String]()
    var filteredArrayDesportos = [EntityReturnDesportos]()
    var arrayDesportosId = [String]()
    
    //var searchController = UISearchController()
    //var resultsController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //getArrayDesportos()
        getArrayDesportos()
        
        /*for d in arrayDesportos {
            print("pedro: " + d.nome)
        }*/
        print(arrayDesportos.count)
        
        //self.tvDesportos.backgroundColor = UIColor(red:234/255.0, green:234/255.0, blue:234/255.0, alpha: 1)
        
        self.tvDesportos.rowHeight = 100.0
    
    }
    
    func getArrayDesportos(){
        var concat = ""
        var urlString = "https://sportfinderapi.000webhostapp.com/slim/api/getDesportos"
        guard let url =  URL (string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response,error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                do{
                    let response = try JSONDecoder().decode([EntityReturnDesportos].self, from: data)
                    for d in response {
                        concat = concat + d.nome
                        self.arrayDesportos.append(d)
                        //print(arrayDesportosAux.count)
                    }
                    self.filteredArrayDesportos =  self.arrayDesportos
                    print("Reloading table data..."	)
                    self.tvDesportos.reloadData()
                }catch let jsonError {
                    print(jsonError)
                }
            }
        }.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("entrei na func number of rows " + String(arrayDesportos.count))
        return arrayDesportos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDesporto", for: indexPath) as! TableViewCellDesportos
        let ec:EntityReturnDesportos = arrayDesportos[indexPath.row]
        
        cell.tvNomeDesporto.text = ec.nome
        cell.IVIconDesporto.image = UIImage(named: "football_ball")
        cell.setDesportoNome(nome: ec.nome)
        cell.delegate = self
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
  
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }*/
    
   /* func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       /* UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor yellowColor];*/
        
        var cell  = tableView.cellForRow(at: indexPath)
        var nomeDesporto = arrayDesportos[indexPath.row].nome
        
        var find = false
        var auxCount = -1
        var aux = -1
        
        if ( arraYDesportosSelected.count == 0 ) {
            arraYDesportosSelected.append(nomeDesporto)
            cell?.backgroundColor = UIColor(red:185/255.0, green:253/255.0, blue:216/255.0, alpha: 0.5)
            
        } else {
            for nomeDesp in arraYDesportosSelected {
                aux += 1
                if( nomeDesp ==  nomeDesporto ){
                    find = true
                    auxCount = aux
                    
                }
            }
            
            if (find) {
                arraYDesportosSelected.remove(at: auxCount)
                //cell?.backgroundColor = UIColor.white
            } else {
                arraYDesportosSelected.append(nomeDesporto)
                //cell?.backgroundColor = UIColor(red:185/255.0, green:253/255.0, blue:216/255.0, alpha: 0.5)
            }
        }
        
        print("pedro" + String(arraYDesportosSelected.count))
        //printSelect()
        //verificarDesportoSelecionado(nomeDesporto: arrayDesportos[indexPath.row].nome)
    }
    */
    //searchbar
    override func viewWillAppear(_ animated: Bool) {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder =  "Pesquisar"
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.barTintColor =  UIColor.white
        searchController.searchBar.delegate = self
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableDesportos(searchText: searchText)
    }
    
    func filterTableDesportos(searchText: String){
        arrayDesportos.removeAll()
        if(searchText.isEmpty){
            arrayDesportos.append(contentsOf: filteredArrayDesportos)
        } else {
            for d in filteredArrayDesportos {
                if d.nome.lowercased().contains(searchText.lowercased()) {
                    arrayDesportos.append(d)
                }
            }
        }
        tvDesportos.reloadData()
    }
    
    func desportosSelectNomeToId(){
        arrayDesportosId.removeAll()
        for desp in arraYDesportosSelected {
            for d in arrayDesportos {
                if(desp == d.nome) {
                    arrayDesportosId.append(d.id)
                }
            }
        }
        
        /*for des in arrayDesportosId {
            print ("pedro123 " + des)
        }*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "listarPorDesporto"){
            let vcParquesFiltrados = (segue.destination as! VCParquesFiltrados)
            vcParquesFiltrados.arrayIdDesporto = self.arrayDesportosId
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
    
    func hasConnectivity() -> Bool {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            return true
        }else{
            print("Internet Connection not Available!")
            return false
        }
    }
    
}
