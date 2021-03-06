//
//  PointsViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/11/23.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit
import SVProgressHUD

class PointsViewController: UIViewController, UITabBarDelegate, MaioDelegate {
    var common: Common = Common()
    var check_login: Bool = false
    var result_json: JSON = []
    var correct: [String] = []
    var correct_kiken: [String] = []
    var point: Int = 0
    var examsType: String = "" // 仮免許 OR 本試験 OR 危険予測問題
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsDescriptionLabel: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var twitterImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }
        
        // ログインチェック
        check_login = common.CheckLogin()
        
        // Maio動画広告設定
        #if DEBUG
            // 開発環境で再生する際には必ずテストモードにしましょう
            Maio.setAdTestMode(true)
        #endif
        Maio.start(withMediaId: "m23efd9c4ec09ae8646a523081e7ff163", delegate: self)
        
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
        
        // 答え合わせ
        if examsType == "危険予測問題" {
            self.checkAnswerKiken()
        } else {
            self.checkAnswer()
        }
    }
    
    // Maio広告動画再生終了時
    func maioDidFinishAd(_ zoneId: String!, playtime: Int, skipped: Bool, rewardParam: String!){
        // メンテナンス判定
        moveMaintenance()
        
        if check_login {
            let ud = UserDefaults.standard
            print("ud:\(ud.object)")
            let user_id: String = ud.object(forKey: "user_id") as! String
            let auto_logins_id: String = ud.object(forKey: "auto_logins_id") as! String
            
            // 広告動画再生フラグを更新
            if examsType != "危険予測問題" {
                let query: String = self.common.apiUrl + "exams/ad_comp/?auto_logins_id=" + auto_logins_id + "&user_id=" + user_id + "&trial_id=" + String(describing: self.result_json["trial_id"])
                let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                let URL:NSURL = NSURL(string: encodedURL)!
                let _ :NSData = NSData(contentsOf: URL as URL)!
            }
        }
        
        // 結果ページへ遷移
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "Result") as! ResultViewController
        nextView.result_json = self.result_json
        nextView.examsType = self.examsType
        self.present(nextView, animated: false, completion: nil)
        
        // ローディングOFF
        SVProgressHUD.dismiss()
    }
    
    // 答え合わせをするボタン押下時のアラート
    func answerAlert() {
        // メンテナンス判定
        moveMaintenance()
        
        let alert: UIAlertController = UIAlertController(
            title: "答え合わせ",
            message: "動画広告を再生することで解答を見ることができます。再生しますか？",
            preferredStyle:  UIAlertControllerStyle.alert
        )
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            // ローディングON
            SVProgressHUD.show()
            // 動画広告を再生
            Maio.show()
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        // UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    // テスト結果を見るをタップ
    @IBAction func tapResult(_ sender: AnyObject) {
        // メンテナンス判定
        moveMaintenance()
        
        if examsType != "危険予測問題" {
            self.answerAlert()
        } else {
            // 結果ページへ遷移
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "Result") as! ResultViewController
            nextView.result_json = self.result_json
            nextView.examsType = self.examsType
            self.present(nextView, animated: false, completion: nil)
        }
    }
    
