//
//  MenuViewController.swift
//  MockProject1
//
//  Created by PhatVQ on 13/11/2016.
//  Copyright © 2016 Kien Nguyen Dang. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.view.backgroundColor = UIColor.orange
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btDanhSachRap(_ sender: Any) {
        let vc = CinemaViewController()
        //self.navigationController?.navigationBar.backItem?.title = "back"
        //vc.navigationItem.backBarButtonItem?.title = "back"
        self.navigationController?.pushViewController(vc, animated: true)
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
