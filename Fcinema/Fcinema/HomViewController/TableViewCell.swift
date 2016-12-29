//
//  TableViewCell.swift
//  MockProject1
//
//  Created by Kien Nguyen Dang on 11/10/16.
//  Copyright © 2016 Kien Nguyen Dang. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgPhim: UIImageView!
    @IBOutlet weak var lblTenPhim: UILabel!
    @IBOutlet weak var lblTheloai: UILabel!
    @IBOutlet weak var lblDienVienDaoDien: UILabel!
    @IBOutlet weak var lblDaodien: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
