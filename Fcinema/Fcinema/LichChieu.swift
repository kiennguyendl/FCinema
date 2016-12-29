//
//  LichChieu.swift
//  Fcinema
//
//  Created by Tuan anh Dang on 11/15/16.
//  Copyright © 2016 Tuan anh Dang. All rights reserved.
//

import UIKit

class LichChieu: NSObject {
    var id_LichChieu:Int?
    var ngayChieu:Date?
    var id_Phim:Int?
    var id_Rap:Int?
    override init() {
        self.id_LichChieu = nil
        self.ngayChieu = nil
        self.id_Phim = nil
        self.id_Rap = nil
    }
}
