//
//  LoadingProxy.swift
//  menkyo
//
//  Created by infosquare on 2017/01/19.
//  Copyright © 2017年 infosquare. All rights reserved.
//

import UIKit

struct LoadingProxy{
    
    static var myActivityIndicator: UIActivityIndicatorView!
    
    static func set(v:UIViewController){
        self.myActivityIndicator = UIActivityIndicatorView()
//        self.myActivityIndicator.frame = CGRectMake(0, 0, 50, 50)
        self.myActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.myActivityIndicator.center = v.view.center
        self.myActivityIndicator.hidesWhenStopped = false
        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        self.myActivityIndicator.backgroundColor = UIColor.gray;
        self.myActivityIndicator.layer.masksToBounds = true
        self.myActivityIndicator.layer.cornerRadius = 5.0;
        self.myActivityIndicator.layer.opacity = 0.8;
        v.view.addSubview(self.myActivityIndicator);
        
        self.off();
    }
    static func on(){
        myActivityIndicator.startAnimating();
        myActivityIndicator.isHidden = false;
    }
    static func off(){
        myActivityIndicator.stopAnimating();
        myActivityIndicator.isHidden = true;
        
    }
    
}
