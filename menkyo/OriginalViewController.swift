//
//  OriginalViewController.swift
//  menkyo
//
//  Created by infosquare on 2017/02/07.
//  Copyright © 2017年 infosquare. All rights reserved.
//

import UIKit

class OriginalViewController: UIViewController {
    
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
