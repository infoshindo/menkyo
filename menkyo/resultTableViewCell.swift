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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    /// 画像・タイトル・説明文を設定するメソッド
    func setCell(result: String, qNum: String, sentence: String, imageName: String, answered: String, correctAnswerd: String, explanation: String) {
        
        // 正誤の結果(Good OR Miss)
        resultLabel.text = result
        resultLabel.layer.cornerRadius = 3
        resultLabel.clipsToBounds = true
        if result == "Miss" {
            resultLabel.backgroundColor = UIColor.red
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
        
//        mylistButton.layer.borderWidth = 1.0;
//        mylistButton.layer.borderColor = UIColor.red.cgColor
//        mylistButton.layer.cornerRadius = 5
        
    }
}
