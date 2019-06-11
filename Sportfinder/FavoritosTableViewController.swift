//
//  FavoritosTableViewController.swift
//  Sportfinder
//
//  Created by João Costa on 10/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

class FavoritosTableViewController: UITableViewController, UISearchBarDelegate{
    //
    var delegate: AppDelegate?
    var userID:String = "5"
    //
    var locaisArray = [EntityLocal]()
    var locaisArrayFiltrados = [EntityLocal]()
    //
    var numImagensObtidas = 0
    var coreDataLido = false
    //
    var searchTerms = ""
    var searchWasCancelled = false
    //
    @IBOutlet var tableViewReference: UITableView!
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as! AppDelegate
        //
        //userID = GlobalVariables.loggedUserId
        print("User ID: \(userID)")
        //
        self.tableViewReference.refreshControl?.addTarget(self, action: #selector(FavoritosTableViewController.refreshUsers), for: UIControl.Event.valueChanged)
        //
        loadLocaisFromCoreData()
    }
    //
    @objc func refreshUsers(){
        loadDataFromDB()
        //self.refreshControl?.endRefreshing()
    }
    //
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
extension FavoritosTableViewController: FavoritosTableViewCellDelegate{
    func didClickRemoveFavorito(id_local: String, nome_local:String) {
        let alert = UIAlertController(title: "Remover Favorito", message: "De certeza que pretende remover '\(nome_local)' dos favorito?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: { action in
            print("Remover favorito")
            //Add to favoritos or remove from there
            //
            //Chamar WS
            self.removerFavorito(id_user: self.userID, id_local: id_local)
        }))
        alert.addAction(UIAlertAction(title: "Não", style: .default, handler: { action in
            print("Stoping changing favorito")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func filterTable(searchText: String){
        locaisArrayFiltrados.removeAll()
        if(searchText.isEmpty){
            for local in locaisArray {
                locaisArrayFiltrados.append(local)
            }
        }else{
            for local in locaisArray {
                if local.nome.lowercased().contains(searchText.lowercased()){
                    locaisArrayFiltrados.append(local)
                }
            }
        }
        tableViewReference.reloadData()
    }
    func loadDataFromDB() {
        //
        if !hasConnectivity() {
            print("Sem conexão para obter dados para obter novos dados")
            //Alerta de falta de acesso a internet
            let alert = UIAlertController(title: "Sem Conexão Internet", message: "Conecte-se à internet para atualizar os favoritos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil))
            present(alert,animated: true)
            self.tableViewReference.reloadData()
            self.refreshControl?.endRefreshing()
        }else{
            //print("A obter dados atualizados...")
            let webServiceStringURL = "https://sportfinderapi.000webhostapp.com/slim/api/getLocaisFavUtilizador/"+self.userID
            guard let url = URL.init(string: webServiceStringURL) else {return}
            //
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                //Check for errors
                if(err != nil){
                    print("Error in request: \(String(describing: err))")
                }
                //check for status 200 ok
                if let httpresponse = response as? HTTPURLResponse {
                    if httpresponse.statusCode != 200{
                        print("Bad request!")
                        return
                    }else{
                        print("Request status code: \(httpresponse.statusCode)")
                    }
                }
                //
                //
                self.numImagensObtidas = 0
                self.locaisArray.removeAll()
                self.locaisArrayFiltrados.removeAll()
                if let data = data{
                    DispatchQueue.main.async {
                        do{
                            let localRequest = try JSONDecoder().decode([LocaisFormat].self, from: data)
                            let arrayLocaisTmp = localRequest
                            var local1:EntityLocal
                            let arraySize = arrayLocaisTmp.count-1
                            if(arrayLocaisTmp.isEmpty){
                                FavoritosCell.removerLocais(appDel: self.delegate!)
                                self.refreshControl?.endRefreshing()
                                self.tableViewReference.reloadData()
                                return
                            }else{
                                for index in 0...arraySize{
                                    local1 = EntityLocal()
                                    local1.id_local = arrayLocaisTmp[index].id!
                                    local1.nome = arrayLocaisTmp[index].nome!
                                    let numeroFloat = Float(arrayLocaisTmp[index].media_local!)
                                    let numero = String(format: "%.1f", numeroFloat!)
                                    local1.mediaLocal = numero
                                    local1.foto_url = "https://sportfinderapi.000webhostapp.com/img/compressed/"+arrayLocaisTmp[index].url_foto_local!+".png"
                                    self.locaisArray.append(local1)
                                }
                                //
                                self.locaisArrayFiltrados.append(contentsOf: self.locaisArray)
                                //self.tableViewReference.reloadData()
                                self.getImagesAndReloadTable()
                            }
                        }catch let jsonErr{
                            print("JSON decode error: ", jsonErr)
                        }
                    }
                }
                }.resume()
        }
    }
    func getImagesAndReloadTable(){
        for item in locaisArray {
            let url = URL(string: item.foto_url)
            if(url != nil){
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        if(data != nil){
                            //print("Extrair imagem")
                            item.foto = UIImage(data: data!)
                            //print("Reloading favorites table...")
                            self.tableViewReference.reloadData()
                            
                        }else{
                            item.foto = UIImage(contentsOfFile: "nopicture")
                            self.tableViewReference.reloadData()
                        }
                        self.numImagensObtidas = self.numImagensObtidas+1
                        if self.numImagensObtidas == self.locaisArray.count{
                            //print("Todas as imagens foram carregadas")
                            self.guardarLocaisCoreData()
                        }
                    }
                }
            }
        }
    }
    func guardarLocaisCoreData(){
        FavoritosCell.removerLocais(appDel: self.delegate!)
        //Guardar no CoreData
        for local in locaisArray {
            FavoritosCell.guardarLocal(local: local, appDel: self.delegate!)
        }
        self.refreshControl?.endRefreshing()
        //
    }
    func loadLocaisFromCoreData(){
        locaisArray.removeAll()
        locaisArrayFiltrados.removeAll()
        coreDataLido = true
        //print("check core data for locais")
        self.locaisArray = FavoritosCell.getLocais(appDel: self.delegate!)!
        if(!locaisArray.isEmpty){
            self.locaisArrayFiltrados.append(contentsOf: self.locaisArray)
            self.tableViewReference.reloadData()
        }else{
            loadDataFromDB()
        }
    }
    func removerFavorito(id_user: String, id_local: String){
        var request = URLRequest(url: URL(string: "https://sportfinderapi.000webhostapp.com/slim/api/removerfavorito")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let dados = EntityLocalJSON(id_user: id_user, id_local: id_local)
            let jsonBody = try JSONEncoder().encode(dados)
            request.httpBody = jsonBody
            print("JSON body: ", String(bytes: jsonBody, encoding: .utf8)!)
        }catch {
            print("Erro na preparação dos dados")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            //Check for errors
            if(err != nil){
                print("Error in request: \(String(describing: err))")
            }
            //check for status 200 ok
            if let httpresponse = response as? HTTPURLResponse {
                if httpresponse.statusCode != 200{
                    print("Bad request!")
                    return
                }else{
                    print("Request status code: \(httpresponse.statusCode)")
                }
            }
            //Executar mudanca na BD
            FavoritosCell.delete(id: id_local, appDel: self.delegate!)
            self.loadLocaisFromCoreData()
            //
            let alert = UIAlertController(title: "Favorito Removido", message: "Local removido dos favoritos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil))
            self.present(alert,animated: true)
        }
        task.resume()
    }
}
//Structure extension
extension FavoritosTableViewController{
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Favoritos"
        //navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.placeholder = "Pesquisar local"
        
    }
    //Search bar extension
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTerms = searchText
        filterTable(searchText: searchText)
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        if searchTerms.isEmpty {
            filterTable(searchText: "")
        }
        searchBar.text = searchTerms
    }
    //
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if locaisArray.isEmpty {
            return 1
        }
        return locaisArrayFiltrados.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if locaisArray.isEmpty {
            let emptyListCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "NoDataCell")
            emptyListCell.textLabel?.text = "Nenhum favorito adicionado"
            return emptyListCell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritosTableViewCell", for: indexPath) as? FavoritosTableViewCell else{
            fatalError("The dequeued cell is not an instance of UsersTableViewCell.")
        }
        cell.setLocal(local: locaisArrayFiltrados[indexPath.row])
        cell.delegate = self
        return cell
    }
}
//Struct for the JSON return
struct LocaisFormat: Decodable {
    let id: String?
    let coordenadas: String?
    let raio: String?
    let nome: String?
    let descricao: String?
    let utilizador_id: String?
    let url_foto_local: String?
    let media_local: String?
}
