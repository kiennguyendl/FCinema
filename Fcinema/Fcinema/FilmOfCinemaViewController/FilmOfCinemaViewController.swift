//
//  FilmOfCinemaViewController.swift
//  Fcinema
//
//  Created by PhatVQ on 15/11/2016.
//  Copyright © 2016 Tuan anh Dang. All rights reserved.
//

import UIKit

class FilmOfCinemaViewController: UIViewController {

    @IBOutlet weak var imgRap: UIImageView!
    @IBOutlet weak var lbtenRap: UILabel!
    @IBOutlet weak var lbdiaChi: UILabel!
    @IBOutlet weak var lbSoDT: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    
    var rap:Rap? = nil // đối tượng trung gian nhận dữ liệu từ danh sách rạp truyền qua.
    var arrPhim = [Phim]() // Chứa thông tin các phim khi load từ database lên
    var arrLichChieu = [LichChieu]() // chứa thông tin các lịch chiếu
    var arrXuatChieu = [XuatChieu]() // chứa thông tin các xuất chiếu
    var dateNow:String? = nil
   
    
    override func viewDidLoad() {

        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UINib(nibName: "FilmOfCineTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateNow = dateFormatter.string(from: Date())
        super.viewDidLoad()
        
        getData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Lấy dữ liệu rạp từ màn hình "danh sách rạp" truyền qua để hiển thị lên view
    func getData() {
        
        if rap != nil {
            imgRap.image = UIImage(named: (rap?.hinhRap)!)
            lbtenRap.text = rap?.tenRap
            lbdiaChi.text = "🏩" + (rap?.diaChi)!
            lbSoDT.text = "☎️" + (rap?.soDienThoai)!
            
            // Lấy danh sách phim tương ứng với rạp
            arrPhim = DataManager.defaultDataManager().getRowsFilm("select * from Phim, LichChieu WHERE Phim.id_Phim = LichChieu.id_Phim AND LichChieu.id_Rap = " + String(format: "%d", (rap?.id_Rap)!) + " GROUP BY Phim.id_Phim")
            
        }
    }
}
extension FilmOfCinemaViewController:UITableViewDelegate,UITableViewDataSource {
    // Số section: Mỗi phim là 1 section.
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrPhim.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        var cell = self.tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FilmOfCineTableViewCell
        if  cell == nil {
            cell = FilmOfCineTableViewCell()
        }
        // Xoá timestart  trước khi load lại.
        for item in (cell?.contentView.subviews)! {
            if item.isMember(of: UIButton.self)
            {
                item.removeFromSuperview()
            }
        }
        
        var toaDo_X:CGFloat = 10
        var toaDo_Y:CGFloat = 40
        // Lấy thông tin lịch chiếu tương ứng với từng phim trong mảng arrPhim.
        if arrPhim.count > 0 {
            arrLichChieu = DataManager.defaultDataManager().getRowsLichChieu("select * from LichChieu where LichChieu.id_Rap = " + String(format:"%d" , (rap?.id_Rap)!) + " and LichChieu.id_Phim = " + String(format:"%d" , arrPhim[indexPath.section].id_Phim!))
            // Lấy thông tin xuất chiếu tương ứng với từng lịch chiếu trong mảng arrLichChieu
            if arrLichChieu.count > 0 {
                arrLichChieu = arrLichChieu.filter(){ $0.ngayChieu! > Date() ? true : false}
                if arrLichChieu.count > 0 {
                    arrXuatChieu = DataManager.defaultDataManager().getRowsXuatChieu("select * from XuatChieu where XuatChieu.id_LichChieu = " + String(format:"%d" ,arrLichChieu[indexPath.row].id_LichChieu!))
                    //Hàm chuyển đỗi định dạng ngày tháng
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    // Hiển thị ngày chiếu trong lịch chiếu lên row.
                    let date = dateFormatter.string(from: arrLichChieu[indexPath.row].ngayChieu!)
                    cell?.lbNgayChieu.text = date
                } else {
                    cell?.lbNgayChieu.text = "Xuất chiếu sẽ cập nhật sau"
                }
            }
        }
        //Số xuất chiếu sẽ bằng số button
        if arrXuatChieu.count > 0 {
            let numberButton = arrXuatChieu.count
            for i in 0..<numberButton {
                //Hàm khởi tạo và thiết lập hiển thị cho button
                let button = UIButton(type: UIButtonType.custom)
                button.addTarget(self, action: #selector(timeStart), for: UIControlEvents.touchUpInside)
                button.setTitle(arrXuatChieu[i].gioChieu, for: .normal)
                button.tag = indexPath.row
                if i != 0 {
                    toaDo_X += CGFloat((45 + 20) )
                }
                
                if toaDo_X == self.view.frame.size.width || toaDo_X + CGFloat(45 + 20) > self.view.frame.size.width {
                    toaDo_Y += 35
                    print(toaDo_Y)
                    toaDo_X = 10
                }
                button.frame = CGRect(x: toaDo_X, y: toaDo_Y, width: 45, height: 22)
                button.layer.borderWidth = 1.00
                button.layer.borderColor = UIColor.orange.cgColor
                button.titleLabel?.font = UIFont.init(name: "Helvetica", size: 14)
                button.layer.cornerRadius = 5.0
                button.setTitleColor(UIColor.orange, for: .normal)
                button.backgroundColor = UIColor.clear
                //tag button = xuất chiếu id
                button.tag = arrXuatChieu[i].id_XuatChieu!
                cell?.contentView.addSubview(button)
                
            }
            arrXuatChieu.removeAll()
        }
        
        return cell!
    
    }
    func timeStart(sender:UIButton) {
        //kiểm tra đăng nhập
        let phone = DataManager.defaultDataManager().getPhone()
        if  phone != "" {
            //đã đăng nhập
            print(sender.tag)
            let vc = NumberTicKetViewController()
            vc.id_XuatChieu = sender.tag
            navigationController?.pushViewController(vc, animated: true)
        }else{
            //chưa đăng nhập
            let alertController = UIAlertController(title: "Thông báo", message: "Bạn chưa đăng nhập", preferredStyle:UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self](UIAlertAction) in
                guard let newSelf = self else{return}
                let vc = LoginViewController()
                
                newSelf.present(vc, animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return " "

    }
    // Hàm custom cho header ( tên phim)
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        for item in (view.subviews) {
            if item.isMember(of: UILabel.self)
            {
                item.removeFromSuperview()
            }
        }
        let lb = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.width, height: view.frame.height))
        lb.textColor = #colorLiteral(red: 0.9942641854, green: 0.330311358, blue: 0.004172504414, alpha: 1)
        lb.text =  "🎬 " + arrPhim[section].tenPhim!
        view.addSubview(lb)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
