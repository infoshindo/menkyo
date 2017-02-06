//
//  Common.swift
//  menkyo
//
//  Created by infosquare on 2016/10/27.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class Common: UIViewController{
    var apiUrl: String = "http://kir378005.kir.jp/shikakun_api/public/"
//    var apiUrl: String = "http://shindo.shikakun_api.net/"
    var domainUrl: String = "http://www.shikakun.net/"
    var imageUrl: String = "http://www.shikakun.net/img/"
    var examsType: String = "" // 仮免許 OR 本試験
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func CheckNetwork() -> Bool {
        var result: Bool = false
        if CheckReachability(host_name: "google.com") {
            result = true
//            print("インターネットへの接続が確認されました")
        } else {
            result = false
//            print("インターネットに接続してください")
            
        }
        
        return result
    }
}
