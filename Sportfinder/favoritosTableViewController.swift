//
//  favoritosTableViewController.swift
//  Sportfinder
//
//  Created by João Costa on 05/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

class FavoritosTableViewController: UITableViewController {
    let userID:String = "4"
    //
    //var userArray = [EntityUser]()
    //
    @IBOutlet weak var tableViewReference: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        //userID = MySingleton.shared.getUserID()
        tableViewReference.rowHeight = UITableView.automaticDimension
        tableViewReference.estimatedRowHeight = 150
        loadDataFromDB()
    }
    /*
     // MARK: - Table view data source
     override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
     }
     
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     guard let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as? UsersTableViewCell else{
     fatalError("The dequeued cell is not an instance of UsersTableViewCell.")
     }
     cell.setUser(user: userArray[indexPath.row])
     cell.delegate = self
     // Configure the cell...
     if userArray.isEmpty {
     let emptyListCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "NoDataCell")
     emptyListCell.textLabel?.text = NSLocalizedString("userTable.noUsers", comment: "")
     return emptyListCell
     }
     return cell
     }
     */
    
}

extension FavoritosTableViewController{
    func loadDataFromDB(){
        print("Loading favorites from database...")
    }
}
//Struct for the JSON return
struct Users: Decodable {
    let nome: String?
    let username: String?
    let id: String?
    let foto: String?
    let favorito: Bool?
}

