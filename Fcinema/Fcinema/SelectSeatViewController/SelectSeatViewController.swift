//
//  SelectSeatViewController.swift
//  MockProject1
//
//  Created by Tuan anh Dang on 11/13/16.
//  Copyright © 2016 Kien Nguyen Dang. All rights reserved.
//

import UIKit

class SelectSeatViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = [String]()
    //số vé mua
    var numberTicket:Int = 0
    //số ghế của rạp
    var numberSeat:Int = 0
    //số dòng hiện tại trong collection view
    var row:Int = 0
    //số item trong 1 dòng collection view
    let numberSeatInCollectionView = 10
    //mảng số ghế đã đặt
    var selectedSeat = [Ghe]()
    
    var seat = [Ghe]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        prepareData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareData(){
        collectionView.register(UINib(nibName: "SeatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.title = "Chọn Ghế"
        
        //kiem tra data
        if data.count > 0 {
            numberTicket = Int(data[0])!
            
            numberSeat = Int(data[1])!

            seat = DataManager.defaultDataManager().getRowGhe("select * from Ghe where Ghe.id_XuatChieu = " + data[2])
            
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
    @IBAction func clickDone(_ sender: Any) {
        //kiểm tra số vé đủ chưa
        if selectedSeat.count < numberTicket {
            let alertController = UIAlertController(title: title, message: "Vui lòng chọn đủ số ghế", preferredStyle:UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }else{

            let soDienThoai = DataManager.defaultDataManager().getPhone()
            
            //kiem tra đăng nhập
            if soDienThoai == ""  {
                let alertController = UIAlertController(title: "Thống báo", message: "Bạn chưa đăng nhập , Vui lòng đăng nhập", preferredStyle:UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self](UIAlertAction) in
                    guard let newSelf = self else{return}
                    let vc = LoginViewController()
                    newSelf.navigationController?.pushViewController(vc, animated: true)
                }))
                self.present(alertController, animated: true, completion: nil)
                
            }else{
                //lấy người dùng
                let nguoidung = DataManager.defaultDataManager().getRowTaiKhoan("select * from NguoiDung where NguoiDung.soDienThoai = '\(soDienThoai)'")
                //kiem tra nguoi dung
                if nguoidung.count > 0 {
                    var message = "Bạn đã chắc chắn muốn đặt ghế: "
                    for item in selectedSeat {
                        if selectedSeat.index(of: item) == 0 {
                            message = message + "\(item.tenGhe!)"
                        }
                        else{
                            message = message + ", " + "\(item.tenGhe!)"
                        }
                    }
                    let alertController = UIAlertController(title: "Thống báo", message: message, preferredStyle:UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self](UIAlertAction) in
                        guard let newSelf = self else{return}

                        //insert vào lịch sử giao dịch
                        DataManager.defaultDataManager().updateDatabase("insert into LichSuGiaoDich(id_NguoiDung,id_XuatChieu,tongTien) values (\(nguoidung[0].idTK!),\(newSelf.data[2]),\(newSelf.data[5]))")
                        
                        let id_LichSuGiaoDich = DataManager.defaultDataManager().getID("LichSuGiaoDich","id_LichSuGiaoDich")
                        
                        //add ghế đã đặt xuống sqlite
                        for i in 0..<newSelf.selectedSeat.count {
                            DataManager.defaultDataManager().updateDatabase("insert into Ghe(id_LichSuGiaoDich,tenGhe,id_XuatChieu) values (\(id_LichSuGiaoDich),'\(newSelf.selectedSeat[i].tenGhe!)',\(newSelf.selectedSeat[i].id_XuatChieu!))")
                        }
                        let vc = UserInfoViewController()
                        
                        
//                        var arrVC = newSelf.navigationController?.viewControllers
//                        for view in arrVC! {
//                            if !view.isKind(of: HomeViewController.self) {
//                                arrVC?.remove(at: (arrVC?.index(of: view))!)
//                            }
//                        }
////                        arrVC?.append(vc)
//                        newSelf.navigationController?.viewControllers = arrVC!
//                        _ = newSelf.navigationController?.popToViewController(vc, animated: true)
                        newSelf.present(vc, animated: true, completion: nil)
                        _ = newSelf.navigationController?.popToRootViewController(animated: false)

                        
                        
                        
                        
                    }))
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            


        }
        
    }

}

