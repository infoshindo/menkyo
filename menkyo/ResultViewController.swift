//
//  ResultViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/11/16.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    var common: Common = Common()
    var result_json: JSON = []
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
print(result_json)
        // セルの高さを可変にする
        self.table.estimatedRowHeight = 280
        self.table.rowHeight = UITableViewAutomaticDimension
        
        // 空行のセパレータを消す
        self.table.tableFooterView = UIView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // マイリストへの登録をタップ
    @IBAction func tapMylist(_ sender: AnyObject) {
        // タイトル, メッセージ, Alertのスタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "マイリストへの登録", message: "登録しますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // OKボタン押下）
            (action: UIAlertAction!) -> Void in
            
            // cellの番号を取得
            let cell = sender.superview??.superview as! ResultTableViewCell
            guard let row = self.table.indexPath(for: cell)?.row else {
                return
            }
            
            let ud = UserDefaults.standard
            if let auto_logins_id: String = ud.object(forKey: "auto_logins_id") as? String {
                if let user_id: String = ud.object(forKey: "user_id") as? String {
                    let query: String = self.common.apiUrl + "mylist/regist/?auto_logins_id=" + auto_logins_id + "&user_id=" + user_id + "&q_id=" + String(describing: self.result_json["question"][row]["q_id"])
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

    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result_json["question"].count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 結果
        var result: String = "Miss"
        if result_json["question"][indexPath.row]["result"] == "correct" {
            result = "Good!!"
        }
        
        // セルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as! ResultTableViewCell
        
        // セルに値を設定
        if indexPath.row >= 90 {
            // 危険予測問題
            
            // 回答した答え
            var answered1: String = "あなたの答え:"
            let trial_ids_key = indexPath.row + 1

            if result_json["trial_ids"][trial_ids_key.description]["q1_user_answer"].string == "マル" {
                answered1 = "あなたの答え:〇"
            } else if result_json["trial_ids"][trial_ids_key.description]["q1_user_answer"].string == "バツ" {
                answered1 = "あなたの答え:×"
            }
            
            var answered2: String = "あなたの答え:"
            if result_json["trial_ids"][trial_ids_key.description]["q2_user_answer"].string == "マル" {
                answered2 = "あなたの答え:〇"
            } else if result_json["trial_ids"][trial_ids_key.description]["q2_user_answer"].string == "バツ" {
                answered2 = "あなたの答え:×"
            }
            
            var answered3: String = "あなたの答え:"
            if result_json["trial_ids"][trial_ids_key.description]["q3_user_answer"].string == "マル" {
                answered3 = "あなたの答え:〇"
            } else if result_json["trial_ids"][trial_ids_key.description]["q3_user_answer"].string == "バツ" {
                answered3 = "あなたの答え:×"
            }
            
            // 正しい答え
            var correctAnswerd1: String = ""
            if result_json["question"][indexPath.row]["answer1"].string == "1" {
                correctAnswerd1 = "正しい答え:〇"
            } else {
                correctAnswerd1 = "正しい答え:×"
            }
            
            var correctAnswerd2: String = ""
            if result_json["question"][indexPath.row]["answer2"].string == "1" {
                correctAnswerd2 = "正しい答え:〇"
            } else {
                correctAnswerd2 = "正しい答え:×"
            }
            
            var correctAnswerd3: String = ""
            if result_json["question"][indexPath.row]["answer3"].string == "1" {
                correctAnswerd3 = "正しい答え:〇"
            } else {
                correctAnswerd3 = "正しい答え:×"
            }
            
            
            cell.setCellKiken(
                result: result,
                qNum: String(describing: result_json["question"][indexPath.row]["q_num"]) + "問",
                sentence: result_json["question"][indexPath.row]["illust_expression"].string!,
                sentence1: result_json["question"][indexPath.row]["sentence1"].string!,
                sentence2: result_json["question"][indexPath.row]["sentence2"].string!,
                sentence3: result_json["question"][indexPath.row]["sentence3"].string!,
                imageName: result_json["question"][indexPath.row]["image_name"].string!,
                answered1: answered1,
                answered2: answered2,
                answered3: answered3,
                correctAnswerd1: correctAnswerd1,
                correctAnswerd2: correctAnswerd2,
                correctAnswerd3: correctAnswerd3,
                explanation1: result_json["question"][indexPath.row]["explanation1"].string!,
                explanation2: result_json["question"][indexPath.row]["explanation2"].string!,
                explanation3: result_json["question"][indexPath.row]["explanation3"].string!
            
            
            )
        } else {
            // 通常問題
            // 回答した答え
            var answered: String = "あなたの答え:"
            let trial_ids_key = indexPath.row + 1
            if result_json["trial_ids"][trial_ids_key.description]["answered"].string == "y" {
                answered = "あなたの答え:〇"
            } else if result_json["trial_ids"][trial_ids_key.description]["answered"].string == "n" {
                answered = "あなたの答え:×"
            }
            
            // 正しい答え
            var correctAnswerd: String = ""
            if result_json["question"][indexPath.row]["answer"].string == "1" {
                correctAnswerd = "正しい答え:〇"
            } else {
                correctAnswerd = "正しい答え:×"
            }
            
            cell.setCell(
                result: result,
                qNum: String(describing: result_json["question"][indexPath.row]["q_num"]) + "問",
                sentence: result_json["question"][indexPath.row]["sentence"].string!,
                imageName: result_json["question"][indexPath.row]["sentence_img"].string!,
                answered: answered,
                correctAnswerd: correctAnswerd,
                explanation: result_json["question"][indexPath.row]["explanation"].string!
            )
        }

        return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
}
