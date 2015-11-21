//
//  signup.swift
//  Udian
//
//  Created by farmerwu_pc on 15/7/9.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class signup: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var phoneback: UILabel!
    
    @IBOutlet weak var codeBack: UILabel!
    
    @IBOutlet weak var getCodeBut: UIButton!
    
    @IBOutlet weak var selectBut: UIButton!
    
    
    @IBOutlet weak var nextBut: UIButton!
    
    var code = ""
    let back = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
    
    var timelimit = 60
    
    @IBOutlet weak var position: NSLayoutConstraint!
    
    @IBOutlet weak var passBack: UILabel!
    
    
    //data
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var CodeNum: UITextField!
    
    
    var CanPass = [false,false,true]
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        //checkNext()
        MobClick.beginLogPageView("注册")
    }
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("注册")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        phoneback.layer.masksToBounds = true
        phoneback.layer.cornerRadius = 4
        codeBack.layer.masksToBounds = true
        codeBack.layer.cornerRadius = 4
        phoneback.layer.borderColor = UIColor.lightGrayColor().CGColor
        phoneback.layer.borderWidth = 1
        codeBack.layer.borderColor = UIColor.lightGrayColor().CGColor
        codeBack.layer.borderWidth = 1
        getCodeBut.layer.cornerRadius = 4
        getCodeBut.layer.masksToBounds = true
        
        nextBut.layer.masksToBounds = true
        nextBut.layer.cornerRadius = 6
        self.backImage.endEditing(true)
        MobClick.event("SignUpBtnClicked")
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tap(sender: AnyObject) {
        phoneNum.resignFirstResponder()
        CodeNum.resignFirstResponder()
        position.constant = -16
    }
    
    @IBAction func back(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func userProtorcal(sender: UIButton) {
        //UserProtocol
        let story = UIStoryboard(name: "back", bundle: nil)
        let filte = story.instantiateViewControllerWithIdentifier("UserProtocol") as UIViewController
        //self.tabBarController?.tabBar.hidden = true
        self.navigationController?.pushViewController(filte, animated: true)
    }
    
    @IBAction func changeChoice(sender: UIButton) {
        if sender.tag == 66{
            sender.tag = 100
            sender.setBackgroundImage(UIImage(named: "未选选择按钮"), forState: UIControlState.Normal)
            CanPass[2] = false
        }else{
            sender.tag = 66
            sender.setBackgroundImage(UIImage(named: "已选选择按钮"), forState: UIControlState.Normal)
            CanPass[2] = true
        }
        checkNext()
    }
    //check
    func checkNext(){
        if CanPass[0] && CanPass[1] && CanPass[2]{
            EnableNext()
        }else{
            UnEnableNext()
        }
       
    }
    func validate(value: String) -> Bool {
        
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{5}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        
        let result =  phoneTest.evaluateWithObject(value)
        
        return result
        
    }

    func EnableNext(){
        nextBut.enabled = true
        nextBut.backgroundColor = back
        UnableCode()
        CodeNum.resignFirstResponder()
    }
    func EnableCode(){
        
        getCodeBut.enabled = true
        CodeNum.enabled = true

        getCodeBut.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        getCodeBut.backgroundColor = back
    }
    func UnEnableNext(){
        nextBut.enabled = false
        nextBut.backgroundColor = UIColor.lightGrayColor()
        
    }
    func UnableCode(){
        getCodeBut.enabled = false
        getCodeBut.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        getCodeBut.backgroundColor = UIColor.lightGrayColor()
    }
    @IBAction func next(sender: UIButton) {
        //数据保存和传递，页面跳转
        LocalData.KeepUserid = phoneNum.text!
    }

    @IBAction func checkPhone(sender: AnyObject) {
        CanPass[0] = validate(phoneNum.text!)
        if CanPass[0]{
            EnableCode()
            CodeNum.becomeFirstResponder()
        }else{
            UnableCode()
        }
    }
    @IBAction func checkCodeNum(sender: AnyObject) {
        if CodeNum.text!.length == 4 && code == CodeNum.text!{
            CanPass[1] = true
        }else{
            CanPass[1] = false
        }
        checkNext()
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        position.constant = -90
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        return true
    }
    //获取验证码
    @IBAction func getCode(sender: UIButton) {
        CodeNum.becomeFirstResponder()
        APIPOST.checkAreAready(phoneNum.text!, com: { (res) -> Void in
            if res{
                self.errorMessage("提示", info: "该用户已经存在\n请返回登录")
                self.backtoLogin()
            }else{
                self.code = self.CountCode()
                print(self.code)
                self.timelimit = 60
                NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updatemes:", userInfo: nil, repeats: true)
                APIPOST.SMSCheak(self.phoneNum.text!, code: self.code) { (res) -> Void in
                    if res == "0"{

                    }else{
                        self.errorMessage("获取失败", info: "请稍等一会再发送")
                    }
                }
            }
            }) { (res) -> Void in
                
        }
        
    }
    func updatemes(timer:NSTimer){
        if timelimit>0{
            timelimit--
            UnableCode()
            passBack.alpha = 1
            getCodeBut.setTitle("", forState: UIControlState.Normal)
            passBack.text = "等待\(timelimit)秒"
            
        }else{
            timer.invalidate()
            passBack.text = ""
            getCodeBut.setTitle("获取验证码", forState: UIControlState.Normal)
            passBack.alpha = 0
            phoneNum.enabled = true
            EnableCode()
//            if nextBut.enabled{
//                UnableCode()
//            }else{
//                
//            }
            
        }
    }

    func CountCode()->String{
        let code = "\(arc4random()%10000)"
        if code.characters.count != 4{
            return CountCode()
        }else{
            return code
        }
        
    }
    func checkCode()->Bool{
        return code == CodeNum.text!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
