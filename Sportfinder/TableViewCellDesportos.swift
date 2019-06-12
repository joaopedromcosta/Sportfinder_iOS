//
//  TableViewCellDesportos.swift
//  Sportfinder
//
//  Created by Pedro Couto on 05/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

protocol CellDesportoDelegate {
    func didClickInDesportoCell(nomeDesporto:String, selecionou:Bool)
}
class TableViewCellDesportos: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var tvNomeDesporto: UILabel!
    @IBOutlet weak var IVIconDesporto: UIImageView!
    @IBOutlet weak var vw: RoundView!
    var nomeDesporto = ""
    var selecionado = false
    var delegate: CellDesportoDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        vw.addGestureRecognizer(tap)
    }
    func setDesportoNome(nome:String) {
        nomeDesporto = nome
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func handleTap(sender: UITapGestureRecognizer? = nil){
        print("costa estou aqui \(self.nomeDesporto)")
        if selecionado{
            selecionado = false
            vw.backgroundColor = UIColor.white
        }else{
            selecionado = true
            vw.backgroundColor = UIColor(red:185/255.0, green:253/255.0, blue:216/255.0, alpha: 0.5)        }
        self.delegate?.didClickInDesportoCell(nomeDesporto: self.nomeDesporto, selecionou: self.selecionado)
        print("adeus")
    }
 }
    
