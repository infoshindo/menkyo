//
//  LoginViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/10/28.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let common: Common = Common();
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorEmailField: UILabel!
    @IBOutlet weak var errorPasswordField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitSend(_ sender: AnyObject) {
        errorEmailField.text = ""
        errorPasswordField.text = ""
        
        let query: String = common.apiUrl + "login/?" + "user_email=" + emailTextField.text! + "&user_password=" + passwordTextField.text!
        let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let URL:NSURL = NSURL(string: encodedURL)!
        let jsonData :NSData = NSData(contentsOf: URL as URL)!
        
        do
        {
            let json = try JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as! [String:String]
            if json["status"] == "ng"
            {
                // エラーメッセージの設定
                errorEmailField.text = json["user_email"]
                errorPasswordField.text = json["user_password"]
            }
            else if json["status"] == "ok"
            {
                // 必要な値の保存
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud.set(json["user_id"], forKey: "user_id")
                ud.set(json["user_email"], forKey: "user_email")
                ud.set(json["auto_logins_id"], forKey: "auto_logins_id")
                ud.set(json["auto_logins_created_at"], forKey: "auto_logins_created_at")
                ud.set(json["auto_logins_updated_at"], forKey: "auto_logins_updated_at")
                
                // ログイントップページへ遷移
                let storyboard: UIStoryboard = self.storyboard!
                let nextView = storyboard.instantiateViewController(withIdentifier: "loginTop") as! ViewController
                self.present(nextView, animated: false, completion: nil)

            }
        }
        catch
        {
            // エラー処理
            print("通信エラー")
        }
    }
    
}
