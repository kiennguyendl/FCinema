//
//  DataManager.swift
//  Fcinema
//
//  Created by Tuan anh Dang on 11/14/16.
//  Copyright © 2016 Tuan anh Dang. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    static var sharedInstance:DataManager!
    
    
    static func defaultDataManager() -> DataManager{
        if sharedInstance == nil {//Neu doi tuong chua ton tai
            //Khoi tao doi tuong
            sharedInstance = DataManager()
            sharedInstance.copyDataToDoc()
        }
        return sharedInstance
    }
    
    //copy databbase vào máy
    func copyDataToDoc() {
        let mainBundle = Bundle.main
        let filePathBun = mainBundle.path(forResource: "FCinema", ofType: "sqlite")
        let fileManager = FileManager.default
        let filePathDoc = NSHomeDirectory().appending("/Documents/FCinema.sqlite")
        
        if !fileManager.fileExists(atPath: filePathDoc) {
            do {
                try fileManager.copyItem(atPath: filePathBun!, toPath: filePathDoc)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        
    }
    
    //cập nhập database
    func updateDatabase(_ dbCommand: String)
    {
        var updateStatement: OpaquePointer? = nil
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Fcinema.sqlite")
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            if sqlite3_prepare_v2(db, dbCommand, -1, &updateStatement, nil) == SQLITE_OK {
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    //do nothing
                    print("updated database")
                } else {
                    print("Could not updateDatabase")
                }
                } else {
                    print("updateDatabase dbCommand could not be prepared")
                }
        
                sqlite3_finalize(updateStatement)
            
        }
        
        sqlite3_close(db)
        
    }
    
    //MARK:  Update Database
    
    func getID(_ tableName: String!, _ nameId: String!) -> Int
    {
        var getStatement: OpaquePointer? = nil
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Fcinema.sqlite")
        var db: OpaquePointer? = nil
        
        let dbCommand = String(format: "select %@ from %@ order by %@ desc limit 1",nameId, tableName,nameId)
        
        var value: Int32? = 0
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
        
        if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
            if sqlite3_step(getStatement) == SQLITE_ROW {
                
                value = sqlite3_column_int(getStatement, 0)
            }
            
        } else {
            print("dbValue statement could not be prepared")
        }
        
        sqlite3_finalize(getStatement)
        }
        sqlite3_close(db)
        
        
        return Int(value!)
    }

    
    func getRows(_ dbCommand: String) -> [Phim]
    {
        var outputArray: [Phim] = [Phim]()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Fcinema.sqlite")
        var getStatement: OpaquePointer? = nil
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            //do nothing
            if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
                while sqlite3_step(getStatement) == SQLITE_ROW {
                    let film = Phim()
                    let daoDien = String(cString: sqlite3_column_text(getStatement, Int32(2)))
                    let id_Phim = sqlite3_column_int(getStatement, Int32(0))
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let ngayKhoiChieu: Date = dateFormatter.date(from: String(cString: sqlite3_column_text(getStatement, Int32(5))))!
                    let noiDung = String(cString: sqlite3_column_text(getStatement, Int32(6)))
                    let tenPhim = String(cString: sqlite3_column_text(getStatement, Int32(1)))
                    let theLoai = String(cString: sqlite3_column_text(getStatement, Int32(4)))
                    let thoiLuong = sqlite3_column_int(getStatement, Int32(3))
                    let url = String(cString: sqlite3_column_text(getStatement, Int32(8)))
                    
                    film.daoDien = daoDien
                    film.id_Phim = Int(id_Phim)
                    film.ngayKhoiChieu = ngayKhoiChieu
                    film.noiDung = noiDung
                    film.tenPhim = tenPhim
                    film.theLoai = theLoai
                    film.thoiLuong = Int(thoiLuong)
                    film.url = url
                    
                    outputArray.append(film)
                    
                }
                
            } else {
                print("getRows statement could not be prepared")
            }
            
            sqlite3_finalize(getStatement)
        }
        
        
        sqlite3_close(db)
        
        return outputArray
    }
    
    //lấy danh sách phim từ bảng phim
    func getRowsFilm(_ dbCommand: String) -> [Phim]
    {
        var outputArray: [Phim] = [Phim]()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Fcinema.sqlite")
        var getStatement: OpaquePointer? = nil
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            //do nothing
            if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
                while sqlite3_step(getStatement) == SQLITE_ROW {
                    let film = Phim()
                    
                    let id_Phim = sqlite3_column_int(getStatement, Int32(0))
                    let tenPhim = String(cString: sqlite3_column_text(getStatement, Int32(1)))
                    let theLoai = String(cString: sqlite3_column_text(getStatement, Int32(2)))
                    let dienVien = String(cString: sqlite3_column_text(getStatement, Int32(3)))
                    let daoDien = String(cString: sqlite3_column_text(getStatement, Int32(4)))
                    let thoiLuong = sqlite3_column_int(getStatement, Int32(5))
                    let noiDung = String(cString: sqlite3_column_text(getStatement, Int32(6)))
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let ngayKhoiChieu: Date = dateFormatter.date(from: String(cString: sqlite3_column_text(getStatement, Int32(7))))!
                    let hinhPhim = String(cString: sqlite3_column_text(getStatement, Int32(8)))
                    let url = String(cString: sqlite3_column_text(getStatement, Int32(9)))
                    let ngayKetThuc: Date = dateFormatter.date(from: String(cString: sqlite3_column_text(getStatement, Int32(10))))!

                    film.daoDien = daoDien
                    film.id_Phim = Int(id_Phim)
                    film.ngayKhoiChieu = ngayKhoiChieu
                    film.noiDung = noiDung
                    film.tenPhim = tenPhim
                    film.theLoai = theLoai
                    film.thoiLuong = Int(thoiLuong)
                    film.url = url
                    film.dienVien = dienVien
                    film.hinhPhim = hinhPhim
                    film.ngayKetThuc = ngayKetThuc
                    
                    outputArray.append(film)
                    
                }
                
            } else {
                print("getRows statement could not be prepared")
            }
            
            sqlite3_finalize(getStatement)
        }
        
        sqlite3_close(db)
        
        return outputArray
    }
    
    //lấy danh sách rạp từ bảng rạp
    func getRowsRap(_ dbCommand: String) -> [Rap]
    {
        var outputArray: [Rap] = [Rap]()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Fcinema.sqlite")
        var getStatement: OpaquePointer? = nil
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            //do nothing
            if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
                while sqlite3_step(getStatement) == SQLITE_ROW {
                    let rap = Rap()
                    let id_Rap = sqlite3_column_int(getStatement, Int32(0))
                    let tenRap = String(cString: sqlite3_column_text(getStatement, Int32(1)))
                    let soDienThoai = String(cString: sqlite3_column_text(getStatement, Int32(2)))
                    let soLuongGhe = sqlite3_column_int(getStatement, Int32(3))
                    let diaChi = String(cString: sqlite3_column_text(getStatement, Int32(4)))
                    let hinhRap = String(cString: sqlite3_column_text(getStatement, Int32(5)))
                    
                    rap.id_Rap = Int(id_Rap)
                    rap.tenRap = tenRap
                    rap.soDienThoai = soDienThoai
                    rap.soLuongGhe = Int(soLuongGhe)
                    rap.diaChi = diaChi
                    rap.hinhRap = hinhRap
                    
                    outputArray.append(rap)
                    
                }
                
            } else {
                print("getRows statement could not be prepared")
            }
            
            sqlite3_finalize(getStatement)
        }
        
        
        
        sqlite3_close(db)
        
        return outputArray
    }
    //lấy danh sách xuất chiều từ bảng xuất chiếu
    func getRowsXuatChieu(_ dbCommand: String) -> [XuatChieu]
    {
        var outputArray: [XuatChieu] = [XuatChieu]()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Fcinema.sqlite")
        var getStatement: OpaquePointer? = nil
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            //do nothing
            if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
                while sqlite3_step(getStatement) == SQLITE_ROW {
                    let xuatchieu = XuatChieu()
                    let id_XuatChieu = sqlite3_column_int(getStatement, Int32(0))
                    let gioChieu = String(cString: sqlite3_column_text(getStatement, Int32(1)))
                    let id_LichChieu = sqlite3_column_int(getStatement, Int32(2))
                    
                    xuatchieu.id_XuatChieu = Int(id_XuatChieu)
                    xuatchieu.gioChieu = gioChieu
                    xuatchieu.id_LichChieu = Int(id_LichChieu)
                    
                    outputArray.append(xuatchieu)
                }
                
            } else {
                print("getRows statement could not be prepared")
            }
            
            sqlite3_finalize(getStatement)
        }
        
        
        
        sqlite3_close(db)
        
        return outputArray
    }
    //lấy danh sach lịch chiếu từ bảng lịch chiếu
    func getRowsLichChieu(_ dbCommand: String) -> [LichChieu]
    {
        var outputArray: [LichChieu] = [LichChieu]()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Fcinema.sqlite")
        var getStatement: OpaquePointer? = nil
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            //do nothing
            if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
                while sqlite3_step(getStatement) == SQLITE_ROW {
                    let lichchieu = LichChieu()
                    let id_LichChieu = sqlite3_column_int(getStatement, Int32(0))
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                     let ngayChieu: Date = dateFormatter.date(from: String(cString: sqlite3_column_text(getStatement, Int32(1))))!
                    let id_Phim = sqlite3_column_int(getStatement, Int32(2))
                    let id_Rap = sqlite3_column_int(getStatement, Int32(3))
                    
                    lichchieu.id_LichChieu = Int(id_LichChieu)
                    lichchieu.ngayChieu = ngayChieu
                    lichchieu.id_Phim = Int(id_Phim)
                    lichchieu.id_Rap = Int(id_Rap)

                    outputArray.append(lichchieu)
                }
                
            } else {
                print("getRows statement could not be prepared")
            }
            
            sqlite3_finalize(getStatement)
        }
        
        
        
        sqlite3_close(db)
        
        return outputArray
    }

    //lấy thông tin tài khoản từ bảng tài khoản
    func getRowTaiKhoan(_ dbCommand: String) -> [TaiKhoan] {
        var outputArray: [TaiKhoan] = [TaiKhoan]()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Fcinema.sqlite")
        var getStatement: OpaquePointer? = nil
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            
            if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
                while sqlite3_step(getStatement) == SQLITE_ROW {
                    let taikhoan = TaiKhoan()
                    let idTK = sqlite3_column_int(getStatement, Int32(0))
                    let hoTen = String(cString: sqlite3_column_text(getStatement, Int32(1)))
                    let soDienThoai = String(cString: sqlite3_column_text(getStatement, Int32(2)))
                    let matKhau = String(cString: sqlite3_column_text(getStatement, Int32(3)))
                    
                    taikhoan.idTK = (Int)(idTK)
                    taikhoan.hoTen = hoTen
                    taikhoan.soDienThoai = soDienThoai
                    taikhoan.matKhau = matKhau
                    
                    outputArray.append(taikhoan)
                }
            }else{
                print("getRows statement could not be prepared")
            }
            
            sqlite3_finalize(getStatement)
        }
        sqlite3_close(db)
        
        return outputArray
    }

    //lấy thông tin giá vé từ giá vé
    func getRowGiaVe(_ dbCommand: String) -> [GiaVe] {
        var outputArray: [GiaVe] = [GiaVe]()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Fcinema.sqlite")
        var getStatement: OpaquePointer? = nil
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            
            if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
                while sqlite3_step(getStatement) == SQLITE_ROW {
                    let giaVe = GiaVe()
                    let id_GiaVe = sqlite3_column_int(getStatement, Int32(0))
                    let id_Phim = sqlite3_column_int(getStatement, Int32(1))
                    let giaTien = sqlite3_column_double(getStatement, Int32(2))
                    
                    giaVe.id_GiaVe = Int(id_GiaVe)
                    giaVe.id_Phim = Int(id_Phim)
                    giaVe.giaTien = Double(giaTien)
                    
                    
                    outputArray.append(giaVe)
                }
            }else{
                print("getRows statement could not be prepared")
            }
            
            sqlite3_finalize(getStatement)
        }
        sqlite3_close(db)
        
        return outputArray
    }
    
    //lấy danh sách ghế từ bảng ghế
    func getRowGhe(_ dbCommand: String) -> [Ghe] {
        var outputArray: [Ghe] = [Ghe]()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Fcinema.sqlite")
        var getStatement: OpaquePointer? = nil
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            
            if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
                while sqlite3_step(getStatement) == SQLITE_ROW {
                    let ghe = Ghe()
                    let id_Ghe = sqlite3_column_int(getStatement, Int32(0))
                    let id_XuatChieu = sqlite3_column_int(getStatement, Int32(3))
                    let id_LichSuGiaoDich = sqlite3_column_int(getStatement, Int32(1))
                    let tenGhe = String(cString:sqlite3_column_text(getStatement, Int32(2)))
                    
                    ghe.id_Ghe = Int(id_Ghe)
                    ghe.id_LichSuGiaoDich = Int(id_LichSuGiaoDich)
                    ghe.tenGhe = tenGhe
                    ghe.id_XuatChieu = Int(id_XuatChieu)
                    outputArray.append(ghe)
                }
            }else{
                print("getRows statement could not be prepared")
            }
            
            sqlite3_finalize(getStatement)
        }
        sqlite3_close(db)
        
        return outputArray
    }
    
    func getPhone() ->String{
        if let phone = UserDefaults.standard.string(forKey: "SoDienThoai") {
            return phone
        }else{
            return ""
        }
        
    }
    //lấy danh sách lịch sử giao dịch
    func getRowLichSuGiaoDich(_ dbCommand: String) -> [LichSuGiaoDich] {
        var outputArray: [LichSuGiaoDich] = [LichSuGiaoDich]()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Fcinema.sqlite")
        var getStatement: OpaquePointer? = nil
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            
            if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
                while sqlite3_step(getStatement) == SQLITE_ROW {
                    let lsGiaoDich = LichSuGiaoDich()
                    let id_LichSuGiaoDich = sqlite3_column_int(getStatement, Int32(0))
                    let id_NguoiDung = sqlite3_column_int(getStatement, Int32(1))
                    let id_XuatChieu = sqlite3_column_int(getStatement, Int32(2))
                    let tongTien = sqlite3_column_double(getStatement, Int32(3))
                    
                    lsGiaoDich.id_LichSuGiaoDich = Int(id_LichSuGiaoDich)
                    lsGiaoDich.id_NguoiDung = Int(id_NguoiDung)
                    lsGiaoDich.id_XuatChieu = Int(id_XuatChieu)
                    lsGiaoDich.tongTien = Double(tongTien)
                    outputArray.append(lsGiaoDich)
                }
            }else{
                print("getRows statement could not be prepared")
            }
            
            sqlite3_finalize(getStatement)
        }
        sqlite3_close(db)
        
        return outputArray
    }
    
    
    
}
