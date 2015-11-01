//
//  ChangePass.swift
//  Udian
//
//  Created by farmerwu_pc on 15/8/25.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class ChangePass: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var position: NSLayoutConstraint!
    
    @IBOutlet var backs: [UILabel]!
    
    @IBOutlet weak var nextBut: UIButton!
    
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    var OtherAlert = UIAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for one in backs{
            one.layer.masksToBounds = true
            one.layer.cornerRadius = 4
            one.layer.borderColor = UIColor.lightGrayColor().CGColor
            one.layer.borderWidth = 1
        }
        nextBut.layer.masksToBounds = true
        nextBut.layer.cornerRadius = 6
        MobClick.event("AuthCodeNextBtnClicked")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        position.constant = -90
        return true
    }
    func checkNext(){
        if confirmPass.text!.length > 6 && confirmPass.text! == newPass.text!{
            nextBut.enabled = true
            nextBut.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        }else{
            nextBut.enabled = false
            nextBut.backgroundColor = UIColor.lightGrayColor()
        }
    }
    
    
    @IBAction func checkNew(sender: UITextField) {
        if sender.text!.length < 6{
            sender.textColor = UIColor.lightGrayColor()
        }else{
            sender.textColor = UIColor.blackColor()
        }
        checkNext()
        
    }

    
    @IBAction func recheckNew(sender: UITextField) {
        if sender.text!.length > 6 && sender.text! == newPass.text!{

            sender.resignFirstResponder()
            sender.textColor = UIColor.blackColor()
        }else{
            sender.textColor = UIColor.lightGrayColor()
        }
        checkNext()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.returnKeyType == UIReturnKeyType.Next{
            confirmPass.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func goback(sender: AnyObject) {
        OtherAlert = UIAlertView(title: "正在修改密码" , message: nil, delegate: nil, cancelButtonTitle: nil)
        OtherAlert.show()
        APIPOST.ChangePass(newPass.text!.sha512()!.uppercaseString, com: { (res) -> Void in
            print(res)
            self.OtherAlert.dismissWithClickedButtonIndex(0, animated: false)
            if res["ResultData"]["isSuccess"].stringValue == "true"{
                LocalData.userPWD = self.newPass.text!
                LocalData.SuserPWD = self.newPass.text!.sha512()!.uppercaseString
                self.errorMessage("提示", info: "密码修改成功")
                APIPOST.UserLogin { (res, err) -> Void in
                    print(res)
                    self.disShow()
                }
            }else{
                self.errorMessage("提示", info: "密码修改失败")
            }
        })
    }
    
    
    @IBAction func clean(sender: AnyObject) {
        newPass.resignFirstResponder()
        confirmPass.resignFirstResponder()
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
