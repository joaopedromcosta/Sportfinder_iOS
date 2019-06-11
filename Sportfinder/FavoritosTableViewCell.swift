//
//  FavoritosTableViewCell.swift
//  Sportfinder
//
//  Created by João Costa on 05/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

protocol FavoritosTableViewCellDelegate {
    func didClickRemoveFavorito(id_local:String, nome_local:String)
}

class FavoritosTableViewCell: UITableViewCell {
    //
    @IBOutlet weak var localNomeLbl: UILabel!
    @IBOutlet weak var imagemLocal: RoundImage!
    @IBOutlet weak var classificacaoMediaLbl: UILabel!
    //
    var local:EntityLocal!
    var delegate: FavoritosTableViewCellDelegate?
    //
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //
    func setLocal(local:EntityLocal){
        self.local = local
        localNomeLbl.text = local.nome
        //
        if(local.foto != nil){
            self.imagemLocal.image = local.foto
        }else{
            self.imagemLocal.image = UIImage(contentsOfFile: "nopicture")
        }
        self.classificacaoMediaLbl.text = local.mediaLocal
    }
    
    @IBAction func favoritoBtnClicked(_ sender: Any) {
        delegate?.didClickRemoveFavorito(id_local: self.local.id_local, nome_local:self.local.nome)
    }
    
}
