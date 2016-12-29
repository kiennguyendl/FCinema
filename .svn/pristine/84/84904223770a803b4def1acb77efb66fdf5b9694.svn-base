//
//  CinemaViewController.swift
//  MockProject1
//
//  Created by PhatVQ on 12/11/2016.
//  Copyright © 2016 Kien Nguyen Dang. All rights reserved.
//

import UIKit

class CinemaViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var searchController:UISearchController!
    
    var arrCinema = [Rap]() // Mảng danh sách rạp phim
    var searchResult:[Rap] = [] // Mảng chứa danh sách rạp phim sau khi search
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        //Custom thanh searchbar ( màu sắc, màu chữ...)
        searchController.searchBar.placeholder = "Tên rạp cần tìm ..."
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.orange
        tableview.tableHeaderView = searchController.searchBar
    
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UINib(nibName: "CinemaTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        // Lấy danh sách rạp từ database.
        let dbCommand = "Select * From Rap"
        let arrRap = DataManager.defaultDataManager().getRowsRap(dbCommand)
        arrCinema = arrRap
        
        self.navigationItem.title = "Danh sách rạp"
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
extension CinemaViewController:UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate {
    // Số section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // Mỗi row dùng để hiển thị thông tin 1 rạp.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.searchResult.count
        }else{
            return self.arrCinema.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CinemaTableViewCell
        
        // Nếu user đang thực hiện tìm kiếm thì kết quả hiển thị trên tableview sẽ lấy từ mảng searchResults[]
        if searchController.isActive && searchController.searchBar.text != ""{
            cell.Photo.image = UIImage(named: searchResult[indexPath.row].hinhRap!)
            cell.lbName.text = searchResult[indexPath.row].tenRap
            cell.lbAddress.text = "🏩" + searchResult[indexPath.row].diaChi!
            cell.lbPhone.text = "☎️" + searchResult[indexPath.row].soDienThoai!
        }
        // Lấy kết quả từ mảng arrCinema hiển thị lên tableview
        else {
            cell.Photo.image = UIImage(named: arrCinema[indexPath.row].hinhRap!)
            cell.lbName.text = arrCinema[indexPath.row].tenRap
            cell.lbAddress.text = "🏩" + arrCinema[indexPath.row].diaChi!
            cell.lbPhone.text = "☎️" + arrCinema[indexPath.row].soDienThoai!
        }
        return cell    }
    
    // Thiết lập chiều cao cho row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // Bắt sự kiện khi user chọn 1 rạp để xem.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != ""{
            let rapSelected = searchResult[indexPath.row]
            let vc = FilmOfCinemaViewController()
            vc.rap = rapSelected  // gán thông tin rạp dc chọn vào biến trung gian để truyền qua màn hình "FilmOfCinema"
            navigationController?.pushViewController(vc, animated: true)
        }else {
            let rapSelected = arrCinema[indexPath.row]
            let vc = FilmOfCinemaViewController()
            vc.rap = rapSelected // gán thông tin rạp dc chọn vào biến trung gian để truyền qua màn hình "FilmOfCinema"
            navigationController?.pushViewController(vc, animated: true)
        }
        searchController.isActive = false
    }
    // Hàm filter dữ liệu cho chức năng tìm kiếm (theo tên rạp)
    func filterContentforSearch(searchString:String)
    {
        self.searchResult = self.arrCinema.filter(){nil != $0.tenRap?.lowercased().folding(options: .diacriticInsensitive, locale: .current).range(of: searchString.lowercased().folding(options: .diacriticInsensitive, locale: .current))}
        self.tableview.reloadData()
    }
    // Cập nhật kết quả tìm kiếm.
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentforSearch(searchString: searchController.searchBar.text!)
    }


}

