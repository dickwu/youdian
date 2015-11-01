//
//  feedBack.swift
//  Udian
//
//  Created by farmerwu_pc on 15/9/12.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class feedBack: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var feedText: UITextView!
    @IBOutlet weak var backGround: UILabel!
    @IBOutlet weak var userInfo: UITextField!
    var OtherAlert = UIAlertView()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
        // Do any additional setup after loading the view.
        feedText.layer.cornerRadius = 4
        feedText.layer.borderWidth = 1
        feedText.layer.borderColor = UIColor.lightGrayColor().CGColor
        feedText.layer.masksToBounds = true
        
        backGround.layer.cornerRadius = 4
        backGround.layer.borderWidth = 1
        backGround.layer.borderColor = UIColor.lightGrayColor().CGColor
        backGround.layer.masksToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clear(sender: AnyObject) {
        feedText.resignFirstResponder()
        userInfo.resignFirstResponder()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func sendFeedback(sender: AnyObject) {
        if feedText.text == ""{
            self.errorMessage("提示", info: "反馈内容不能为空")
            
        }else{
            OtherAlert = UIAlertView(title: "发送反馈中", message: nil, delegate: nil, cancelButtonTitle: nil)
            OtherAlert.show()
            APIPOST.ReportInfo("0", publishuid: "0", reportcontain: feedText.text, feedid: "0", typecontain: userInfo.text!, com: { (res) -> Void in
                 self.OtherAlert.dismissWithClickedButtonIndex(0, animated: false)
                if res["success"].stringValue == "true"{
                    self.errorMessage("提示", info: "我们将尽快处理你的反馈信息")
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    self.errorMessage("提示", info: "反馈失败\n请重试")
                }
                
            })

        }
    }
}
