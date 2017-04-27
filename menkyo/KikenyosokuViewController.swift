//
//  KikenyosokuViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/11/30.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class KikenyosokuViewController: UIViewController, UITabBarDelegate {
    
    let common: Common = Common()
    var result_json: JSON = []
    var question_num: Int = 0 // 問題の番号
    var total: String = "0" // ミニテストの場合の合計問題数
    var examsType: String = "" // 仮免許 OR 本試験 OR 危険予測問題

    @IBOutlet weak var questionNumTextField: UILabel!
    @IBOutlet weak var questionTextField: UILabel!
    @IBOutlet weak var sentenceImg: UIImageView!
    
    @IBOutlet weak var sentenceImgConstraintHeight: NSLayoutConstraint!

    @IBOutlet weak var sentence1: UILabel!
    @IBOutlet weak var segment1: UISegmentedControl!

    @IBOutlet weak var sentence2: UILabel!
    @IBOutlet weak var segment2: UISegmentedControl!

    @IBOutlet weak var sentence3: UILabel!
    @IBOutlet weak var segment3: UISegmentedControl!

    @IBOutlet weak var answerButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var questionWidth: NSLayoutConstraint!
    
    @IBOutlet weak var tabQuestion: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }
        
        // ミニテストの場合は、APIから問題文を取得
        if result_json.isEmpty {
            let ud = UserDefaults.standard
            
            var query: String = ""
            if let user_id: String = ud.object(forKey: "user_id") as? String {
                let auto_logins_id: String = ud.object(forKey: "auto_logins_id") as! String
                query = common.apiUrl + "exams/illust/?user_id=" + user_id + "&auto_logins_id=" + auto_logins_id + "&total=" + total
            } else {
                query = common.apiUrl + "exams/illust/?total=" + total
            }

            let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let URL:NSURL = NSURL(string: encodedURL)!
            let jsonData :NSData = NSData(contentsOf: URL as URL)!
            result_json = JSON(data: jsonData as Data)
        }
        
        if examsType == "危険予測問題" {
            self.setViewTextMinitest()
            tabQuestion.isEnabled = false
        } else {
            self.setViewText()
            tabQuestion.isEnabled = true
        }
        
        // 横幅を画面サイズに合わせる(一つだけでも横幅の制約をつければOKなので問題文に制約をつける)
        let screenWidth = Int( UIScreen.main.bounds.size.width)
        questionWidth.constant = CGFloat(screenWidth-35)
        
    }
    
    @IBAction func tapEnd(_ sender: AnyObject) {
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
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "Points") as! PointsViewController
            nextView.result_json = self.result_json
            nextView.examsType = self.examsType
            self.present(nextView, animated: false, completion: nil)
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
    
    @IBAction func segment1(_ sender: AnyObject) {
        // 正誤を保存
        if examsType == "危険予測問題" {
            var answer: String = "0"
            result_json["a_array"][question_num-1]["q1_user_answer"] = "バツ" // ユーザーの答え
            if sender.selectedSegmentIndex == 0 {
                answer = "1"
                result_json["a_array"][question_num-1]["q1_user_answer"] = "マル"
            }
            
            if answer == result_json["a_array"][question_num-1]["answer1"].string {
                result_json["a_array"][question_num-1]["q1_correct"] = 1
            }
        } else {
            var answer: String = "0"
            result_json["trial_ids"][question_num.description]["q1_user_answer"] = "バツ" // ユーザーの答え
            if sender.selectedSegmentIndex == 0 {
                answer = "1"
                result_json["trial_ids"][question_num.description]["q1_user_answer"] = "マル"
            }
            
            if answer == result_json["question"][question_num-1]["answer1"].string {
                result_json["trial_ids"][question_num.description]["q1_correct"] = 1
            }
        }
    }
    
    @IBAction func segment2(_ sender: AnyObject) {
        // 正誤を保存
        if examsType == "危険予測問題" {
            var answer: String = "0"
            result_json["a_array"][question_num-1]["q2_user_answer"] = "バツ" // ユーザーの答え
            if sender.selectedSegmentIndex == 0 {
                answer = "1"
                result_json["a_array"][question_num-1]["q2_user_answer"] = "マル"
            }
            
            if answer == result_json["a_array"][question_num-1]["answer2"].string {
                result_json["a_array"][question_num-1]["q2_correct"] = 1
            }
        } else {
            var answer: String = "0"
            result_json["trial_ids"][question_num.description]["q2_user_answer"] = "バツ" // ユーザーの答え
            if sender.selectedSegmentIndex == 0 {
                answer = "1"
                result_json["trial_ids"][question_num.description]["q2_user_answer"] = "マル"
            }
            
            if answer == result_json["question"][question_num-1]["answer2"].string {
                result_json["trial_ids"][question_num.description]["q2_correct"] = 1
            }
        }
    }
    
    @IBAction func segment3(_ sender: AnyObject) {
        // 正誤を保存
        if examsType == "危険予測問題" {
            var answer: String = "0"
            result_json["a_array"][question_num-1]["q3_user_answer"] = "バツ" // ユーザーの答え
            if sender.selectedSegmentIndex == 0 {
                answer = "1"
                result_json["a_array"][question_num-1]["q3_user_answer"] = "マル"
            }
            
            if answer == result_json["a_array"][question_num-1]["answer3"].string {
                result_json["a_array"][question_num-1]["q3_correct"] = 1
            }
        } else {
            var answer: String = "0"
            result_json["trial_ids"][question_num.description]["q3_user_answer"] = "バツ" // ユーザーの答え
            if sender.selectedSegmentIndex == 0 {
                answer = "1"
                result_json["trial_ids"][question_num.description]["q3_user_answer"] = "マル"
            }
            
            if answer == result_json["question"][question_num-1]["answer3"].string {
                result_json["trial_ids"][question_num.description]["q3_correct"] = 1
            }
        }
    }
    
    // 解答するボタンタップ
    @IBAction func tapAnswer(_ sender: AnyObject) {
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }

        if question_num == 95 || question_num == Int(total)
        {
            // 結果ページへ遷移
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "Points") as! PointsViewController
            nextView.result_json = result_json
            nextView.examsType = self.examsType
            self.present(nextView, animated: false, completion: nil)
        } else if examsType == "危険予測問題" {
            result_json["trial_ids"][question_num.description]["answered"] = 1
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "kiken") as! KikenyosokuViewController
            nextView.result_json = self.result_json
            nextView.question_num = self.question_num
            nextView.examsType = self.examsType
            nextView.total = self.total
            self.present(nextView, animated: false, completion: nil)
        } else {
            // 通常問題
            result_json["trial_ids"][question_num.description]["answered"] = 1
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "kiken") as! KikenyosokuViewController
            nextView.result_json = self.result_json
            nextView.question_num = self.question_num
            nextView.examsType = self.examsType
            self.present(nextView, animated: false, completion: nil)
        }
    }
    
    // ミニテストモード 5問OR10問
    func setViewTextMinitest() {
        // 問題の番号のカウントアップ
        question_num = self.question_num + 1

        // 問題文・番号の値を変更
        questionNumTextField.text = question_num.description + " / " + total
        questionTextField.text = result_json["q_array"][question_num-1]["illust_expression"].string
        
        sentence1.text = "1. " + result_json["q_array"][question_num-1]["sentence1"].string!
        sentence2.text = "2. " + result_json["q_array"][question_num-1]["sentence2"].string!
        sentence3.text = "3. " + result_json["q_array"][question_num-1]["sentence3"].string!
        
        let imageName = result_json["q_array"][question_num-1]["image_name"].string
        
        // 問題画像の設定
        if imageName != "" {
            // URLオブジェクトを作る
            let imgUrl = NSURL(string: common.imageUrl + "illust_img/" + imageName!)
            
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
            } else {
                sentenceImg.isHidden = true
                sentenceImgConstraintHeight.constant = 0
            }
        } else {
            sentenceImg.isHidden = true
            sentenceImgConstraintHeight.constant = 0
        }
        
        // マルバツのセグメントバーを初期化
        segment1.selectedSegmentIndex = -1
        segment2.selectedSegmentIndex = -1
        segment3.selectedSegmentIndex = -1

    }
    
    func setViewText() {
        // 問題の番号のカウントアップ
        question_num = self.question_num + 1
        
        // 問題文・番号の値を変更
        questionNumTextField.text = question_num.description
        questionTextField.text = result_json["question"][question_num-1]["illust_expression"].string
        
        sentence1.text = "1. " + result_json["question"][question_num-1]["sentence1"].string!
        sentence2.text = "2. " + result_json["question"][question_num-1]["sentence2"].string!
        sentence3.text = "3. " + result_json["question"][question_num-1]["sentence3"].string!

        let imageName = result_json["question"][question_num-1]["image_name"].string

        // 問題画像の設定
        if imageName != "" {
            // URLオブジェクトを作る
            let imgUrl = NSURL(string: common.imageUrl + "illust_img/" + imageName!)
            
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
            } else {
                sentenceImg.isHidden = true
                sentenceImgConstraintHeight.constant = 0
            }
        } else {
            sentenceImg.isHidden = true
            sentenceImgConstraintHeight.constant = 0
        }
        
        // マルバツのセグメントバーを初期化
        segment1.selectedSegmentIndex = -1
        segment2.selectedSegmentIndex = -1
        segment3.selectedSegmentIndex = -1
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
