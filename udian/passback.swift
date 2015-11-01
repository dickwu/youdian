//
//  passback.swift
//  Udian
//
//  Created by farmerwu_pc on 15/8/25.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class passback: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var position: NSLayoutConstraint!
    
    @IBOutlet var backs: [UILabel]!
    
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var codeNum: UITextField!
    
    @IBOutlet weak var codeBut: UIButton!
    
    @IBOutlet weak var NextBut: UIButton!
    
    var timelimit = 60
    var code = ""
    
    
    @IBOutlet weak var passbackBack: UILabel!
    
    var CanPass = [false,false]
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    let backColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for one in backs{
            one.layer.masksToBounds = true
            one.layer.cornerRadius = 4
            one.layer.borderColor = UIColor.lightGrayColor().CGColor
            one.layer.borderWidth = 1
        }
        
        NextBut.layer.masksToBounds = true
        NextBut.layer.cornerRadius = 6
        
        codeBut.layer.masksToBounds = true
        codeBut.layer.cornerRadius = 4
        UnEnableNext()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        position.constant = -90
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func EnableNext(){
        NextBut.enabled = true
        //self.errorMessage("成功", info: "验证成功\n请进行下一步操作")
        NextBut.backgroundColor = backColor
        
        UnableCode()
        codeNum.resignFirstResponder()
    }
    func EnableCode(){
        
        codeBut.enabled = true
        codeNum.enabled = true
        codeBut.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        codeBut.backgroundColor = backColor
    }
    func UnEnableNext(){
        NextBut.enabled = false
        NextBut.backgroundColor = UIColor.lightGrayColor()
        
    }
    func UnableCode(){
        codeBut.enabled = false
        
        codeBut.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        codeBut.backgroundColor = UIColor.lightGrayColor()
    }

    
    @IBAction func checkPhone(sender: UITextField) {
        if sender.text!.length == 11{
            CanPass[0] = true
            EnableCode()
            codeNum.becomeFirstResponder()
        }else{
            CanPass[0] = false
            UnEnableNext()
            UnableCode()
        }
    }
    func validate(value: String) -> Bool {
        
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{5}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        
        let result =  phoneTest.evaluateWithObject(value)
        
        return result
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func getCode(sender: AnyObject) {
        APIPOST.checkAreAready(phoneNum.text!, com: { (res) -> Void in
            if !res{
                self.errorMessage("提示", info: "该用户不存在\n请返回注册")
                self.backtoLogin()
            }else{
                self.code = self.CountCode()
                NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updatemes:", userInfo: nil, repeats: true)
                self.timelimit = 60
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
            codeBut.setTitle("", forState: UIControlState.Normal)
            passbackBack.text = "等待\(timelimit)秒"

            
        }else{
            timer.invalidate()
            passbackBack.text = ""
            codeBut.setTitle("获取验证码", forState: UIControlState.Normal)
            phoneNum.enabled = true
            if NextBut.enabled{
                UnableCode()
                
            }else{
                
                EnableCode()
                
                
            }
            
        }
    }

    
    @IBAction func checkCode(sender: AnyObject) {
        if codeNum.text!.length == 4 && code == codeNum.text!{
            CanPass[1] = true
        }else{
            CanPass[1] = false
            
        }
        checkNext()

    }
    
    //check
    func checkNext(){
        if CanPass[0] && CanPass[1]{
            EnableNext()
        }else{
            UnEnableNext()
        }
    }
    
    @IBAction func clean(sender: AnyObject) {
        phoneNum.resignFirstResponder()
        codeNum.resignFirstResponder()
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
        return code == codeNum.text!
    }
    
    @IBAction func goNext(sender: AnyObject) {
        LocalData.userid = phoneNum.text!
        
        
    }
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
