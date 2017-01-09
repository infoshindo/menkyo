//
//  HistoryViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/12/28.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate{
    var common: Common = Common()
    var result_json: JSON = []
    var examsType: String = "過去の成績"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // マイリストへ登録された問題を取得
        let ud = UserDefaults.standard
        let user_id: String = ud.object(forKey: "user_id") as! String
        let auto_logins_id: String = ud.object(forKey: "auto_logins_id") as! String
        
        let query: String = common.apiUrl + "exams/history_index/?auto_logins_id=" + auto_logins_id + "&user_id=" + user_id
        let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let URL:NSURL = NSURL(string: encodedURL)!
        let jsonData :NSData = NSData(contentsOf: URL as URL)!
        result_json = JSON(data: jsonData as Data)

print(result_json)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result_json.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath)
        
        // セルに表示する値を設定する
        var examType: String = ""
        if result_json[indexPath.row]["trial_type"].string == "1" {
            examType = "仮免"
        } else {
            examType = "本試験"
        }
        cell.textLabel!.text = result_json[indexPath.row]["created_at"].string! + " " + examType + "問題"

        return cell
    }
    
    // セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セル番号：\(indexPath.row) セルの内容：(fruits[indexPath.row])")
        
        let id: String = result_json[indexPath.row]["id"].string!
        
        let ud = UserDefaults.standard
        let user_id: String = ud.object(forKey: "user_id") as! String
        let auto_logins_id: String = ud.object(forKey: "auto_logins_id") as! String
        
        let query: String = common.apiUrl + "exams/history/?auto_logins_id=" + auto_logins_id + "&user_id=" + user_id + "&id=" + id
        let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let URL:NSURL = NSURL(string: encodedURL)!
        let jsonData :NSData = NSData(contentsOf: URL as URL)!
        result_json = JSON(data: jsonData as Data)

        // 結果ページへ遷移
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "Result") as! ResultViewController
        nextView.result_json = self.result_json
        nextView.examsType = self.examsType
        self.present(nextView, animated: false, completion: nil)
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

}
