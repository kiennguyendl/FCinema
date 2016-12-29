//
//  Phim.swift
//  Fcinema
//
//  Created by Tuan anh Dang on 11/14/16.
//  Copyright © 2016 Tuan anh Dang. All rights reserved.
//

import UIKit

class Phim: NSObject {
    var daoDien: String?
    var hinhPhim: String?
    var id_Phim: Int?
    var ngayKhoiChieu: Date?
    var ngayKetThuc: Date?
    var noiDung: String?
    var tenPhim: String?
    var theLoai: String?
    var dienVien:String?
    var thoiLuong: Int?
    var url: String?
    override init(){
        self.daoDien = ""
        self.id_Phim = nil
        self.ngayKhoiChieu = nil
        self.ngayKetThuc = nil
        self.dienVien = ""
        self.hinhPhim = ""
        self.noiDung = ""
        self.tenPhim = ""
        self.theLoai = ""
        self.thoiLuong = nil
        self.url = ""
        
    }
    
}
