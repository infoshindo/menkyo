//
//  KarimenResultViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/11/07.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class KarimenResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    
    let common: Common = Common()
    var result_json: JSON = []
    var cellHeight: [Int] = []
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        table.estimatedRowHeight = 500 //見積もり高さ
        table.rowHeight = UITableViewAutomaticDimension //自動設定

        // 答え合わせ 正解した問題のIDをcorrectに追加
        var correct: [String] = []
        for (_, trial_ids) in result_json["trial_ids"] {
            for (_, question) in result_json["question"] {
                if question["q_id"] == trial_ids["q_id"] {
                    if trial_ids["answered"] == "y" && question["answer"] == "1" {
                        correct.append(question["q_id"].string!)
                    }
                    if trial_ids["answered"] == "n" && question["answer"] == "0" {
                        correct.append(question["q_id"].string!)
                    }
                }
            }
        }
        
        // 回答内容などをAPIに送る
        let trial_id: String = result_json["trial_id"].int!.description
        let query: String = common.apiUrl + "exams/result/?" + "corrects=" + correct.description + "&trial_id=" + trial_id + "&trial_ids=" + result_json["trial_ids"].description
        let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let URL:NSURL = NSURL(string: encodedURL)!
        let jsonData :NSData = NSData(contentsOf: URL as URL)!
        let _ = JSON(data: jsonData as Data)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    
    // section毎の画像配列
    let imgArray: NSArray = ["img0","img1","img2","img3", "img4","img5","img6","img7"]
    
    let label2Array: NSArray = ["2013/8/23/16:04","2013/8/23/16:15","2013/8/23/16:47","2013/8/23/17:10",
                                "2013/8/23/1715:","2013/8/23/17:21","2013/8/23/17:33","2013/8/23/17:41"]
    
    let test = ["あああああああああああああああああああああああああああああああああああああああああ", "いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい", "うううううううううううううう", "あああああああああああああああああああああああああああああああああああああああああ", "いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい", "うううううううううううううう", "あああああああああああああああああああああああああああああああああああああああああ", "いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい"]
    
    // Table Viewのセルの数を指定
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    // 各セルの要素を設定する
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // tableCell の ID で UITableViewCell のインスタンスを生成
        let cell = table.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        // 解答と問題番号のuiview
        let viewHead = table.viewWithTag(4)
        viewHead?.layer.borderWidth = 1
        viewHead?.layer.borderColor = UIColor.red.cgColor
        
        // 問題文の高さ
//        let questionLabel: UILabel = table.viewWithTag(3) as! UILabel
//        questionLabel.text = test[indexPath.row]
//        questionLabel.layoutIfNeeded()
//        self.view.layoutIfNeeded()
//        
//        let questionLabelFlame = questionLabel.frame
//        questionLabel.sizeToFit()

        // 問題文のuiview
        let viewQuestion = table.viewWithTag(5)
        viewQuestion?.layer.borderWidth = 1
        viewQuestion?.layer.borderColor = UIColor.red.cgColor
        viewQuestion?.translatesAutoresizingMaskIntoConstraints = true
        
        // 問題文のuiviewの高さを文章に高さに動的にあわせる
//        viewQuestion?.frame.size.height = questionLabelFlame.size.height + 12
        
        // 解答のuiview
        let viewAnswer = table.viewWithTag(6)
        viewAnswer?.layer.borderWidth = 1
        viewAnswer?.layer.borderColor = UIColor.red.cgColor
//        viewAnswer?.frame.origin.y = questionLabelFlame.origin.y + questionLabelFlame.size.height + 38

        // 解答文の高さ
//        let answerLabel = table.viewWithTag(7) as! UILabel
//        answerLabel.text = test[indexPath.row]
//        answerLabel.layoutIfNeeded()
//        self.view.layoutIfNeeded()
//        answerLabel.sizeToFit()
//        let answerLabelFlame = answerLabel.frame
        
        // 解答文のuiview
        let viewAnswerSentence = table.viewWithTag(8)
        viewAnswerSentence?.layer.borderWidth = 1
        viewAnswerSentence?.layer.borderColor = UIColor.red.cgColor
        viewAnswerSentence?.translatesAutoresizingMaskIntoConstraints = true
//        viewAnswerSentence?.frame.origin.y = answerLabelFlame.origin.y + answerLabelFlame.size.height + 68

        // 解答文のuiviewの高さを文章に高さに動的にあわせる
//        viewAnswerSentence?.frame.size.height = answerLabelFlame.size.height + 20

        // マイリストボタンの位置を動的に変更
        let viewMylist = table.viewWithTag(9)
        viewMylist?.layer.borderWidth = 1
        viewMylist?.layer.borderColor = UIColor.red.cgColor
        viewMylist?.translatesAutoresizingMaskIntoConstraints = true
        viewMylist?.frame.origin.y = (viewAnswerSentence?.frame.origin.y)! + (viewAnswerSentence?.frame.size.height)! - 1


//        cellHeight.append(Int(viewMylist!.frame.origin.y))

        return cell
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

//        if let you: Int = cellHeight[indexPath.row] {
//            return CGFloat(you)
//        } else {
//            return 0
//        }
        
//        let cell = table.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
//print(cell.frame.size.height)
//        if cellHeight.isEmpty {
//            
//            return 100
//        } else {
//            var key: Int = indexPath.row - 1
//            return CGFloat(cellHeight[key])
//        }
//    }
    
    // ボタン押下時の呼び出しメソッド
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
    
    
    // tableのヘッダーの変更
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel(frame: CGRect(x:0, y:0, width: tableView.bounds.width, height: 50))
//        
//        // 文字位置
//        label.textAlignment = NSTextAlignment.center
//        
//        // 文字サイズ
//        label.font = UIFont.italicSystemFont(ofSize: 21)
//        
//        // 背景色
//        label.backgroundColor = UIColor.red
//        
//        // 文字色
//        label.textColor =  UIColor.white
//        
//        // 表示される文字
//        label.text = "お疲れ様でした。\n試験は全て完了しました。"
//        
//        label.sizeToFit()
//        
//        return label
//    }

}
