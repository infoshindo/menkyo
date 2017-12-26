//
//  KarimenViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/11/03.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit
import SVProgressHUD

class KarimenViewController: UIViewController, UITabBarDelegate {
    
    let common: Common = Common()
    var result_json: JSON = []
    var question_num: Int = 0 // 問題の番号
    var examsType: String = "" // 仮免許 OR 本試験
    var check_login: Bool = false
    
    @IBOutlet weak var answerUiView: UIView!
    @IBOutlet weak var questionTextField: UILabel!
    @IBOutlet weak var questionNumTextField: UILabel!
    @IBOutlet weak var sentenceImg: UIImageView!
    @IBOutlet weak var sentenceImgConstraintHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }
        
        // ログインチェック
        check_login = common.CheckLogin()
        
        // ローディングON
        SVProgressHUD.show()
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
        
        // 初回アクセスの場合、APIから問題文を取得
        if result_json.isEmpty {
            let ud = UserDefaults.standard
            var query: String = ""
            if examsType == "仮免許" {
                if let user_id: String = ud.object(forKey: "user_id") as? String {
                    let auto_logins_id: String = ud.object(forKey: "auto_logins_id") as! String
                    query = common.apiUrl + "exams/karimen/?user_id=" + user_id + "&auto_logins_id=" + auto_logins_id
                } else {
                    query = common.apiUrl + "exams/karimen/"
                }
            } else {
                let user_id: String = ud.object(forKey: "user_id") as! String
                let auto_logins_id: String = ud.object(forKey: "auto_logins_id") as! String
                query = common.apiUrl + "exams/honmen/?user_id=" + user_id + "&auto_logins_id=" + auto_logins_id
            }
            
            let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let URL:NSURL = NSURL(string: encodedURL)!
            let jsonData :NSData = NSData(contentsOf: URL as URL)!
            result_json = JSON(data: jsonData as Data)
            
            var imageName = ""
            // 問題画像はキャッシュで保存しておく
            for (_, element) in result_json["question"] {
                // 解説用の画像
                if element["explanation_img"] != "" && element["explanation_img"] != nil {
                    // 書き込み
                    let sentenceURL = NSURL(string: common.imageUrl + element["explanation_img"].string!)
                    let data = try? Data(contentsOf: sentenceURL! as URL)
                    if !FileManager.default.fileExists(atPath: common.path + "/" + element["explanation_img"].string!)
                    {
                        // キャッシュがなかったら作成
                        FileManager.default.createFile(atPath: common.path + "/" + element["explanation_img"].string!, contents: data, attributes: nil)
                    }
                }
                if element["sentence_img"] != "" && element["sentence_img"] != nil {
                    // 標識とか道路の画像
                    imageName = element["sentence_img"].string!
                } else if element["image_name"] != "" && element["image_name"] != nil {
                    // イラスト問題の画像
                    imageName = "illust_img/" + element["image_name"].string!
                } else {
                    continue
                }
                // 書き込み
                let sentenceURL = NSURL(string: common.imageUrl + imageName)
                let data = try? Data(contentsOf: sentenceURL! as URL)
                if !FileManager.default.fileExists(atPath: common.path + "/" + imageName)
                {
                    // キャッシュがなかったら作成
                    FileManager.default.createFile(atPath: common.path + "/" + imageName, contents: data, attributes: nil)
                }
            }
        }
        
        // 問題文・問題番号の値を変更
        self.switchProces()
        
        // ローディングOFF
        SVProgressHUD.dismiss()
    }
    
    // テストを終了をタップ
    @IBAction func tapEnd(_ sender: AnyObject) {
        // メンテナンス判定
        moveMaintenance()
        
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }

        // タイトル, メッセージ, Alertのスタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "テストを終了", message: "終了しますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // OKボタン押下）
            (action: UIAlertAction!) -> Void in
            
            // 完了画面へ遷移
            self.resultView()
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            // print("Cancel")
        })
        
        // UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // Alertを表示
        present(alert, animated: true, completion: nil)
  
    }
    
    // マイリストへの登録をタップ
    @IBAction func tapMylist(_ sender: AnyObject) {
        // メンテナンス判定
        moveMaintenance()
        
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }
        
        if !check_login {
            /*
             *************************
             非ログイン状態の場合アラートを表示
             *************************
             */
            
            // タイトル, メッセージ, Alertのスタイルを指定する
            let alert: UIAlertController = UIAlertController(title: "ログインして下さい。", message: "マイリスト機能はログイン後ご利用になれます。", preferredStyle:  UIAlertControllerStyle.alert)
            
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
        
        // タイトル, メッセージ, Alertのスタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "マイリストへの登録", message: "登録しますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // OKボタン押下）
            (action: UIAlertAction!) -> Void in
            
            let ud = UserDefaults.standard
            if let auto_logins_id: String = ud.object(forKey: "auto_logins_id") as? String {
                if let user_id: String = ud.object(forKey: "user_id") as? String {
                    let query: String = self.common.apiUrl + "mylist/regist/?auto_logins_id=\(auto_logins_id)&user_id=\(user_id)&q_id=" + self.result_json["question"][self.question_num-1]["q_id"].string!
                    let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                    let URL:NSURL = NSURL(string: encodedURL)!
                    let _ :NSData = NSData(contentsOf: URL as URL)!
                }
            }
            
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            // print("Cancel")
        })
        
        // UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // Alertを表示
        present(alert, animated: true, completion: nil)

    }
    
    // マルをタップ
    @IBAction func maruSubmit(_ sender: AnyObject) {
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }
        
        // マルを入力結果をyとして保管
        result_json["trial_ids"][question_num.description]["answered"] = "y"

        self.switchProces()
    }
    
    // バツをタップ
    @IBAction func batsuSubmit(_ sender: AnyObject) {
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }
        
        // バツを入力結果をnとして保管
        result_json["trial_ids"][question_num.description]["answered"] = "n"
        
        self.switchProces()
    }
    
    // マルかバツをタップした後の処理の切り替え
    func switchProces() {
        if examsType == "仮免許" && question_num == 50 {
            // 仮免許 完了画面を表示
            self.resultView()
            
        } else if examsType == "本試験" && question_num >= 90 {
            // 危険予測ページを表示する為、controllerを切り替える
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "kiken") as! KikenyosokuViewController
            nextView.result_json = result_json
            nextView.question_num = question_num
            nextView.examsType = examsType
            self.present(nextView, animated: false, completion: nil)
            
        } else {
            // 問題文・問題番号の値を変更
            self.setViewText();
        }
    }
    
    // 完了画面を表示
    func resultView() {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "Points") as! PointsViewController
        nextView.result_json = result_json
        nextView.examsType = self.examsType
        self.present(nextView, animated: false, completion: nil)
    }
    
    func setViewText() {
        // メンテナンス判定
        moveMaintenance()
        
        // 問題の番号のカウントアップ
        question_num = self.question_num + 1

        // 問題文・番号の値を変更
        questionNumTextField.text = question_num.description
        questionTextField.text = result_json["question"][question_num-1]["sentence"].string

        let imageName = result_json["question"][question_num-1]["sentence_img"].string

        // 問題画像の設定
        if imageName != "" {
            // キャッシュから読み込んで表示
            if let img = UIImage(contentsOfFile: common.path + "/" + imageName!) {
                sentenceImg.isHidden = false
                sentenceImgConstraintHeight.constant = 150
                // 縦横の比率をそのままにする
                sentenceImg.contentMode = UIViewContentMode.scaleAspectFit
                // イメージビューに表示する
                sentenceImg?.image = img
            } else {
                // URLオブジェクトを作る
                let imgUrl = NSURL(string: common.imageUrl + imageName!)
                // ファイルデータを作る
                if let file = NSData(contentsOf: imgUrl! as URL) {
                    sentenceImg.isHidden = false
                    sentenceImgConstraintHeight.constant = 150
                    // イメージデータを作る
                    let img = UIImage(data:file as Data)
                    // 縦横の比率をそのままにする
                    sentenceImg.contentMode = UIViewContentMode.scaleAspectFit
                    // イメージビューに表示する
                    sentenceImg?.image = img
                    // キャッシュ作成
                    let data = try? Data(contentsOf: imgUrl! as URL)
                    FileManager.default.createFile(atPath: common.path + "/" + imageName!, contents: data, attributes: nil)
                } else {
                    sentenceImg.isHidden = true
                    sentenceImgConstraintHeight.constant = 0
                }
            }
        } else {
            sentenceImg.isHidden = true
            sentenceImgConstraintHeight.constant = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // タブボタン押下時の呼び出しメソッド
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        switch item.tag {
        case 1:
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "loginTop") as! ViewController
            self.present(nextView, animated: false, completion: nil)
            break
        case 2:
            // オフラインの場合はreturn
            if common.CheckNetwork() == false {
                return
            }
            
            // 他の問題一覧
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "questionState") as! QuestionViewController
            nextView.result_json = self.result_json
            nextView.question_num = self.question_num // 問題の番号
            nextView.examsType = self.examsType
            self.present(nextView, animated: false, completion: nil)
            break
        default:
            return
        }
    }
}
