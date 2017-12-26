//
//  MylistTableViewCell.swift
//  menkyo
//
//  Created by infosquare on 2016/12/27.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class MylistTableViewCell: UITableViewCell {
    var common: Common = Common()

    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    
    @IBOutlet weak var sentenceImgHeight: NSLayoutConstraint!
    
    @IBOutlet weak var sentenceImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(sentence: String, answer: String, explanation: String, imageName: String) {
        sentenceLabel.text = sentence
        answerLabel.text = answer
        explanationLabel.text = explanation

        // 問題画像の設定
        if imageName != "" {
            // キャッシュから読み込んで表示
            if let img = UIImage(contentsOfFile: common.path + "/" + imageName) {
                sentenceImg.isHidden = false
                sentenceImgHeight.constant = 150
                // 縦横の比率をそのままにする
                sentenceImg.contentMode = UIViewContentMode.scaleAspectFit
                // イメージビューに表示する
                sentenceImg?.image = img
            } else {
                // URLオブジェクトを作る
                let imgUrl = NSURL(string: common.imageUrl + imageName)
            
                // ファイルデータを作る
                if let file = NSData(contentsOf: imgUrl! as URL) {
                    sentenceImg.isHidden = false
                    sentenceImgHeight.constant = 100
                    // イメージデータを作る
                    let img = UIImage(data:file as Data)
                    // 縦横の比率をそのままにする
                    sentenceImg.contentMode = UIViewContentMode.scaleAspectFit
                    // イメージビューに表示する
                    sentenceImg?.image = img
                    // キャッシュ作成
                    let data = try? Data(contentsOf: imgUrl! as URL)
                    FileManager.default.createFile(atPath: common.path + "/" + imageName, contents: data, attributes: nil)
                } else {
                    sentenceImg.isHidden = true
                    sentenceImgHeight.constant = 0
                }
            }
        } else {
            sentenceImg.isHidden = true
            sentenceImgHeight.constant = 0
        }
    }
    
    }
