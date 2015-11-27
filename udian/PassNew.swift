//
//  PassNew.swift
//  Udian
//
//  Created by farmerwu_pc on 15/9/13.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class PassNew: UIViewController {

    @IBOutlet var backs: [UILabel]!
    
    @IBOutlet var PassInputs: [UITextField]!
    var CanPassSave = [false,false,false]
    
    var OtherAlert = UIAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "修改密码"
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
        // Do any additional setup after loading the view.
        for backGround in backs{
            backGround.layer.cornerRadius = 4
            backGround.layer.borderWidth = 1
            backGround.layer.borderColor = UIColor.lightGrayColor().CGColor
            backGround.layer.masksToBounds = true
        }
        for one in PassInputs{
            switch one.tag{
            case 10:
                one.addTarget(self, action: "checkOld:", forControlEvents: UIControlEvents.EditingChanged)
            case 11:
                one.addTarget(self, action: "checkNew:", forControlEvents: UIControlEvents.EditingChanged)
            case 12:
                one.addTarget(self, action: "RecheckNew:", forControlEvents: UIControlEvents.EditingChanged)
            default: break
            }
        }
        
    }
    func checkOld(sender:UITextField){
        if sender.text == LocalData.userPWD{
            sender.textColor = UIColor.blackColor()
            CanPassSave[0] = true
            PassInputs[1].becomeFirstResponder()
            
        }else{
            sender.textColor = UIColor.lightGrayColor()
            CanPassSave[0] = false
        }
        
    }
    func checkNew(sender:UITextField){
        if sender.text?.length >= 6  {
            sender.textColor = UIColor.blackColor()
            CanPassSave[1] = true
        }else{
            sender.textColor = UIColor.lightGrayColor()
            CanPassSave[1] = false
        }
    }
    func RecheckNew(sender:UITextField){
        if sender.text?.length >= 6 && PassInputs[1].text == sender.text {
            sender.textColor = UIColor.blackColor()
            CanPassSave[2] = true
            
        }else{
            sender.textColor = UIColor.lightGrayColor()
            CanPassSave[2] = false
        }
    }
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func checkpass(){
        
    }
    @IBAction func clear(sender: AnyObject) {
        for one in PassInputs{
            one.resignFirstResponder()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func change(sender: AnyObject) {
        if CanPassSave[0]{
            if CanPassSave[1]{
                if CanPassSave[2]{
                    OtherAlert = UIAlertView(title: "正在修改密码" , message: nil, delegate: nil, cancelButtonTitle: nil)
                    OtherAlert.show()
                    APIPOST.ChangePass(PassInputs[1].text!.sha512().uppercaseString, com: { (res) -> Void in
                        print(res)
                        self.OtherAlert.dismissWithClickedButtonIndex(0, animated: false)
                        if res["ResultData"]["isSuccess"].stringValue == "true"{
                            LocalData.userPWD = self.PassInputs[1].text!
                            LocalData.SuserPWD = self.PassInputs[1].text!.sha512().uppercaseString
                            self.errorMessage("提示", info: "密码修改成功")
                            self.navigationController?.popViewControllerAnimated(true)
                        }else{
                            self.errorMessage("提示", info: "密码修改失败")
                        }
                    })
                }else{
                    self.errorMessage("提示", info: "新密码两次输入不一样")
                }
            }else{
                self.errorMessage("提示", info: "新密码长度太短")
            }
        }else{
            self.errorMessage("提示", info: "旧密码错误")
        }
        
    }

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
