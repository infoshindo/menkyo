//
//  RegistViewController.swift
//  menkyo
//
//  Created by infosquare on 2016/10/06.
//  Copyright © 2016年 infosquare. All rights reserved.
//

import UIKit

class RegistViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    let common: Common = Common();
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userGender: UISegmentedControl!
    @IBOutlet weak var userBirthYear: UITextField!
    @IBOutlet weak var userPref: UITextField!
    @IBOutlet weak var errorFieldEmail: UILabel!
    @IBOutlet weak var errorFieldPassword: UILabel!
    @IBOutlet weak var errorFieldBirthYear: UILabel!
    @IBOutlet weak var errorFieldPref: UILabel!
    var userGenderText: String = "男" ;
    var BirthYearAry:[String] = ["1970","1971"]
    var pref:[String] = ["東京都","神奈川"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.    }
        
        setField()
    }

    func setField(){
        self.view.addSubview(userBirthYear)
        self.view.addSubview(userPref)
        
        // 生年用のpickerView
        let birthYearPickerView = UIPickerView()
        birthYearPickerView.showsSelectionIndicator = true
        birthYearPickerView.delegate = self
        userBirthYear.inputView = birthYearPickerView
        birthYearPickerView.tag = 1
        
        // 都道府県用のpickerView
        let prefView = UIPickerView()
        prefView.showsSelectionIndicator = true
        prefView.delegate = self
        userPref.inputView = prefView
        prefView.tag = 2

    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var pickCount: Int = 1;
        // tagによってpickerViewを切り替えている
        if pickerView.tag == 1
        {
            pickCount = BirthYearAry.count
        }
        else if pickerView.tag == 2
        {
            pickCount = pref.count
        }
        return pickCount
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var pickString: String = "";
        if pickerView.tag == 1
        {
            pickString = BirthYearAry[row]
        }
        else if pickerView.tag == 2
        {
            pickString = pref[row]
        }
        return pickString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1
        {
            userBirthYear.text = BirthYearAry[row]
        }
        else if pickerView.tag == 2
        {
            userPref.text = pref[row]
        }
    }
    
    // 画面タップでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // 性別のチェックボックスの変更
    @IBAction func genderSegmentChanged(_ sender: AnyObject) {
        //選択されているセグメントのインデックス
        let selectedIndex = userGender.selectedSegmentIndex
        //選択されたインデックスの文字列を取得
        userGenderText = userGender.titleForSegment(at: selectedIndex)!
    }
    @IBAction func submitButton(_ sender: AnyObject) {
        errorFieldEmail.text = "";
        errorFieldPassword.text = "";
        
//        if emailTextField.text?.isEmpty == true
//        {
//            errorFieldEmail.text = "メールアドレスは必須です。"
//        }
//        else if isValidEmail(string: emailTextField.text!) == false
//        {
//            errorFieldEmail.text = "メールアドレスの書式が正しくありません。"
//        }
//        
//        if passwordTextField.text?.isEmpty == true
//        {
//            errorFieldPassword.text = "パスワードは必須です。"
//        }
//        else if isValidWordCount(string: passwordTextField.text!) == false
//        {
//            errorFieldPassword.text = "パスワードの書式が正しくありません。"
//        } 

        
        let query: String = common.apiUrl + "regist/temp/?" + "user_email=" + emailTextField.text! + "&user_password=" + passwordTextField.text! + "&user_gender=" + userGenderText + "&user_birth_year=" + userBirthYear.text! + "&user_pref=" + userPref.text!
print(query)
        let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let URL:NSURL = NSURL(string: encodedURL)!
        let jsonData :NSData = NSData(contentsOf: URL as URL)!

        do
        {
            let json = try JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as! [String:String]
print("通信ok")
            if json["status"] == "ng"
            {
                // エラーメッセージの設定
                errorFieldEmail.text = json["user_email"]
                errorFieldPassword.text = json["user_password"]
                errorFieldBirthYear.text = json["user_birth_year"]
                errorFieldPref.text = json["user_pref"]
            }
            else if json["status"] == "ok"
            {
                
                let storyboard: UIStoryboard = self.storyboard!
                let nextView = storyboard.instantiateViewController(withIdentifier: "RegistTempEnd") as! RegistTempEndViewController
                self.present(nextView, animated: false, completion: nil)
            }
        }
        catch
        {
            // エラー処理
print("通信エラー")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValidWordCount(string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]{6,30}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: string)
        return result
    }
    
    func isValidEmail(string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: string)
        return result
    }
}