//    @IBAction func tapTwitter(_ sender: AnyObject) {
//        let link = "http://twitter.com/share?url=\(common.domainUrl)exams/trial_result/\(result_json["trial_id"])/&text=運転免許学習システム「シカクン」で仮免許の模擬試験を受けました！【\(String(point))点！！】&hashtags=シカクン"
//        let encodedURLTwitter: String = link.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
//        let url = NSURL(string: encodedURLTwitter)
//        
//        if UIApplication.shared.canOpenURL(url! as URL){
//            UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
//        }
//        
//    }
    
    // 危険予測問題のミニテスト 答えあわせ
    func checkAnswerKiken() {
        // メンテナンス判定
        moveMaintenance()
        
        // 答え合わせ 3問合っている場合illust_idを配列に追加
        for (key, a_array) in result_json["a_array"] {
            if a_array["q1_correct"]==1 && a_array["q2_correct"]==1 && a_array["q3_correct"]==1 {
                correct.append(a_array["illust_id"].string!)
                result_json["a_array"][Int(key)!]["result"] = "correct"
            } else {
                result_json["a_array"][Int(key)!]["result"] = "mis"
            }
        }

        // 回答内容などをAPIに送り、DBに保存
        let url = NSURL(string: common.apiUrl + "exams/result_kiken/?")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let req = NSMutableURLRequest(url: url! as URL)
        let params = "corrects=" + correct.description + "&id=" + result_json["id"].description + "&a_array=" + result_json["a_array"].description
        let encodedParams: String = params.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        req.httpMethod = "POST"
        req.httpBody = encodedParams.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: req as URLRequest, completionHandler: {
            (data, resp, err) in
            print(resp?.url!)
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
        })
        task.resume()

        point = correct.count
        
        // メッセージの設定
        if result_json["a_array"].count == 5 {
            if point >= 5 {
                messageLabel.text = "合格圏内です！"
                resultImage.image = UIImage(named:"result_congratulations")
            } else if point >= 4 {
                messageLabel.text = "おしい！ あと少しで合格圏です！"
                resultImage.image = UIImage(named:"result_waytogo")
            } else if point >= 3 {
                messageLabel.text = "頑張りどころです！"
                resultImage.image = UIImage(named:"result_notsobad")
            } else {
                messageLabel.text = "気合を入れて勉強しましょう！"
                resultImage.image = UIImage(named:"result_whatamess")
            }
        } else if result_json["a_array"].count == 10 {
            if point >= 8 {
                messageLabel.text = "合格圏内です！"
                resultImage.image = UIImage(named:"result_congratulations")
            } else if point >= 6 {
                messageLabel.text = "おしい！ あと少しで合格圏です！"
                resultImage.image = UIImage(named:"result_waytogo")
            } else if point >= 3 {
                messageLabel.text = "頑張りどころです！"
                resultImage.image = UIImage(named:"result_notsobad")
            } else {
                messageLabel.text = "気合を入れて勉強しましょう！"
                resultImage.image = UIImage(named:"result_whatamess")
            }
        }
        
        // 画像の縦横の比率をそのままにする
        resultImage.contentMode = UIViewContentMode.scaleAspectFit
        
        // 点数
        pointsLabel.text = String(point) + "点"
        
        // 点数の詳細
        pointsDescriptionLabel.text = String(result_json["a_array"].count) + "問中 " + String(correct.count+correct_kiken.count) + "問正解"
        
        // ローディングOFF
        SVProgressHUD.dismiss()
    }
    
    func checkAnswer() {
        // メンテナンス判定
        moveMaintenance()
        
        // 答え合わせ result_json["question"]へ結果を追加、api用に正解した問題のIDをcorrectに追加
        for (_, trial_ids) in result_json["trial_ids"] {
            for (key, question) in result_json["question"] {

                let int_key = Int(key)
                if question["q_num"] > 90 {
                    // 危険予測問題
                    if question["illust_id"] == trial_ids["q_id"]
                    {
                        result_json["question"][int_key!]["result"] = "mis"
                        if trial_ids["q1_correct"] == 1 && trial_ids["q2_correct"] == 1 && trial_ids["q3_correct"] == 1 {
                            correct_kiken.append(question["q_num"].description)
                            result_json["question"][int_key!]["result"] = "correct"
                        }
                    }
                } else {
                    // 通常問題
                    if question["q_id"] == trial_ids["q_id"] {
                        result_json["question"][int_key!]["result"] = "mis"

                        if trial_ids["answered"] == "y" && question["answer"] == "1" {
                            correct.append(question["q_num"].description)
                            result_json["question"][int_key!]["result"] = "correct"
                        }
                        if trial_ids["answered"] == "n" && question["answer"] == "0" {
                            correct.append(question["q_num"].description)
                            result_json["question"][int_key!]["result"] = "correct"
                        }
                    }
                }
            }

        }
        
        let correct_all:[String] = correct + correct_kiken
        result_json["corrects"] = JSON(correct_all.joined(separator: ","))

        
        // 採点
        if examsType == "仮免許" {
            point = correct.count * 2
        } else {
            point = correct.count + (correct_kiken.count * 2)
        }
        
        // 回答内容などをAPIに送り、DBに保存
        let trial_id: String = result_json["trial_id"].int!.description
        let url = NSURL(string: common.apiUrl + "exams/result/?")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let req = NSMutableURLRequest(url: url! as URL)
        let params = "corrects=" + correct_all.description + "&trial_id=" + trial_id + "&trial_ids=" + result_json["trial_ids"].description + "&point=" + String(point)
        let encodedParams: String = params.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        req.httpMethod = "POST"
        req.httpBody = encodedParams.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: req as URLRequest, completionHandler: {
            (data, resp, err) in
            print(resp?.url!)
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
        })
        task.resume()
        
        // メッセージの設定
        if point >= 90 {
            messageLabel.text = "合格圏内です！"
            resultImage.image = UIImage(named:"result_congratulations")
        } else if point >= 70 {
            messageLabel.text = "おしい！ あと少しで合格圏です！"
            resultImage.image = UIImage(named:"result_waytogo")
        } else if point >= 50 {
            messageLabel.text = "頑張りどころです！"
            resultImage.image = UIImage(named:"result_notsobad")
        } else {
            messageLabel.text = "気合を入れて勉強しましょう！"
            resultImage.image = UIImage(named:"result_whatamess")
        }
        
        // 画像の縦横の比率をそのままにする
        resultImage.contentMode = UIViewContentMode.scaleAspectFit
        
        // 点数
        pointsLabel.text = String(point) + "点"
        
        // 点数の詳細
        pointsDescriptionLabel.text = String(result_json["question"].count) + "問中 " + String(correct.count+correct_kiken.count) + "問正解"
        
        // ローディングOFF
        SVProgressHUD.dismiss()
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
            break
        default:
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
