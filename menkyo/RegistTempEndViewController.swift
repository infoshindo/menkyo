//
//  RegistTempEndViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/10/24.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class RegistTempEndViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickTop(_ sender: AnyObject) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "loginTop") as! ViewController
        self.present(nextView, animated: false, completion: nil)
    }
    
}
