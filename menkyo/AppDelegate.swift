//
//  AppDelegate.swift
//  menkyo
//
//  Created by infosquare on 2016/09/25.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let common: Common = Common();

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // ログイン判定
        var login_flag: Bool = false
        let ud = UserDefaults.standard
        let isLogin = ud.object(forKey: "isLogin")
        
        if (isLogin != nil) {
            let auto_logins_id: String = ud.object(forKey: "auto_logins_id") as! String
            let user_id: String = ud.object(forKey: "user_id") as! String
            let query: String = common.apiUrl + "login/auto_login_check/" + auto_logins_id + "/" + user_id
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
                print("通信エラー")
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
                let query: String = common.apiUrl + "login/auto_login_issue/" + auto_logins_id
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
            
            // ログイン後トップページを表示
            self.window = UIWindow(frame: UIScreen.main.bounds)
            //Storyboardを指定
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //Viewcontrollerを指定
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "loginTop")
            //rootViewControllerに入れる
            self.window?.rootViewController = initialViewController
            //表示
            self.window?.makeKeyAndVisible()
        } else {
            // ログインしてない
            // 初期ページを表示
            self.window = UIWindow(frame: UIScreen.main.bounds)
            //Storyboardを指定
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //Viewcontrollerを指定
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "initial")
            //rootViewControllerに入れる
            self.window?.rootViewController = initialViewController
            //表示
            self.window?.makeKeyAndVisible()
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

