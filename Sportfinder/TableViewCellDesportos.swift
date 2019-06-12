//
//  TableViewCellDesportos.swift
//  Sportfinder
//
//  Created by Pedro Couto on 05/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

class TableViewCellDesportos: UITableViewCell {
    
    
    //MARK: Properties
    @IBOutlet weak var tvNomeDesporto: UILabel!
    @IBOutlet weak var IVIconDesporto: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            let newWidth = frame.width * 0.80 // get 80% width here
            let space = (frame.width - newWidth) / 2
            frame.size.width = newWidth
            frame.origin.x += space
            
            super.frame = frame
            
        }
    }
    */
    
    
    
}
