//
//  ViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/09/25.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let common: Common = Common()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func tapHistory(_ sender: AnyObject) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "history") as! HistoryViewController
        self.present(nextView, animated: false, completion: nil)
    }
    @IBAction func tapMylist(_ sender: AnyObject) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "mylist") as! MylistViewController
        self.present(nextView, animated: false, completion: nil)
    }
    
    @IBAction func tapKiken5(_ sender: AnyObject) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "kiken") as! KikenyosokuViewController
        nextView.examsType = "危険予測問題"
        nextView.total = "5" // ミニテストの場合の合計問題数
        self.present(nextView, animated: false, completion: nil)
    }
    
    @IBAction func tapKiken10(_ sender: AnyObject) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "kiken") as! KikenyosokuViewController
        nextView.examsType = "危険予測問題"
        nextView.total = "10" // ミニテストの場合の合計問題数
        self.present(nextView, animated: false, completion: nil)
    }
    
    @IBAction func tapHonmen(_ sender: AnyObject) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "karimen") as! KarimenViewController
        nextView.examsType = "本試験"
        self.present(nextView, animated: false, completion: nil)
    }
    @IBAction func tapKarimen(_ sender: AnyObject) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "karimen") as! KarimenViewController
        nextView.examsType = "仮免許"
        self.present(nextView, animated: false, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        
//        let initialView = InitialViewController();
//        self.present(initialView, animated: false, completion: nil)
        
//        let storyboard: UIStoryboard = self.storyboard!
//        let nextView = storyboard.instantiateViewController(withIdentifier: "initial") as! InitialViewController
//        self.present(nextView, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

