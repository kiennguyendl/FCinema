//
//  TrailerViewController.swift
//  Fcinema
//
//  Created by Tuan anh Dang on 11/21/16.
//  Copyright © 2016 Tuan anh Dang. All rights reserved.
//

import UIKit

class TrailerViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var linkYouTube:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if linkYouTube != "" {
            webView.bounds.origin.x = webView.bounds.origin.x + 40
            let url = URL(string: linkYouTube)
            let request = URLRequest(url: url!)
            webView.delegate = self
            //webView.mediaPlaybackRequiresUserAction = false
            //webView.allowsInlineMediaPlayback = true
            webView.loadRequest(request)
            
            
            
        }else{
            let alertController = UIAlertController(title: "Thông báo", message: "Có lỗi xảy ra vui lòng quay lại sau.", preferredStyle:UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self](UIAlertAction) in
                guard let newSelf = self else{return}
                
                _ = newSelf.navigationController?.popViewController(animated: true)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
//        NotificationCenter.default.addObserver(self, selector: #selector(done), name: Notification.Name.UIWindowDidBecomeHidden, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func done() {
//        self.navigationController?.popViewController(animated: true)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TrailerViewController:UIWebViewDelegate{
    
}
