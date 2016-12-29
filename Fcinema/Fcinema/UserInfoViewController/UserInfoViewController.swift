//
//  UserInfoViewController.swift
//  MockProject1
//
//  Created by Kien Nguyen Dang on 11/15/16.
//  Copyright © 2016 Kien Nguyen Dang. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    
    
    @IBOutlet weak var lblSodt: UILabel!
    @IBOutlet weak var tableLichsugiaodich: UITableView!
    @IBOutlet weak var lblHoten: UILabel!
    
    var arrLichSuGiaoDich:[LichSuGiaoDich] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //tạo background
        UIGraphicsBeginImageContext(UIScreen.main.bounds.size)
        UIImage(named: "bg_login.jpg")?.draw(in: UIScreen.main.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        tableLichsugiaodich.delegate = self
        tableLichsugiaodich.dataSource = self
        tableLichsugiaodich.rowHeight = UITableViewAutomaticDimension
        tableLichsugiaodich.estimatedRowHeight = 100
        tableLichsugiaodich.register(UINib(nibName: "UserInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
       
        //loat họ tên số điện thoại
        loadUserInfor()
        //load lịch sử giao dịch
        loadLichSuGiaoDich()

    }
    
    //load thong tin nguoi dung
    func loadUserInfor(){
        let sdt = DataManager.defaultDataManager().getPhone()
        if sdt != ""{
            let user = DataManager.defaultDataManager().getRowTaiKhoan("select * from NguoiDung where soDienThoai = '\(sdt)'")
            lblHoten.text = user[0].hoTen
            lblSodt.text = user[0].soDienThoai
            
        }
    }
    
    //load lich su giao dich
    func loadLichSuGiaoDich(){
        var idNguoiDung: Int!
        let sdt = DataManager.defaultDataManager().getPhone()
        if sdt != ""{
            let user = DataManager.defaultDataManager().getRowTaiKhoan("select * from NguoiDung where soDienThoai = '\(sdt)'")
            idNguoiDung = user[0].idTK!
        }
        
        arrLichSuGiaoDich = DataManager.defaultDataManager().getRowLichSuGiaoDich("select * from LichSuGiaoDich where id_NguoiDung = \(idNguoiDung!)")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //thoát màn hình thông tin người dùng
    @IBAction func clickDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UserInfoViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLichSuGiaoDich.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lb = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.width, height: view.frame.height))
        lb.textColor = UIColor.black
        lb.text =  "LỊCH SỬ GIAO DỊCH"
        lb.backgroundColor = UIColor.orange
        lb.textAlignment = NSTextAlignment.center
        lb.textColor = UIColor.white
        return lb
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        }
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableLichsugiaodich.dequeueReusableCell(withIdentifier: "Cell") as! UserInfoTableViewCell
        //create array xuat chieu
        var arrXuatChieu:[XuatChieu] = []
        //create array lich chieu
        var arrLichChieu: [LichChieu] = []
        //create array rap
        var arrRap: [Rap] = []
        //create array Phim
        var arrPhim: [Phim] = []
        //create array Ghe
        var arrGhe: [Ghe] = []
        
        //lay xuat chieu dua vao id xuat chieu
        let id_xc = arrLichSuGiaoDich[indexPath.row].id_XuatChieu
        arrXuatChieu = DataManager.defaultDataManager().getRowsXuatChieu("select * from XuatChieu where id_XuatChieu = \(id_xc!)")
        
        //lay lich chieu thong qua id lich chieu
        let id_lc = arrXuatChieu[0].id_LichChieu
        arrLichChieu = DataManager.defaultDataManager().getRowsLichChieu("select * from LichChieu where id_LichChieu = \(id_lc!)")
        
        //lay ngay chieu
        let date = DateFormatter()
        date.dateFormat = "dd/MM/yyyy"
        let ngaychieu = date.string(from: arrLichChieu[0].ngayChieu!)
        
        //lay id rap thong qua lich chieu
        let idRap = arrLichChieu[0].id_Rap
        //lay id phim thong qua lich chieu
        let idPhim = arrLichChieu[0].id_Phim
        
        //lay danh sach rap thong qua id rap
        arrRap = DataManager.defaultDataManager().getRowsRap("select * from Rap where id_Rap = \(idRap!)")
        //lay danh sach phim thong qua id phim
        arrPhim = DataManager.defaultDataManager().getRowsFilm("select * from Phim where id_Phim = \(idPhim!)")
        
        //lay danh sach ghe thong qua id xuat chieu
        arrGhe = DataManager.defaultDataManager().getRowGhe("select * from Ghe where id_XuatChieu = \(id_xc!) and id_LichSuGiaoDich = \(arrLichSuGiaoDich[indexPath.row].id_LichSuGiaoDich!)")
        var listGhe: String = ""
        for index in arrGhe{
            listGhe = listGhe + index.tenGhe! + "  "
        }
        //hiển thị thông tin lên cell
        cell.lblNgayvaGioChieu.text = "Giờ chiếu: " + arrXuatChieu[0].gioChieu! + "-- Ngày chiếu: " + ngaychieu
        cell.lblTenPhimTenRap.text = "Tên phim: " + arrPhim[0].tenPhim!
        cell.lblTenRap.text = "Tên rạp: " + arrRap[0].tenRap!
        cell.lblSove.text = "Ghế: " + listGhe
        cell.lblTongTien.text! = "Tổng tiền: " + (String)(format: "%.0f" ,arrLichSuGiaoDich[indexPath.row].tongTien!) + " đ"
        return cell
    }
}
