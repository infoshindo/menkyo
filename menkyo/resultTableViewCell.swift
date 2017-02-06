//
//  ResultTableViewCell.swift
//  menkyo
//
//  Created by infosquare on 2016/11/16.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    let common: Common = Common()

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var qNumLabel: UILabel!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var sentenceImg: UIImageView!
    @IBOutlet weak var answeredLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var mylistButton: UIButton!

    @IBOutlet weak var sentenceImgConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet var sentence1Label: UILabel!
    @IBOutlet var answered1Label: UILabel!
    @IBOutlet var correctAnswer1Label: UILabel!
    @IBOutlet var explanation1Label: UILabel!
    
    @IBOutlet weak var sentence2Label: UILabel!
    @IBOutlet weak var answered2Label: UILabel!
    @IBOutlet weak var correctAnswer2Label: UILabel!
    @IBOutlet weak var explanation2Label: UILabel!

    @IBOutlet weak var sentence3Label: UILabel!
    @IBOutlet weak var answered3Label: UILabel!
    @IBOutlet weak var correctAnswer3Label: UILabel!
    @IBOutlet weak var explanation3Label: UILabel!
    
    
    @IBOutlet weak var tujyoView: UIView!
    @IBOutlet weak var kikenView: UIView!
    @IBOutlet weak var tujyoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var kikenViewHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 危険予測問題のセット
    func setCellKiken(result: String, qNum: String, sentence: String, sentence1: String, sentence2: String, sentence3: String, imageName: String, answered1: String, answered2: String, answered3: String, correctAnswerd1: String, correctAnswerd2: String, correctAnswerd3: String, explanation1: String, explanation2: String, explanation3: String) {
        
        // 通常問題のviewを非表示
        tujyoView.isHidden = true
        kikenView.isHidden = false
        kikenViewHeight.constant = 2000
        
        // 正誤の結果(Good OR Miss)
        resultLabel.text = result
        resultLabel.layer.cornerRadius = 10
        resultLabel.clipsToBounds = true
        if result == "Miss" {
            resultLabel.backgroundColor = UIColor(red: 0.886, green: 0.216, blue: 0.392, alpha: 1.0)
        } else {
            resultLabel.backgroundColor = UIColor(red:0.3059,green:0.7216,blue:0.7686,alpha:1.0)
        }
        
        // 問題番号
        qNumLabel.text = qNum
        
        // 問題文
        sentenceLabel.text = sentence
        sentence1Label.text = "1. " + sentence1
        sentence2Label.text = "2. " + sentence2
        sentence3Label.text = "3. " + sentence3
        sentence1Label.sizeToFit()
        sentence2Label.sizeToFit()
        sentence3Label.sizeToFit()
        
        // 問題画像の設定
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
        
        // あなたの答え 正しい答え
        answered1Label.text = answered1
        correctAnswer1Label.text = correctAnswerd1
        
        answered2Label.text = answered2
        correctAnswer2Label.text = correctAnswerd2
        
        answered3Label.text = answered3
        correctAnswer3Label.text = correctAnswerd3
        
        // 解説
        explanation1Label.text = explanation1
        explanation2Label.text = explanation2
        explanation3Label.text = explanation3
        explanation1Label.sizeToFit()
        explanation2Label.sizeToFit()
        explanation3Label.sizeToFit()
        
        // viewのサイズを可変になるように変更
        tujyoViewHeight.constant = 0
        kikenViewHeight.constant = sentence1Label.frame.height + sentence2Label.frame.height + sentence3Label.frame.height + explanation1Label.frame.height + explanation2Label.frame.height + explanation3Label.frame.height + 200
        
        // マイリストボタン非表示
        mylistButton.isHidden = true
    }
    
    
    // 通常問題のセット
    func setCell(result: String, qNum: String, sentence: String, imageName: String, answered: String, correctAnswerd: String, explanation: String) {
        
        // 危険予測用のviewを非表示
        tujyoView.isHidden = false
        kikenView.isHidden = true
        
        // 正誤の結果(Good OR Miss)
        resultLabel.text = result
        resultLabel.layer.cornerRadius = 10
        resultLabel.clipsToBounds = true
        if result == "Miss" {
            resultLabel.backgroundColor = UIColor(red: 0.886, green: 0.216, blue: 0.392, alpha: 1.0)
        } else {
            resultLabel.backgroundColor = UIColor(red:0.3059,green:0.7216,blue:0.7686,alpha:1.0)
        }

        
        // 問題番号
        qNumLabel.text = qNum
        
        // 問題文
        sentenceLabel.text = sentence
        
        // 問題画像の設定
        if imageName != "" {
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

        // あなたの答え 正しい答え
        correctAnswerLabel.text = correctAnswerd
        answeredLabel.text = answered
        
        // 解説
        explanationLabel.text = explanation
        explanationLabel.sizeToFit()
        
        // viewのサイズを可変になるように変更
        tujyoViewHeight.constant = explanationLabel.frame.height + 70
        kikenViewHeight.constant = 0
        
        // マイリストボタン非表示
        mylistButton.isHidden = false
    }
}
