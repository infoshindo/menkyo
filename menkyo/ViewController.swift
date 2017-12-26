//
//  ViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/09/25.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {
    let common: Common = Common()
    var check_login: Bool = false
    
    @IBOutlet weak var accountView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }
        
        // ログインチェック
        check_login = common.CheckLogin()

        // ログインしてたら登録ボタン・ログインボタンを非表示
        if check_login {
            accountView.isHidden = true
        } else {
            accountView.isHidden = false
        }
        
        LoadingProxy.set(v: self)
    }
    
    func moveMaintenance() {
        // メンテナンス中ならメンテナンス画面へ遷移
        let maintenance = common.CheckMaintenance()
        if ((maintenance) != nil) {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextView = storyboard.instantiateViewController(withIdentifier: "MaintenanceView") as! MaintenanceViewController
            nextView.maintenance_time = maintenance!
            self.present(nextView, animated: false, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // メンテナンス判定
        moveMaintenance()
    }
    
    func alert_login() {
        /*
         *************************
         非ログイン状態の場合アラートを表示
         *************************
         */
        
        // タイトル, メッセージ, Alertのスタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "ログインして下さい。", message: "まだ会員登録がお済でない場合は\n会員登録後、ログインすると\nご利用になれます。", preferredStyle:  UIAlertControllerStyle.alert)
        
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // OKボタン押下）
            (action: UIAlertAction!) -> Void in
        })
        
        alert.addAction(defaultAction)
        
        // Alertを表示
        present(alert, animated: true, completion: nil)
        return;

    }
    
    @IBAction func tapHistory(_ sender: AnyObject) {
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }
        
        //  非ログイン状態の場合アラートを表示
        if !check_login {
            self.alert_login()
            return;
        }
        
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "history") as! HistoryViewController
        self.present(nextView, animated: false, completion: nil)
    }
    @IBAction func tapMylist(_ sender: AnyObject) {
        
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }
        
        //  非ログイン状態の場合アラートを表示
        if !check_login {
            self.alert_login()
            return;
        }

        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "mylist") as! MylistViewController
        self.present(nextView, animated: false, completion: nil)

    }
    
    @IBAction func tapKiken5(_ sender: AnyObject) {
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }
        
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "kiken") as! KikenyosokuViewController
        nextView.examsType = "危険予測問題"
        nextView.total = "5" // ミニテストの場合の合計問題数
        self.present(nextView, animated: false, completion: nil)
        
        // ローディングON
        SVProgressHUD.show()
    }
    
    @IBAction func tapKiken10(_ sender: AnyObject) {
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }
        
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "kiken") as! KikenyosokuViewController
        nextView.examsType = "危険予測問題"
        nextView.total = "10" // ミニテストの場合の合計問題数
        self.present(nextView, animated: false, completion: nil)
        
        // ローディングON
        SVProgressHUD.show()
    }
    
    @IBAction func tapHonmen(_ sender: AnyObject) {
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }
        
        //  非ログイン状態の場合アラートを表示
        if !check_login {
            self.alert_login()
            return;
        }
        
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "karimen") as! KarimenViewController
        nextView.examsType = "本試験"
        self.present(nextView, animated: false, completion: nil)
        
        // ローディングON
        SVProgressHUD.show()
    }
    
    @IBAction func tapKarimen(_ sender: AnyObject) {
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }

        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "karimen") as! KarimenViewController
        nextView.examsType = "仮免許"
        self.present(nextView, animated: false, completion: nil)
        
        // ローディングON
        SVProgressHUD.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

