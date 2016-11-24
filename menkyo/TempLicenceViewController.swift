//
//  TempLicenceViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/11/02.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class TempLicenceViewController: UIViewController {

    let common: Common = Common()
    @IBOutlet weak var answerUiView: UIView!
    @IBOutlet weak var questionTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 問題文のサイズに合わせてobujectのサイズを変える
        questionTextField.sizeToFit()

        // 問題文以下のy値を合わせる
        let questionFrame = questionTextField.frame
        answerUiView.frame.origin.y = questionFrame.origin.y + questionFrame.size.height

        // 問題文をapiから取得
        let ud = UserDefaults.standard
        let user_email: String = ud.object(forKey: "user_email") as! String
        let query: String = common.apiUrl + "exams/karimen/" + user_email
        let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let URL:NSURL = NSURL(string: encodedURL)!
        let jsonData :NSData = NSData(contentsOf: URL as URL)!
        
        do
        {
            let json = try JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as! [String:String]
print(json["question"])
        }
        catch
        {
            // エラー処理
            print("通信エラー")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
