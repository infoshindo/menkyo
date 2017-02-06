//
//  QuestionViewCell.swift
//  menkyo
//
//  Created by infosquare on 2016/11/25.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class QuestionViewCell: UITableViewCell {
    let common: Common = Common()

    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var questionNumLabel: UILabel!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var sentenceImg: UIImageView!
    @IBOutlet weak var sentenceImgConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var answeredLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        stateLabel.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // 危険予測問題
    func setCellKiken(state: String, questionNum: Int,sentence: String, imageName: String, answered: String) {
        stateLabel.text = state
        if stateLabel.text == "未回答" {
            stateLabel.backgroundColor = UIColor.red
        } else {
            stateLabel.backgroundColor = UIColor(red: 0.208, green: 0.322, blue: 0.357, alpha: 1.0)
        }
        
        questionNumLabel.text = questionNum.description + "問目"
        sentenceLabel.text = sentence
        
        // URLオブジェクトを作る
        let imgUrl = NSURL(string: common.imageUrl + "illust_img/" + imageName)

        // ファイルデータを作る
        if let file = NSData(contentsOf: imgUrl! as URL) {
            sentenceImg.isHidden = false
            sentenceImgConstraintHeight.constant = 100
            // イメージデータを作る
            let img = UIImage(data:file as Data)
            // 縦横の比率をそのままにする
            sentenceImg.contentMode = UIViewContentMode.scaleAspectFit
            // イメージビューに表示する
            sentenceImg?.image = img
        } else {
            sentenceImg.isHidden = true
            sentenceImgConstraintHeight.constant = 0
        }
        
        // 回答した答えの設定
//        answeredLabel.text = "あなたの答え: " + answered
        answeredLabel.isHidden = true
    }

    
    func setCell(state: String, questionNum: Int, sentence: String, imageName: String, answered: String) {
        stateLabel.text = state
        
        if stateLabel.text == "未回答" {
            stateLabel.backgroundColor = UIColor.red
        } else {
            stateLabel.backgroundColor = UIColor(red: 0.208, green: 0.322, blue: 0.357, alpha: 1.0)
        }
        
        questionNumLabel.text = questionNum.description + "問目"
        sentenceLabel.text = sentence
        
        //
        
        if questionNum > 90 {
            
        }
        // 問題画像の設定
        else if imageName != "" {
            // URLオブジェクトを作る
            let imgUrl = NSURL(string: common.imageUrl + imageName)
            
            // ファイルデータを作る
            if let file = NSData(contentsOf: imgUrl! as URL) {
                sentenceImg.isHidden = false
                sentenceImgConstraintHeight.constant = 100
                // イメージデータを作る
                let img = UIImage(data:file as Data)
                // 縦横の比率をそのままにする
                sentenceImg.contentMode = UIViewContentMode.scaleAspectFit
                // イメージビューに表示する
                sentenceImg?.image = img
            } else {
                sentenceImg.isHidden = true
                sentenceImgConstraintHeight.constant = 0
            }
        } else {
            sentenceImg.isHidden = true
            sentenceImgConstraintHeight.constant = 0
        }
        
        // 回答した答えの設定
        answeredLabel.isHidden = false
        answeredLabel.text = "あなたの答え: " + answered
    }

}
