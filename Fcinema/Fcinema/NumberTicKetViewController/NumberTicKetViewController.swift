//
//  NumberTicKetViewController.swift
//  MockProject1
//
//  Created by Tuan anh Dang on 11/13/16.
//  Copyright © 2016 Kien Nguyen Dang. All rights reserved.
//

import UIKit

class NumberTicKetViewController: UIViewController {




    @IBOutlet weak var lblTongTien: UILabel!
    @IBOutlet weak var lblNumberTicKet: UILabel!
    @IBOutlet weak var txtGioNgayChieu: UILabel!
    @IBOutlet weak var txtRap: UILabel!
    @IBOutlet weak var imgFilm: UIImageView!
    @IBOutlet weak var btnCong: UIButton!
    @IBOutlet weak var btnTru: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    var numberTicKet:Int = 0
    
    
    var id_XuatChieu:Int? = nil
    var theater = [Rap]()
    var film = [Phim]()
    var priceTicket = [GiaVe]()
    var dateStart = [LichChieu]()
    var timeStart = [XuatChieu]()
    var seat = [Ghe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prePareData()
        // Do any additional setup after loading the view.
    }
    
    func prePareData(){
        // kiem tra xuat chiếu id co rổng ko
        if id_XuatChieu != nil {
            //lấy xuất chiếu
            timeStart = DataManager.defaultDataManager().getRowsXuatChieu("select * from XuatChieu where XuatChieu.id_XuatChieu = " + String(format:"%d", id_XuatChieu!))
            
            if timeStart.count > 0 {
                //lấy lịch chiếu
                dateStart = DataManager.defaultDataManager().getRowsLichChieu("Select * from LichChieu,XuatChieu where XuatChieu.id_XuatChieu = " + String(format: "%d", id_XuatChieu!) + " and LichChieu.id_LichChieu = XuatChieu.id_LichChieu")
            }

            
            
            if dateStart.count > 0 {
                //lấy  rap
                theater = DataManager.defaultDataManager().getRowsRap("Select * from Rap,LichChieu,XuatChieu where LichChieu.id_LichChieu = " + String(format: "%d" , dateStart[0].id_LichChieu!) + " and Rap.id_Rap = LichChieu.id_Rap")
            }
            
            if theater.count > 0 {
                //lấy thong tin phim
                film = DataManager.defaultDataManager().getRowsFilm("select * from Phim,LichChieu where LichChieu.id_LichChieu = " + String(format: "%d",dateStart[0].id_LichChieu!) + " and LichChieu.id_Rap = " + String(format: "%d",theater[0].id_Rap!) + " and LichChieu.id_Phim = Phim.id_Phim")
            }
            
            if film.count > 0 {
                //lấy giá vé của phim
                priceTicket = DataManager.defaultDataManager().getRowGiaVe("select * from GiaVe where GiaVe.id_Phim = " + String(format: "%d" , film[0].id_Phim!))
            }
            //lấy danh sach ghế đã đặt của xuất chiếu
            seat = DataManager.defaultDataManager().getRowGhe("select * from Ghe where id_XuatChieu = " + String(format: "%d",id_XuatChieu!))
            if priceTicket.count > 0 {
                //hiển thị thông tin
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                txtGioNgayChieu.text = timeStart[0].gioChieu! + " - " + dateFormatter.string(from: dateStart[0].ngayChieu!)
                txtRap.text = theater[0].tenRap
                imgFilm.image = UIImage(named: film[0].hinhPhim!)
                lblNumberTicKet.text = "1"
                if seat.count >= theater[0].soLuongGhe! {
                    lblTongTien.text = "Xuất Chiếu Đã Hết Ghế Xin Vui Lòng Quay Lại Sau"
                    btnTru.isEnabled = false
                    btnCong.isEnabled = false
                    btnContinue.isEnabled = false
                    btnContinue.isHidden = true
                    
                }else{
                    lblTongTien.text = String(format: "%.0f", Double(lblNumberTicKet.text!)! * priceTicket[0].giaTien!) + " đ"
                    //tính số lượng ghế còn
                    numberTicKet = theater[0].soLuongGhe! - seat.count
                    btnTru.isEnabled = true
                    btnCong.isEnabled = true
                    btnContinue.isEnabled = true
                    btnContinue.isHidden = false
                    
                }

            }

            
        }else{
            _ = navigationController?.popToRootViewController(animated: true)
        }

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func clickCong(_ sender: Any) {
        //kiểm tra số vé đã đặt nhỏ hơn 10 và nhỏ hơn số lượng ghế còn
        if Int(lblNumberTicKet.text!)! != numberTicKet && Int(lblNumberTicKet.text!)! < 10 && Int(lblNumberTicKet.text!)! < numberTicKet{
            lblNumberTicKet.text = String(format: "%.0f" , Double(lblNumberTicKet.text!)! + 1)
            lblTongTien.text = String(format: "%.0f", Double(lblNumberTicKet.text!)! * priceTicket[0].giaTien!) + " đ"
        }
    }
    
    @IBAction func clickTru(_ sender: Any) {
        //kiem tra số lượng vé trong lable > 1 mới cho trừ
        if Int(lblNumberTicKet.text!)! > 1 {
            lblNumberTicKet.text = String(format: "%.0f" , Double(lblNumberTicKet.text!)! - 1)
            lblTongTien.text = String(format: "%.0f", Double(lblNumberTicKet.text!)! * priceTicket[0].giaTien!) + " đ"
        }
    }
    @IBAction func clickNext(_ sender: Any) {
        let vc = SelectSeatViewController()
        //chuyển data gồm số lượng vé , số lượng ghế của rạp , xuất chiếu id ,id phim , rạp id , tổng tiền
        let dataTicket:[String] = [lblNumberTicKet.text!,String(format: "%d", theater[0].soLuongGhe!),String(format: "%d",timeStart[0].id_XuatChieu!),String(format: "%d",film[0].id_Phim!),String(format:"%d",theater[0].id_Rap!),String(format: "%.0f", Double(lblNumberTicKet.text!)! * priceTicket[0].giaTien!)]
        vc.data = dataTicket
        navigationController?.pushViewController(vc, animated: true)
    }

}
