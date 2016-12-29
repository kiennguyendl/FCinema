//
//  DetailFilmViewController.swift
//  MockProject1
//
//  Created by Tuan anh Dang on 11/10/16.
//  Copyright © 2016 Kien Nguyen Dang. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class DetailFilmViewController: UIViewController {
    
    @IBOutlet weak var imgFilm: UIImageView!
    @IBOutlet weak var txtFilmName: UILabel!
    @IBOutlet weak var txtKhoiChieu: UILabel!
    @IBOutlet weak var txtTheLoai: UILabel!
    @IBOutlet weak var txtThoiLuong: UILabel!
    @IBOutlet weak var txtDaoDien: UILabel!
    @IBOutlet weak var txtTenRap: UILabel!
    @IBOutlet weak var tableDetailFilm: UITableView!
    var index:IndexPath? = nil
    var rowHeight:CGFloat? = 0
    var phim:Phim? = nil
    var rowTheaterCurrent:Int? = nil
    var dateNow:String? = nil
    
    var arrTimeStart = [XuatChieu]()
    var arrDateStart = [LichChieu]()
    var arrTheater = [Rap]()
    
    var pickerTheater:UIPickerView!
    var btnX:UIButton!
    var viewTheater:UIView!
    var isHide:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //set up tableview
        tableDetailFilm.delegate = self
        tableDetailFilm.dataSource = self
        tableDetailFilm.estimatedRowHeight = 100
        tableDetailFilm.register(UINib(nibName: "DetailContentTableViewCell", bundle: nil), forCellReuseIdentifier: "cell_content")
        tableDetailFilm.register(UINib(nibName: "DetailCinemaTableViewCell", bundle: nil), forCellReuseIdentifier: "cell_cinema")
        tableDetailFilm.register(UINib(nibName: "DetailTimeStartTableViewCell", bundle: nil), forCellReuseIdentifier: "cell_timestart")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateNow = dateFormatter.string(from: Date())
        
        //load detail film data
        prepareData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickImg))
        imgFilm.addGestureRecognizer(tapGesture)
        
    }
    
    func clickImg() {
        let mainBundle = Bundle.main
        let filePath = mainBundle.path(forResource: "trailer1", ofType: "mp4")
        let url = URL(fileURLWithPath: filePath!)
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
//        let vc = TrailerViewController()
//        vc.linkYouTube = (phim?.url)!
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareData(){
        if phim != nil {
            //load data default
            txtFilmName.text = (phim?.tenPhim)!
            txtDaoDien.text = "Đạo Diễn " + (phim?.daoDien)! + "."
            txtTheLoai.text = "Thể Loại: " + (phim?.theLoai)! + "."
            imgFilm.image = UIImage(named: (phim?.hinhPhim)!)
            self.title = phim?.tenPhim
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.string(from: (phim?.ngayKhoiChieu)! as Date)
            txtKhoiChieu.text = "Khởi Chiếu: " + date
            txtThoiLuong.text = "Thời Lượng: " + String(format: "%d", (phim?.thoiLuong)!) + " Phút"
            
            //lấy danh sách rạp
            arrTheater = DataManager.defaultDataManager().getRowsRap("select * from Rap,LichChieu where LichChieu.id_Phim = " + String(format: "%d", (phim?.id_Phim)!) + " and Rap.id_Rap = LichChieu.id_Rap GROUP BY Rap.id_Rap")
            if arrTheater.count > 0 {
                //lấy danh sách lịch chiếu
                arrDateStart = DataManager.defaultDataManager().getRowsLichChieu("select * from LichChieu where LichChieu.id_Rap = " + String(format:"%d" , arrTheater[0].id_Rap!) + " and LichChieu.id_Phim = " + String(format: "%d", (phim?.id_Phim)!))
                rowTheaterCurrent = 0
            }
            if arrDateStart.count > 0 {
                arrDateStart = arrDateStart.filter(){ $0.ngayChieu! > Date() ? true : false}
                if arrDateStart.count > 0 {
                    //lấy danh sách xuất chiếu
                    arrTimeStart = DataManager.defaultDataManager().getRowsXuatChieu("select * from XuatChieu where XuatChieu.id_LichChieu = " + String(format:"%d" ,arrDateStart[0].id_LichChieu!))
                }

            }
            
            
            txtTenRap.text = "Cụm Rạp: "
            if arrTheater.count > 0 {
                for items in arrTheater {
                    if arrTheater.index(of: items) == 0 {
                        txtTenRap.text = txtTenRap.text! + items.tenRap!
                    }else{
                        txtTenRap.text = txtTenRap.text! + "," + items.tenRap!
                    }

                }
                txtTenRap.text = txtTenRap.text! + "."
            }else{
                txtTenRap.text = txtTenRap.text! + "Chưa Có."
            }
            
        }
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

extension DetailFilmViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }else{
            return arrDateStart.count == 0 ? 1 : arrDateStart.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //section nội dung phim
        if indexPath.section == 0 {
            var cell_content = tableDetailFilm.dequeueReusableCell(withIdentifier: "cell_content") as?DetailContentTableViewCell
            if  cell_content == nil {
                cell_content = DetailContentTableViewCell()
            }
            if phim != nil {
                cell_content?.txtPhimNoiDung.text = phim?.noiDung
            }
            
            return cell_content!
        }
        
        //section rạp phim
        if indexPath.section == 1 {
            var cell_cinema = tableDetailFilm.dequeueReusableCell(withIdentifier: "cell_cinema") as? DetailCinemaTableViewCell
            if  cell_cinema == nil {
                cell_cinema = DetailCinemaTableViewCell()
            }
            if arrTheater.count > 0 {
                cell_cinema?.btnRap.setTitle(arrTheater[rowTheaterCurrent!].tenRap, for: .normal)
                cell_cinema?.btnRap.addTarget(self, action: #selector(clickRap), for: UIControlEvents.touchUpInside)
            }else{
                cell_cinema?.btnRap.setTitle("Sẽ cập nhật sau", for: .normal)
            }


            return cell_cinema!
        }
        
        //section xuất chiếu phim
        var cell_timestart = tableDetailFilm.dequeueReusableCell(withIdentifier: "cell_timestart") as? DetailTimeStartTableViewCell
        if  cell_timestart == nil {
            cell_timestart = DetailTimeStartTableViewCell()
        }
        
        for item in (cell_timestart?.contentView.subviews)! {
            if item.isMember(of: UIButton.self)
            {
                item.removeFromSuperview()
            }
        }
        
        
        
        var toaDo_X:CGFloat = 10
        var toaDo_Y:CGFloat = 30
        
        
        
        if arrDateStart.count > 0  {
            //lấy danh sách xuất chiếu theo lịch chiếu
            arrTimeStart = DataManager.defaultDataManager().getRowsXuatChieu("select * from XuatChieu where XuatChieu.id_LichChieu = " + String(format:"%d" ,arrDateStart[indexPath.row].id_LichChieu!))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let date = dateFormatter.string(from: arrDateStart[indexPath.row].ngayChieu!)
            cell_timestart?.txtNgayChieu.text = date
        }else{
            cell_timestart?.txtNgayChieu.text = "  Xuất Chiếu Sẽ cập nhật sau"
        }
        
        if arrTimeStart.count > 0 {
            //số button bằng số xuất chiếu
            let numberButton = arrTimeStart.count
            for i in 0..<numberButton {
                
                let button = UIButton(type: UIButtonType.custom)
                button.addTarget(self, action: #selector(timeStart), for: UIControlEvents.touchUpInside)
                button.setTitle(arrTimeStart[i].gioChieu, for: .normal)
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
                button.tag = arrTimeStart[i].id_XuatChieu!
                cell_timestart?.contentView.addSubview(button)
                
                
            }
            arrTimeStart.removeAll()
        }
        
        
        
        rowHeight = toaDo_Y + 35
        
        return cell_timestart!
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 1 {
            return UITableViewAutomaticDimension
        }
        return rowHeight!
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
    
    //tao view add pickerview de chọn rạp
    func clickRap() {
        
        if isHide == false {
            if pickerTheater == nil {
                
                self.viewTheater = UIView(frame: CGRect(x: 0, y: (self.view.frame.size.height) - 175 , width: (self.view.frame.size.width), height: 175))
                self.viewTheater.backgroundColor = UIColor.orange
                self.viewTheater.alpha = 0
                
                self.btnX = UIButton(frame: CGRect(x: self.viewTheater.frame.size.width - 25, y: 0, width: 25, height: 25))
                self.btnX.addTarget(self, action: #selector(self.cancel), for: UIControlEvents.touchUpInside)
                self.btnX.setTitle("X", for: .normal)
                
                self.pickerTheater = UIPickerView(frame: CGRect(x: 0, y: (self.viewTheater.frame.size.height) - 125, width: (self.viewTheater.frame.size.width), height: 125))
                
                self.pickerTheater.dataSource = self
                self.pickerTheater.delegate = self
                
                
                self.viewTheater.addSubview(self.btnX)
                self.viewTheater.addSubview(self.pickerTheater)
                
                UIView.animate(withDuration: 0.3 ) {
                    self.viewTheater.alpha = 1
                    self.view.addSubview(self.viewTheater)
                }
            }else{
                UIView.animate(withDuration: 0.3 ) {
                    self.viewTheater.alpha = 1
                    self.view.addSubview(self.viewTheater)
                }

                
            }
            
            isHide = true
            
        }
        
    }
    
    func cancel() {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewTheater.alpha = 0
        }, completion: { (finished: Bool) in
            if(finished)
            {
                self.viewTheater.removeFromSuperview()
                self.isHide = false
            }
            
        })
    }
    
}

extension DetailFilmViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //row = số rạp
        return arrTheater.count > 0 ? arrTheater.count : 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrTheater.count > 0 ? arrTheater[row].tenRap : "Chưa Có"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if arrTheater.count > 0 {
            //chon rap thì load lại xuất chiếu theo rạp đã chọn
            arrDateStart = DataManager.defaultDataManager().getRowsLichChieu("select * from LichChieu where LichChieu.id_Rap = " + String(format:"%d" , arrTheater[row].id_Rap!) + " and LichChieu.id_Phim = " + String(format: "%d", (phim?.id_Phim)!))
            if arrDateStart.count > 0 {
                arrDateStart = arrDateStart.filter(){ $0.ngayChieu! > Date() ? true : false}
            }
            //vị trí rạp chọn trong ds rạp để load section 1
            rowTheaterCurrent = row
        }
        self.tableDetailFilm.reloadData()
        cancel()
    }
    
}
