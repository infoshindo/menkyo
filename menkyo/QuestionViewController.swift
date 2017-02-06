//
//  QuestionViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/11/25.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    var common: Common = Common()
    var result_json: JSON = []
    var question_num: Int = 0 // 問題の番号
    var examsType = ""
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // セルの高さを可変にする
        self.table.estimatedRowHeight = 50
        self.table.rowHeight = UITableViewAutomaticDimension
        
        // 空行のセパレータを消す
        self.table.tableFooterView = UIView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var question_count: Int = 0
        if examsType == "危険予測問題" {
            question_count = result_json["a_array"].count
        } else {
            question_count = result_json["question"].count
        }
        return question_count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 回答済か否かの判定
        var state = "回答済"
        let trial_ids_key = indexPath.row + 1
        if result_json["trial_ids"][trial_ids_key.description]["answered"] == false {
            state = "未回答"
        }
        
        // 回答した答え
        var answered: String = ""
        if result_json["trial_ids"][trial_ids_key.description]["answered"].string == "y" {
            answered = "〇"
        } else if result_json["trial_ids"][trial_ids_key.description]["answered"].string == "n" {
            answered = "×"
        }
        
        // セルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "question") as! QuestionViewCell

        // セルに値を設定
        if indexPath.row >= 90 {
            // 通常問題の危険予測
            cell.setCellKiken(
                state: state,
                questionNum: trial_ids_key,
                sentence: result_json["question"][indexPath.row]["illust_expression"].string!,
                imageName: result_json["question"][indexPath.row]["image_name"].string!,
                answered: answered
            )
        } else if examsType == "危険予測問題" {
            // 危険予測問題のミニテスト
            cell.setCellKiken(
                state: state,
                questionNum: trial_ids_key,
                sentence: result_json["q_array"][indexPath.row]["illust_expression"].string!,
                imageName: result_json["q_array"][indexPath.row]["image_name"].string!,
                answered: answered
            )
        } else {
            // 通常問題
            cell.setCell(
                state: state,
                questionNum: trial_ids_key,
                sentence: result_json["question"][indexPath.row]["sentence"].string!,
                imageName: result_json["question"][indexPath.row]["sentence_img"].string!,
                answered: answered
            )
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if 90 <= indexPath.row {
            // 危険予測問題
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "kiken") as! KikenyosokuViewController
            nextView.result_json = self.result_json
            nextView.question_num = indexPath.row
            nextView.examsType = self.examsType
            self.present(nextView, animated: false, completion: nil)
        } else {
            // 通常問題
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "karimen") as! KarimenViewController
            nextView.result_json = self.result_json
            nextView.question_num = indexPath.row
            nextView.examsType = self.examsType
            self.present(nextView, animated: false, completion: nil)
        }
    }
    
    // 戻るボタンのタップ
    @IBAction func tapBack(_ sender: AnyObject) {
        if (examsType == "本試験" && question_num >= 90) || examsType == "危険予測問題" {
            // 危険予測問題画面へ遷移
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "kiken") as! KikenyosokuViewController
            nextView.result_json = result_json
            nextView.question_num = question_num-1
            nextView.examsType = examsType
            self.present(nextView, animated: false, completion: nil)

        } else {
            // 通常問題ページへ遷移
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "karimen") as! KarimenViewController
            nextView.result_json = self.result_json
            nextView.question_num = self.question_num-1
            nextView.examsType = self.examsType
            self.present(nextView, animated: false, completion: nil)
        }

    }
}
