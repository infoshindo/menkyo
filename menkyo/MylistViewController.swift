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

        // セルの高さを可変にする
        self.table.estimatedRowHeight = 280
        self.table.rowHeight = UITableViewAutomaticDimension
        
        // マイリストへ登録された問題を取得
        let ud = UserDefaults.standard
        let user_id: String = ud.object(forKey: "user_id") as! String
        let auto_logins_id: String = ud.object(forKey: "auto_logins_id") as! String
        
        var query: String = common.apiUrl + "mylist/get/?auto_logins_id=" + auto_logins_id + "&user_id=" + user_id
        let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let URL:NSURL = NSURL(string: encodedURL)!
        let jsonData :NSData = NSData(contentsOf: URL as URL)!
        result_json = JSON(data: jsonData as Data)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
print("タブ")
print(item)
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
