//
//  InitialViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/10/06.
//  Copyright © 2016年 infosquare. All rights reserved.
//


import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registButton.layer.cornerRadius = 3
        loginButton.layer.cornerRadius = 3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