extension SelectSeatViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var number = 0
        if numberSeat % (numberSeatInCollectionView - 1) == 0 {
            number = numberSeat / (numberSeatInCollectionView - 1)
        }else{
            number = (numberSeat / (numberSeatInCollectionView - 1) ) + 1
        }
        return number + numberSeat
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SeatCollectionViewCell
        if cell == nil {
            cell = SeatCollectionViewCell()
        }
        
        if indexPath.item % numberSeatInCollectionView == 0 {
            row =  Int(indexPath.item / numberSeatInCollectionView)
            cell?.lblSeat.text = String(UnicodeScalar(65 + row)!)
            cell?.lblSeat.backgroundColor = UIColor.clear
            cell?.imgSeat.isHidden = true
            cell?.lblSeat.textColor = UIColor.black
        }else{
            //tính dòng hiện tại
            let number = Int(indexPath.item - ((row) * (numberSeatInCollectionView - 1))) - (1 * row)
            //tạo tên bắt đầu từ A
            let strNameSeat = String(UnicodeScalar(65 + row)!) + "\(number)"
            cell?.lblSeat.text =  "\(number)"
            cell?.lblSeat.textColor = UIColor.white
            cell?.imgSeat.isHidden = false
            //kiểm tra ghế đã đặt chưa
            let isOrder = seat.contains(where: { (item:Ghe) -> Bool in
                if (item.tenGhe == strNameSeat){
                    return true
                }else{
                    return false
                }
            })
            //ghế đã đặt màu đỏ , chựa đặt màu xám
            if isOrder == true {
                cell?.lblSeat.backgroundColor = UIColor.red
            }else{
                let isChoose = selectedSeat.contains(where: { (item:Ghe) -> Bool in
                    if(item.tenGhe == strNameSeat){
                        return true
                    }else{
                        return false
                    }
                })
                if isChoose == true {
                    cell?.lblSeat.backgroundColor = UIColor.orange
                }else{
                    cell?.lblSeat.backgroundColor = UIColor.white
                }
                
            }
            
            
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //lấy cell user chọn
        let cell = collectionView.cellForItem(at: indexPath) as? SeatCollectionViewCell
        
        if cell != nil {
            //kiểm tra ghế có được chọn hay ko
            if cell?.lblSeat.backgroundColor != UIColor.red && cell?.lblSeat.backgroundColor != UIColor.clear {
                
                    let number = Int(indexPath.item - (Int(indexPath.item / 10) * (numberSeatInCollectionView - 1))) - (1 * Int(indexPath.item / 10))
                    let strNameSeat = String(UnicodeScalar(65 + Int(indexPath.item / 10))!) + "\(number)"
                    
                    if cell?.lblSeat.backgroundColor == UIColor.orange {
                        selectedSeat = selectedSeat.filter(){ $0.tenGhe != strNameSeat ? true : false}
                        cell?.lblSeat.backgroundColor = UIColor.white
                        
                    }else{
                        //kiểm tra chọn đủ ghế chưa
                        if selectedSeat.count < numberTicket {
                            //chưa thì đổi màu và add vào mảng
                            let selectedGhe = Ghe()
                            selectedGhe.id_XuatChieu = Int(data[2])
                            selectedGhe.tenGhe = strNameSeat
                            selectedGhe.id_LichSuGiaoDich = nil
                            selectedSeat.append(selectedGhe)
                            cell?.lblSeat.backgroundColor = UIColor.orange
                        }else{
                            // đủ thì thông báo
                            let alertController = UIAlertController(title: title, message: "Bạn đã chọn đủ số ghế", preferredStyle:UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                

            }
        }
        
        
    }

}
extension SelectSeatViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //tính size theo số item trong 1 dòng của collection view
        let size = (self.collectionView.frame.size.width - (8 * (CGFloat(numberSeatInCollectionView) + 1))) / CGFloat(numberSeatInCollectionView)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8 , left: 8, bottom: 8, right: 8)
    }
}
