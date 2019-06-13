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
    func didClickGoToDetalhes(id_local:String)
}

class FavoritosTableViewCell: UITableViewCell {
    //
    @IBOutlet weak var localNomeLbl: UILabel!
    @IBOutlet weak var imagemLocal: RoundImage!
    @IBOutlet weak var classificacaoMediaLbl: UILabel!
    //
    @IBOutlet weak var roundView: RoundView!
    var local:EntityLocal!
    var delegate: FavoritosTableViewCellDelegate?
    //
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        roundView.addGestureRecognizer(tap)
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
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil){
        print("costa estou aqui \(self.local.id_local)")
        delegate?.didClickGoToDetalhes(id_local: self.local.id_local)
    }
    
    @IBAction func favoritoBtnClicked(_ sender: Any) {
        delegate?.didClickRemoveFavorito(id_local: self.local.id_local, nome_local:self.local.nome)
    }
    
    
}
