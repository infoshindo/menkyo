//
//  PointsViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/11/23.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit
class PointsViewController: UIViewController, UITabBarDelegate {
    var common: Common = Common()
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
print(result_json)
        // 答え合わせ
        if examsType == "危険予測問題" {
            self.checkAnswerKiken()
        } else {
            self.checkAnswer()
        }
    }
    
    // テスト結果を見るをタップ
    @IBAction func tapResult(_ sender: AnyObject) {
        // 結果ページへ遷移
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "Result") as! ResultViewController
        nextView.result_json = self.result_json
        nextView.examsType = self.examsType
        self.present(nextView, animated: false, completion: nil)
    }
    
    @IBAction func tapTwitter(_ sender: AnyObject) {
        let link = "http://twitter.com/share?url=\(common.domainUrl)exams/trial_result/\(result_json["trial_id"])/&text=運転免許学習システム「シカクン」で仮免許の模擬試験を受けました！【\(String(point))点！！】&hashtags=シカクン"
        let encodedURLTwitter: String = link.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url = NSURL(string: encodedURLTwitter)
        
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
        }
        print(url)
    }
    
    // 危険予測問題のミニテスト 答えあわせ
    func checkAnswerKiken() {
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
        
    }
    
    func checkAnswer() {
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

        // 回答内容などをAPIに送り、DBに保存
        let trial_id: String = result_json["trial_id"].int!.description
        let url = NSURL(string: common.apiUrl + "exams/result/?")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let req = NSMutableURLRequest(url: url! as URL)
        let params = "corrects=" + correct_all.description + "&trial_id=" + trial_id + "&trial_ids=" + result_json["trial_ids"].description
        let encodedParams: String = params.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        req.httpMethod = "POST"
        req.httpBody = encodedParams.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: req as URLRequest, completionHandler: {
            (data, resp, err) in
            print(resp?.url!)
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
        })
        task.resume()
        
        // 採点
        let aplit_num: [Int] = []
        if examsType == "仮免許" {
            point = correct.count * 2
        } else {
            point = correct.count + (correct_kiken.count * 2)
        }
        
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
