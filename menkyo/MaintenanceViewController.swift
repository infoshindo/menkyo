//
//  MaintenanceViewController.swift
//  menkyo
//
//  Created by kaifu on 2017/07/28.
//  Copyright © 2017年 infosquare. All rights reserved.
//

import UIKit

class MaintenanceViewController: UIViewController {
    let common: Common = Common()
    var maintenance_time: String = ""
    
    @IBOutlet weak var maintenanceTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        maintenanceTime.text = maintenance_time
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


