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
    @IBOutlet weak var userGender: UITextField!
    @IBOutlet weak var userBirthYear: UITextField!
    @IBOutlet weak var userPref: UITextField!
    
    @IBOutlet weak var privacy: UISegmentedControl!
    @IBOutlet weak var errorFieldEmail: UILabel!
    @IBOutlet weak var errorFieldPassword: UILabel!
    @IBOutlet weak var errorFieldBirthYear: UILabel!
    @IBOutlet weak var errorFieldPref: UILabel!
    @IBOutlet weak var errorFieldPrivacy: UILabel!
    var userGenderText: String = "男";
    var privacyText: String = "同意する";
    
    var BirthYearAry:[String] = ["","2000","1999","1998","1997","1996","1995","1994","1993","1992","1991","1990","1989","1988","1987","1986","1985","1984","1983","1982","1981","1980","1979","1978","1977","1976","1975","1974","1973","1972","1971","1970","1969","1968","1967","1966","1965","1964","1963","1962","1961","1960","1959","1958","1957","1956","1955","1954","1953","1952","1951","1950","1949","1948","1947","1946","1945","1944","1943","1942","1941","1940","1939","1938","1937","1936","1935","1934","1933","1932","1931","1930","1929","1928","1927"]
    var pref:[String] = ["","東京都","神奈川県","大阪府","愛知県","埼玉県","千葉県","兵庫県","北海道","福岡県","静岡県","茨城県","広島県","京都府","宮城県","新潟県","長野県","岐阜県","栃木県","群馬県","福島県","岡山県　","三重県","熊本県","鹿児島県","沖縄県","滋賀県","山口県","愛媛県","長崎県","奈良県","青森県","岩手県","大分県","石川県","山形県","宮崎県","富山県","秋田県","香川県","和歌山県","山梨県","佐賀県","福井県","徳島県","高知県","島根県","鳥取県"]
    var gender:[String] = ["","未選択","男","女"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.    }
        
        setField()
    }
    
    func moveMaintenance() {
        // メンテナンス中ならメンテナンス画面へ遷移
        let maintenance = common.CheckMaintenance()
        if ((maintenance) != nil) {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextView = storyboard.instantiateViewController(withIdentifier: "MaintenanceView") as! MaintenanceViewController
            nextView.maintenance_time = maintenance!
            self.present(nextView, animated: false, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // メンテナンス判定
        moveMaintenance()
    }

    func setField(){
        self.view.addSubview(userGender)
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
        
        // 性別用のpickerView
        let genderPickerView = UIPickerView()
        genderPickerView.showsSelectionIndicator = true
        genderPickerView.delegate = self
        userGender.inputView = genderPickerView
        genderPickerView.tag = 3

    }
    
    @IBAction func tapReception(_ sender: Any) {
        let url = NSURL(string: common.domainUrl + "app/reception/")
        UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func tapPrivacy(_ sender: Any) {
        let url = NSURL(string: common.domainUrl + "app/privacy/")
        UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
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
        else if pickerView.tag == 3
        {
            pickCount = gender.count
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
        else if pickerView.tag == 3
        {
            pickString = gender[row]
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
        else if pickerView.tag == 3
        {
            userGender.text = gender[row]
        }
    }
    
    @IBAction func tapBack(_ sender: AnyObject) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "loginTop") as! ViewController
        self.present(nextView, animated: false, completion: nil)
    }
    
    // 画面タップでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func privacySevmentChanged(_ sender: Any) {
        //選択されているセグメントのインデックス
        let selectedIndex = privacy.selectedSegmentIndex
        //選択されたインデックスの文字列を取得
        privacyText = privacy.titleForSegment(at: selectedIndex)!
    }
    // 性別のチェックボックスの変更
    /*
    @IBAction func genderSegmentChanged(_ sender: AnyObject) {
        //選択されているセグメントのインデックス
        let selectedIndex = userGender.selectedSegmentIndex
        //選択されたインデックスの文字列を取得
        userGenderText = userGender.titleForSegment(at: selectedIndex)!
    }
    */
    @IBAction func submitButton(_ sender: AnyObject) {
        // オフラインの場合はreturn
        if common.CheckNetwork() == false {
            return
        }
        
        // メンテナンス判定
        moveMaintenance()
        
        errorFieldEmail.text = ""
        errorFieldPassword.text = ""
        errorFieldBirthYear.text = ""
        errorFieldPref.text = ""
        errorFieldPrivacy.text = ""

        let query: String = common.apiUrl + "regist/temp/?" + "user_email=" + emailTextField.text! + "&user_password=" + passwordTextField.text! + "&user_gender=" + userGender.text! + "&user_birth_year=" + userBirthYear.text! + "&user_pref=" + userPref.text! + "&user_register_type=ios" + "&privacy=" + privacyText
        let encodedURL: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let URL:NSURL = NSURL(string: encodedURL)!
        let jsonData :NSData = NSData(contentsOf: URL as URL)!
        
        do
        {
            let json = try JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as! [String:String]
            if json["status"] == "ng"
            {
                // エラーメッセージの設定
                errorFieldEmail.text = json["user_email"]
                errorFieldPassword.text = json["user_password"]
                errorFieldBirthYear.text = json["user_birth_year"]
                errorFieldPref.text = json["user_pref"]
                errorFieldPrivacy.text = json["privacy"]
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

