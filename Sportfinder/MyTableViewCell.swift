//
//  MyTableViewCell.swift
//  Sportfinder
//
//  Created by pedro on 04/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgFirstPlaceIcon.image = UIImage(named: "firstPlace")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblpontuacao: UILabel!
    @IBOutlet weak var lblPosicao: UILabel!
    @IBOutlet weak var imgFirstPlaceIcon: UIImageView!
}
