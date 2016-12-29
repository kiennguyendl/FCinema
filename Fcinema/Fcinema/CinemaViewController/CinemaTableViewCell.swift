//
//  CinemaTableViewCell.swift
//  MockProject1
//
//  Created by PhatVQ on 12/11/2016.
//  Copyright © 2016 Kien Nguyen Dang. All rights reserved.
//

import UIKit

class CinemaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Photo: UIImageView!

    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbAddress: UILabel!
    
    @IBOutlet weak var lbPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
