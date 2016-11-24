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
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsDescriptionLabel: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var twitterImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 答え合わせ result_json["question"]へ結果を追加、api用に正解した問題のIDをcorrectに追加
        for (_, trial_ids) in result_json["trial_ids"] {
            for (key, question) in result_json["question"] {
                if question["q_id"] == trial_ids["q_id"] {
                    let int_key = Int(key)
                    result_json["question"][int_key!]["result"] = "mis"
                    
                    if trial_ids["answered"] == "y" && question["answer"] == "1" {
                        correct.append(question["q_id"].string!)
                        result_json["question"][int_key!]["result"] = "correct"
                    }
                    if trial_ids["answered"] == "n" && question["answer"] == "0" {
                        correct.append(question["q_id"].string!)
                        result_json["question"][int_key!]["result"] = "correct"
                    }
                    
                }
            }
        }
        
        // 回答内容などをAPIに送り、DBに保存
        let trial_id: String = result_json["trial_id"].int!.description
        let query: String = common.apiUrl + "exams/result/?" + "corrects=" + correct.description + "&trial_id=" + trial_id + "&trial_ids=" + result_json["trial_ids"].description
        let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let URL:NSURL = NSURL(string: encodedURL)!
        let jsonData :NSData = NSData(contentsOf: URL as URL)!
        let _ = JSON(data: jsonData as Data)
        
        // メッセージの設定
        if correct.count >= 90 {
            messageLabel.text = "合格圏内です！"
            resultImage.image = UIImage(named:"result_whatamess")
        } else if correct.count >= 70 {
            messageLabel.text = "おしい！ あと少しで合格圏です！"
            resultImage.image = UIImage(named:"result_whatamess")
        } else if correct.count >= 50 {
            messageLabel.text = "頑張りどころです！"
            resultImage.image = UIImage(named:"result_whatamess")
        } else {
            messageLabel.text = "気合を入れて勉強しましょう！"
            resultImage.image = UIImage(named:"result_whatamess")
        }
        
        // 画像の縦横の比率をそのままにする
        resultImage.contentMode = UIViewContentMode.scaleAspectFit
        
        // 点数
        pointsLabel.text = String(correct.count * 2) + "点"
        
        // 点数の詳細
        if result_json["question"].count == 50 {
            // 仮免
            pointsDescriptionLabel.text = String(result_json["question"].count) + "問中 " + String(correct.count) + "問正解"
        } else {
            // 本免
            pointsDescriptionLabel.text = String(result_json["question"].count) + "問中 " + String(correct.count) + "問正解"
        }
        

    }
    
    // テスト結果を見るをタップ
    @IBAction func tapResult(_ sender: AnyObject) {
        // 結果ページへ遷移
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "Result") as! ResultViewController
        nextView.result_json = result_json
        self.present(nextView, animated: false, completion: nil)
    }
    
    @IBAction func tapTwitter(_ sender: AnyObject) {
        let link = "http://twitter.com/share?url=\(common.domainUrl)exams/trial_result/\(result_json["trial_id"])/&text=運転免許学習システム「シカクン」で仮免許の模擬試験を受けました！【\(String(correct.count * 2))点！！】&hashtags=シカクン"
        let encodedURLTwitter: String = link.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url = NSURL(string: encodedURLTwitter)
        
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
        }
        print(url)
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
