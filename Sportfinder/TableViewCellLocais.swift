//
//  TableViewCellLocais.swift
//  Sportfinder
//
//  Created by Pedro Couto on 11/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit





class TableViewCellLocais: UITableViewCell{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var IVFotoLocal: UIImageView!
    
    @IBOutlet weak var lblNomeLocal: UILabel!
    @IBOutlet weak var lblAvaliacao: UILabel!
    @IBOutlet weak var lblDistancia: UILabel!
    
}
