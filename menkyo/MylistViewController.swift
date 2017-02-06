//
//  MylistViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/12/27.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class MylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    var common: Common = Common()
    var result_json: JSON = []

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }

        // セルの高さを可変にする
        self.table.estimatedRowHeight = 280
        self.table.rowHeight = UITableViewAutomaticDimension
        
        // マイリストへ登録された問題を取得
        let ud = UserDefaults.standard
        let user_id: String = ud.object(forKey: "user_id") as! String
        let auto_logins_id: String = ud.object(forKey: "auto_logins_id") as! String
        
        let query: String = common.apiUrl + "mylist/get/?auto_logins_id=" + auto_logins_id + "&user_id=" + user_id
        let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let URL:NSURL = NSURL(string: encodedURL)!
        let jsonData :NSData = NSData(contentsOf: URL as URL)!
        result_json = JSON(data: jsonData as Data)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // マイリストの削除
    @IBAction func tapMylistDelete(_ sender: Any) {
        // タイトル, メッセージ, Alertのスタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "マイリストの削除", message: "削除しますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // OKボタン押下）
            (action: UIAlertAction!) -> Void in
            
            // cellの番号を取得
            let cell = (sender as AnyObject).superview??.superview as! MylistTableViewCell
            guard let row = self.table.indexPath(for: cell)?.row else {
                return
            }

            // apiに削除する問題を送る
            let ud = UserDefaults.standard
            if let auto_logins_id: String = ud.object(forKey: "auto_logins_id") as? String {
                if let user_id: String = ud.object(forKey: "user_id") as? String {
                    let query: String = self.common.apiUrl + "mylist/delete/?auto_logins_id=" + auto_logins_id + "&user_id=" + user_id + "&q_id=" + String(describing: self.result_json[row]["q_id"])
                    let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                    let URL:NSURL = NSURL(string: encodedURL)!
                    let _ :NSData = NSData(contentsOf: URL as URL)!
                }
            }
            
            // 再読み込み
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "mylist") as! MylistViewController
            self.present(nextView, animated: false, completion: nil)
            
//            let lastPath:NSIndexPath = NSIndexPath(row: 0, section: 0)
//            self.table.scrollToRow(at: lastPath as IndexPath, at: UITableViewScrollPosition.none, animated: true)
            
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
    
    // セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return result_json.count
    }
    
    // セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "mylist") as! MylistTableViewCell

        var answer: String = ""
        if result_json[indexPath.row]["answer"].string == "1" {
            answer = "正解は: 〇"
        } else {
            answer = "正解は: ×"
        }
        
        cell.setCell(
            sentence: result_json[indexPath.row]["sentence"].string!,
            answer: answer,
            explanation: result_json[indexPath.row]["explanation"].string!,
            imageName: result_json[indexPath.row]["sentence_img"].string!
        )
        
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

}
