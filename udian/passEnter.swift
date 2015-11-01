//
//  passEnter.swift
//  Udian
//
//  Created by farmerwu_pc on 15/7/11.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class passEnter: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var back1: UILabel!
    @IBOutlet weak var back2: UILabel!
    
    @IBOutlet weak var position: NSLayoutConstraint!
    
    @IBOutlet weak var phoneNum: UILabel!
    
    
    @IBOutlet weak var firstPass: UITextField!
    @IBOutlet weak var secendPass: UITextField!
    
    @IBOutlet weak var nextBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        back1.layer.masksToBounds = true
        back1.layer.cornerRadius = 4
        back1.layer.borderColor = UIColor.lightGrayColor().CGColor
        back1.layer.borderWidth = 1
        
        back2.layer.masksToBounds = true
        back2.layer.cornerRadius = 4
        back2.layer.borderColor = UIColor.lightGrayColor().CGColor
        back2.layer.borderWidth = 1
        
        nextBut.layer.masksToBounds = true
        nextBut.layer.cornerRadius = 6
        showPhoneNum()
        MobClick.event("AuthCodeNextBtnClicked")
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 10{
            secendPass.becomeFirstResponder()
        }else{
            position.constant = -16
            secendPass.resignFirstResponder()
        }
        return true
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        position.constant = -90
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 20{
            
            if firstPass.text!.characters.count <= 5{
                textField.resignFirstResponder()
                firstPass.becomeFirstResponder()
                self.errorMessage("警告", info: "密码位数小于6位\n请换用长度大于6位的密码")
                
            }
        }

    }
    
    @IBAction func checkFirst(sender: UITextField) {
        checkPass()
    }
    
    
    @IBAction func checkSecend(sender: UITextField) {
        checkPass()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func clear(sender: AnyObject) {
        firstPass.resignFirstResponder()
        secendPass.resignFirstResponder()
        position.constant = -16
    }
    @IBAction func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func checkPass(){
        if firstPass.text!.characters.count>=6 && firstPass.text! == secendPass.text!{
            EnableNext()
        }else{
            UnableNext()
        }
        
    }
    func EnableNext(){
        let black = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        firstPass.resignFirstResponder()
        secendPass.resignFirstResponder()
        nextBut.enabled = true
        nextBut.backgroundColor = black
    }
    func UnableNext(){
        nextBut.enabled = false
        nextBut.backgroundColor = UIColor.lightGrayColor()
        
    }
    
    func showPhoneNum(){
        let original :NSString = LocalData.KeepUserid
        let first :NSString = original.substringToIndex(3)
        let mid :NSString = original.substringFromIndex(3)
        let secend = mid.substringToIndex(4)
        let last = original.substringFromIndex(7)
        phoneNum.text = "\(first)  \(secend)  \(last)"
    }
    
    
    
    @IBAction func next(sender: UIButton) {
        LocalData.KeepPass = firstPass.text!
        
    }
    
    
    
    
    

}
