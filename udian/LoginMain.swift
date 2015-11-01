//
//  LoginMain.swift
//  Udian
//
//  Created by farmerwu_pc on 15/7/8.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class LoginMain: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var idback: UILabel!
    
    @IBOutlet weak var passBack: UILabel!
    
    @IBOutlet weak var idEnter: UITextField!
    
    @IBOutlet weak var passEnter: UITextField!
    
    @IBOutlet weak var SignUpBut: UIButton!
    
    @IBOutlet weak var LoginBut: UIButton!
    
    
    @IBOutlet weak var position: NSLayoutConstraint!
    
    var ArePassPhone = false
    var ArePassPWD = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = backColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        idback.layer.masksToBounds = true
        passBack.layer.masksToBounds = true
        idback.layer.cornerRadius = 4
        passBack.layer.cornerRadius = 4
        idback.layer.borderWidth = 1
        passBack.layer.borderWidth = 1
        idback.layer.borderColor = UIColor.lightGrayColor().CGColor
        passBack.layer.borderColor = UIColor.lightGrayColor().CGColor
        //
        SignUpBut.layer.masksToBounds = true
        LoginBut.layer.masksToBounds = true
        SignUpBut.layer.cornerRadius = 6
        LoginBut.layer.cornerRadius = 6
        idEnter.text = LocalData.userid
        checkAll()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    @IBAction func back(sender: UIButton) {
        disShow()
    }
    
    @IBAction func checkPhone(sender: AnyObject) {
        checkAll()
        if ArePassPhone{
            passEnter.becomeFirstResponder()
        }
    }
    
    @IBAction func checkPass(sender: AnyObject) {
        checkAll()
    }
    func checkAll(){
        let backColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        var level:CGFloat = 0
        LoginBut.enabled = false
        if idEnter.text?.length == 11&&validate(idEnter.text!){
                ArePassPhone = true
                level += 0.5
            idEnter.enablesReturnKeyAutomatically = false
        }else{
            ArePassPhone = false
            idEnter.enablesReturnKeyAutomatically = true
        }
        
        if passEnter.text!.length >= 6{
            ArePassPWD = true
            level += 0.5
            passEnter.enablesReturnKeyAutomatically = false
        }else{
            passEnter.enablesReturnKeyAutomatically = true
            ArePassPWD = false
        }
        
        if ArePassPhone && ArePassPWD{
            LoginBut.enabled = true
            LoginBut.backgroundColor = backColor
        }else{
            if level == 0.5{
                LoginBut.backgroundColor = backColor.colorWithAlphaComponent(0.7)
            }else{
                LoginBut.backgroundColor = UIColor.lightGrayColor()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        position.constant = -90
        return true
    }
    
    @IBAction func clear(sender: UIView) {
        idEnter.resignFirstResponder()
        passEnter.resignFirstResponder()
        position.constant = -16
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 10 {
            passEnter.becomeFirstResponder()
        }else{
            passEnter.resignFirstResponder()
            position.constant = -16
        }
        return true
    }
    @IBAction func login(sender: AnyObject) {
        LocalData.userid = idEnter.text!
        LocalData.userPWD = passEnter.text!
        MobClick.event("LoginBtnClicked")
        APIPOST.UserLogin { (res, err) -> Void in
            if res{
                LocalData.SuserPWD = LocalData.userPWD.sha512()!.uppercaseString
                self.disShow()
                
            }else{
                LocalData.userPWD = ""
                LocalData.SuserPWD = ""
                self.errorMessage("登录失败", info: err!)
            }
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

}
