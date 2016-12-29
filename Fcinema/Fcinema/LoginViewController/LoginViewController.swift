//
//  LoginViewController.swift
//  MockProject1
//
//  Created by Kien Nguyen Dang on 11/11/16.
//  Copyright © 2016 Kien Nguyen Dang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtSdt: UITextField!
    @IBOutlet weak var txtMatkhau: UITextField!
    //biến lưu user default
    var userInfo: UserDefaults = UserDefaults.standard
    //biến singleton
    static var isInstance = LoginViewController()
    //số lần login fail
    var numLoginFail = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //hide mật khẩu
        txtMatkhau.isSecureTextEntry = true
        txtSdt.becomeFirstResponder()
        txtSdt.keyboardType = UIKeyboardType.numberPad
        
        //tạo background
        UIGraphicsBeginImageContext(UIScreen.main.bounds.size)
        UIImage(named: "bg_login.jpg")?.draw(in: UIScreen.main.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clickDone() {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func keyBoardWillChangeFrame(notification: NSNotification){
        let keyBoardRect: CGRect = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
        let keyBoardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
        for contrain in self.view.constraints {
            if contrain.identifier == "centerY" {
                contrain.constant = -fabs(self.view.frame.size.height - keyBoardRect.origin.y)/2
                UIView.animate(withDuration: TimeInterval(keyBoardAnimationDuration), animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func btnDangNhap(_ sender: Any) {
        var count: Int = 0
        
        //check inoput info
        if txtSdt.text == "" || txtMatkhau.text == ""{
            var str = ""
            
            if txtSdt.text == ""{
                str = str + "số điện thoại, "
            }
            if txtMatkhau.text == ""{
                str = str + "mật khẩu."
            }
            
            let mess = "Vui lòng điền đầy đủ thông tin " + str
            showAlertDialog(Tilte: "Warning", message: mess, action: "OK")
            return
        }
        
        //check định dạng số điện thoại
        if !validatePhone(value: txtSdt.text!){
            showAlertDialog(Tilte: "", message: "Số điện thoại không đúng định dạng, vui lòng nhập lại", action: "OK")
            txtSdt.text = ""
            txtSdt.becomeFirstResponder()
            return
        }

        
        //check lenght of phone number
        if (txtSdt.text?.characters.count)! < 10 || (txtSdt.text?.characters.count)! > 11{
            let exitForm = UIAlertController(title: "", message: "Độ dài số điện thoại là 10 hoặc 11 số, vui lòng nhập lại", preferredStyle: UIAlertControllerStyle.alert)
            exitForm.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.txtSdt.text = ""
                self.txtMatkhau.text = ""
                self.txtSdt.becomeFirstResponder()
            }))
            self.present(exitForm, animated: true, completion: nil)
        }
        
        //lấy danh sách tài khoản
        let listTK = DataManager.defaultDataManager().getRowTaiKhoan("select * from NguoiDung")
        
        for index in listTK{
            if ((txtSdt.text?.caseInsensitiveCompare(index.soDienThoai!)) == .orderedSame){
                if ((txtMatkhau.text?.caseInsensitiveCompare(index.matKhau!)) == .orderedSame){
                    //lưu user default nếu thông tin nhập vào là đúng
                    LoginViewController.isInstance.userInfo.setValue(txtSdt.text, forKey: "SoDienThoai")
                    LoginViewController.isInstance.userInfo.synchronize()
                }
                count = count + 1
            }
        }
        
        //hiện thông báo đăng nhập thành công
        if LoginViewController.isInstance.userInfo.value(forKeyPath: "SoDienThoai") != nil && count != 0{
            let alertController = UIAlertController(title: "Thông báo", message: "Bạn đăng nhập thành công", preferredStyle:UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self](UIAlertAction) in
                guard let newSelf = self else{return}
                
                newSelf.dismiss(animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
        }else{
            //hiện thông báo sai mật khẩu
            if LoginViewController.isInstance.userInfo.value(forKeyPath: "SoDienThoai") == nil && count != 0{
                numLoginFail = numLoginFail + 1
                txtMatkhau.text = ""
                txtMatkhau.becomeFirstResponder()
                if numLoginFail < 3{
                    showAlertDialog(Tilte: "", message: "Bạn đã nhập sai mật khẩu", action: "OK")
                }else{
                    //thoát nếu nhập mật khẩu sai 3 lần
                    let exitForm = UIAlertController(title: "Thoát", message: "Bạn đã nhập sai mật khẩu quá 3 lần", preferredStyle: UIAlertControllerStyle.alert)
                    exitForm.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        self.exitLogin()
                    }))
                    self.present(exitForm, animated: true, completion: nil)
                }
            }else{
                txtSdt.text = ""
                txtMatkhau.text = ""
                showAlertDialog(Tilte: "", message: "Tài khoản không tồn tại, vui lòng đăng ký tài khoản", action: "OK")
            }
        }
    }

    //button huỷ btnDangKy = btnHuy
    @IBAction func btnDangKy(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAlertDialog(Tilte: String, message: String, action: String) {
        let alert = UIAlertController(title: Tilte, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func exitLogin() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //validate phone
    func validatePhone(value: String) -> Bool {
        let PHONE_REGEX = "^[0]{1}[19]{1}[0-9]{8,9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
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
