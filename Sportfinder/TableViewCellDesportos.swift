//
//  TableViewCellDesportos.swift
//  Sportfinder
//
//  Created by Pedro Couto on 05/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

class TableViewCellDesportos: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Properties
    
    @IBOutlet weak var tvNomeDesporto: UILabel!
    @IBOutlet weak var IVIconDesporto: UIImageView!
    
}
