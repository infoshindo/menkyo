//
//  Common.swift
//  menkyo
//
//  Created by infosquare on 2016/10/27.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class Common: UIViewController{
    #if DEBUG
        var apiUrl = "http://kaifu.shikakun_api.net/"
    #else
        var apiUrl = "http://api.shikakun.net/"
    #endif
    
    var domainUrl: String = "http://www.shikakun.net/"
    var imageUrl: String = "http://www.shikakun.net/img/"
    var examsType: String = "" // 仮免許 OR 本試験
    // キャッシュのパス
    var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // メンテナンス判定
    func CheckMaintenance() -> String? {
        // オフラインの場合はreturn
        if self.CheckNetwork() == false {
            return nil
        } else {
            let query: String = self.apiUrl + "maintenance/check/"
            let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let URL:NSURL = NSURL(string: encodedURL)!
            let jsonData :NSData = NSData(contentsOf: URL as URL)!
            let maintenance = JSON(data: jsonData as Data)
            if maintenance != nil {
                return "\(maintenance["maintenance_text"])"
            } else {
                return nil
            }
        }
    }
    
    // ログイン判定
    func CheckLogin() -> Bool {
        var login_flag: Bool = false
        let ud = UserDefaults.standard
        let isLogin = ud.object(forKey: "isLogin")
        
        if (isLogin != nil) {
            let auto_logins_id: String = ud.object(forKey: "auto_logins_id") as! String
            let user_id: String = ud.object(forKey: "user_id") as! String
            let query: String = apiUrl + "login/auto_login_check/" + auto_logins_id + "/" + user_id
            let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let URL:NSURL = NSURL(string: encodedURL)!
            let jsonData :NSData = NSData(contentsOf: URL as URL)!
            do{
                let json = try JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as! [String:String]
                if json["status"] == "ok" {
                    login_flag = true;
                }
            }catch{
                // エラー処理
                print("通信エラー: ログイン判定")
            }
            
        }
        
        if login_flag {
            // ログインチェックOK
            // 2時間経過していたら、auto_login_idを再発行
            let auto_logins_updated_at: String = ud.object(forKey: "auto_logins_updated_at") as! String
            let now = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
            let updated_at: Date = dateFormatter.date(from: auto_logins_updated_at)!;
            let date1 = NSDate(timeInterval: 0, since: updated_at ) // 更新した時刻
            let date2 = NSDate(timeInterval: -60*120, since: now as Date) // 2時間前
            let now_date = NSDate(timeInterval: 0, since: now as Date) // 現在時刻
            let span = date1.timeIntervalSince(date2 as Date) // 秒差
            
            if span < 0 {
                let auto_logins_id: String = ud.object(forKey: "auto_logins_id") as! String
                let query: String = apiUrl + "login/auto_login_issue/" + auto_logins_id
                let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                let URL:NSURL = NSURL(string: encodedURL)!
                let jsonData :NSData = NSData(contentsOf: URL as URL)!
                do{
                    let json = try JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as! [String:String]
                    if json["status"] == "ok" {
                        let ud = UserDefaults.standard
                        ud.set(json["auto_logins_id"], forKey: "auto_logins_id")
                        ud.set(dateFormatter.string(from: now_date as Date), forKey: "auto_logins_updated_at")
                    }
                }catch{
                    // エラー処理
                    print("通信エラー")
                }
            }
        }
        return login_flag

    }

    func CheckNetwork() -> Bool {
        var result: Bool = false
        if CheckReachability(host_name: "google.com") {
            result = true
//            print("インターネットへの接続が確認されました")
        } else {
            result = false
//            print("インターネットに接続してください")
            
        }
        
        return result
    }
}
