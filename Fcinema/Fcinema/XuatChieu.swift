//
//  XuatChieu.swift
//  Fcinema
//
//  Created by Tuan anh Dang on 11/15/16.
//  Copyright © 2016 Tuan anh Dang. All rights reserved.
//

import UIKit

class XuatChieu: NSObject {
    var id_XuatChieu:Int?
    var gioChieu:String?
    var id_LichChieu:Int?
    override init() {
        self.id_XuatChieu = nil
        self.id_LichChieu = nil
        self.gioChieu = ""
    }
}
