//
//  myinfo.swift
//  Udian
//
//  Created by farmerwu_pc on 15/8/15.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class myinfo: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let allFrame = UIScreen.mainScreen().applicationFrame
    let nowFrame = UIScreen.mainScreen().applicationFrame
    let PicProcess = DACircularProgressView()
    var OtherAlert = UIAlertView()
    @IBOutlet weak var backLable: UILabel!
    @IBOutlet weak var messageNumLableL: UILabel!
    
    @IBOutlet weak var headPic: UIImageView!
    
    @IBOutlet var backs: [UILabel]!
    
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var Intro: UITextField!
    //保存对应的值
    var sexTypekeep = UIImageView()
    var sexStringKeep = String()
    var birthKeep = UILabel()
    var birthStringKeep = String()
    var atType = String()
    /***************************************************************************/
    /*
    按照对应的性别，生日设置初始值
    
    */
    /***************************************************************************/
    
    //背景
    let background = UIButton()
    //性别
    var sexType = String()
    let Sexback = UIButton()
    let manBut = UIButton()
    let famaleBut = UIButton()
    let manLable = UILabel()
    let famaleLable = UILabel()
    let manSelect = UIImageView()
    let famaleSelect = UIImageView()
    let confiremBut = UIButton()
    //生日选择
    let birthPicker = UIDatePicker()
    
    var canHide = true
    
    
    
    //--------------------------------------
    //消息
    let Mes = UITableView()
    let mesback = UIButton()
    let data = MeaageData()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messageNumLableL.layer.masksToBounds = true
        messageNumLableL.layer.cornerRadius = 7
        self.view.sendSubviewToBack(backLable)
        load()
        setBack()
        SystemInfoUpdate()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SystemInfoUpdate", name: "SystemInfoUpdate", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushTofeed", name: "PushJump", object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver("gotoFeedDetil", name: "gotoFeedDetil", object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func load(){
        let nowFrame = UIScreen.mainScreen().applicationFrame
        headPic.layer.masksToBounds = true
        headPic.layer.cornerRadius = 50
        SPic.dowmloadPic(LocalData.userPic, proce: { (pro) -> Void in
            
            }) { (img) -> Void in
                self.headPic.image = img
        }
        nickName.text = LocalData.userNick
        Intro.text = LocalData.userIntro
        for one in backs{
            one.layer.masksToBounds = true
            one.layer.borderColor = UIColor.lightGrayColor().CGColor
            one.layer.borderWidth = 1
            one.layer.cornerRadius = 4
        }
        let oneWidth:CGFloat = (nowFrame.width - 8)/3
        let exlplians = ["性别设置","生日设置"]
        for i in 0...2{
            let ii = CGFloat(i)
            let Oneback = UIImageView(frame: CGRect(x: oneWidth*ii + 8, y: 312, width: oneWidth - 8, height: oneWidth - 8 ))
            Oneback.backgroundColor = UIColor.whiteColor()
            Oneback.layer.cornerRadius = 8
            Oneback.layer.borderWidth = 1
            Oneback.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
            Oneback.layer.shadowColor = UIColor.lightGrayColor().CGColor
            Oneback.layer.shadowOffset = CGSizeMake(1.25, 1.25)
            Oneback.layer.shadowOpacity = 1
            Oneback.layer.shadowRadius = 0
            let oneImage = UIImageView(frame: CGRect(x: oneWidth/4 - 4  , y: 10, width: oneWidth/2, height: oneWidth/2))
            //oneImage.backgroundColor = UIColor.darkGrayColor()
            if i == 0{
                if LocalData.userSex == "男"{
                    oneImage.image = UIImage(named: "选项A按钮（已选）")
                }else{
                    oneImage.image = UIImage(named: "选项B按钮（已选）")
                }
                sexTypekeep = oneImage
            }else{
                oneImage.image = UIImage(named: "设置触发按钮\(i)")
            }
            Oneback.addSubview(oneImage)
            let explain = UILabel(frame: CGRect(x: 0, y: oneWidth/2 + 8 , width: oneWidth - 8, height: 40))
            explain.font = UIFont.systemFontOfSize(15)
            explain.textColor = UIColor.darkGrayColor()
            if i == 2{
                explain.numberOfLines = 2
                Oneback.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
                let connet:NSString = "高级设置\n（即将上线）"
                let attri = NSMutableAttributedString(string: connet as String)
                let attributesForSmall:[String:AnyObject] = [
                    //  设置字号为60
                    NSFontAttributeName:UIFont.systemFontOfSize(12),
                    //  设置文本颜色为黄色
                    NSForegroundColorAttributeName:UIColor.darkGrayColor()
                ]
                attri.setAttributes(attributesForSmall, range: connet.rangeOfString("（即将上线）"))
                explain.attributedText = attri
            }else{
                explain.numberOfLines = 1
                explain.text = exlplians[i]
                let GoBut = UIButton(frame: CGRect(x: oneWidth*ii + 8, y: 312, width: oneWidth - 8, height: oneWidth - 8 ))
                if i == 0{
                    GoBut.addTarget(self, action: "changeSex", forControlEvents: UIControlEvents.TouchUpInside)
                }else{
                    GoBut.addTarget(self, action: "showBirth", forControlEvents: UIControlEvents.TouchUpInside)
                    birthKeep = explain
                    let dateBirth = LocalData.userBirth.toDate("yyyy/MM/dd")
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if dateBirth != nil{
                        birthKeep.text = dateFormatter.stringFromDate(dateBirth!)
                    }
                    
                    
                }
                self.view.addSubview(GoBut)
            }
            explain.textAlignment = .Center
            Oneback.addSubview(explain)
            self.view.addSubview(Oneback)
        }
        /*
        //设置绑定按钮
        let twoWidth = (nowFrame.width - 8)/4
        let twoExplains = ["绑定QQ","绑定微信","绑定微博","绑定邮箱"]
        for i in 0...3{
            let ii = CGFloat(i)
            let Oneback = UIImageView(frame: CGRect(x: twoWidth*ii + 8, y: 312 + oneWidth , width: twoWidth - 8, height: twoWidth - 8))
            Oneback.backgroundColor = UIColor.whiteColor()
            Oneback.layer.cornerRadius = 8
            Oneback.layer.shadowColor = UIColor.darkGrayColor().CGColor
            Oneback.layer.shadowOffset = CGSizeMake(4, 4)
            Oneback.layer.shadowOpacity = 0.5
            Oneback.layer.shadowRadius = 2
            
            let oneImage = UIImageView(frame: CGRect(x: twoWidth/4 - 4  , y: 8, width: twoWidth/2, height: twoWidth/2))
            oneImage.image = UIImage(named: "绑定触发按钮\(i)")
            Oneback.addSubview(oneImage)
            
            let explain = UILabel(frame: CGRect(x: 0, y: twoWidth/2 + 10 , width: twoWidth - 8, height: 20))
            explain.font = UIFont.systemFontOfSize(15)
            explain.textColor = UIColor.darkGrayColor()
            explain.text = twoExplains[i]
            explain.textAlignment = .Center
            Oneback.addSubview(explain)
            
            let goBut = UIButton(frame: CGRect(x: twoWidth*ii + 8, y: 312 + oneWidth , width: twoWidth - 8, height: twoWidth - 8))
            goBut.tag = 100 + i
            goBut.addTarget(self, action: "boundOthers:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(Oneback)
            self.view.addSubview(goBut)
        }*/
    }
    
    func changeSex(){
        print("dianji")
        self.view.addSubview(background)
        self.view.addSubview(Sexback)
        self.view.addSubview(manBut)
        self.view.addSubview(famaleBut)
        self.view.addSubview(manLable)
        self.view.addSubview(famaleLable)
        self.view.addSubview(manSelect)
        self.view.addSubview(famaleSelect)
        self.view.addSubview(confiremBut)
        
        
        canHide = false
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                
                self.Sexback.frame = CGRect(x: 0, y: self.allFrame.height-180, width: self.allFrame.width, height: 200)
                self.manLable.frame = CGRect(x: self.allFrame.width/4.0 - 20 , y:self.allFrame.height - 82, width: 40, height: 22)
                self.famaleLable.frame = CGRect(x: self.allFrame.width/4.0*3 - 20 , y:self.allFrame.height - 82, width: 40, height: 22)
                
                self.manSelect.frame = CGRect(x: self.allFrame.width/4.0 - 5 , y:self.allFrame.height - 52, width: 10, height: 10)
                self.famaleSelect.frame = CGRect(x: self.allFrame.width/4.0*3 - 5 , y:self.allFrame.height - 52, width: 10, height: 10)
                
                self.manBut.frame = CGRect(x: self.allFrame.width/4.0 - 30 , y:self.allFrame.height - 150, width: 60, height: 60)
                self.famaleBut.frame = CGRect(x: self.allFrame.width/4*3 - 30 , y:self.allFrame.height - 150, width: 60, height: 60)
                self.confiremBut.frame = CGRect(x: 0, y: self.allFrame.height-30, width: self.allFrame.width, height: 50)
                }) { (Bool) -> Void in
                    if Bool{
                        if LocalData.userSex == "女"{
                            self.changeFamale()
                        }else{
                            self.changeMan()
                        }
                    }
            }
        
        
        
        
        atType = "gender"
        //Sex.text = "女"
        //checkRes[2] = true
    }
    func showBirth(){
        self.view.addSubview(background)
        self.view.addSubview(Sexback)
        self.view.addSubview(birthPicker)
        self.view.addSubview(confiremBut)
        atType = "birthday"
        UILabel.animateWithDuration(0.5, animations: { () -> Void in
            self.Sexback.frame = CGRect(x: 0, y: self.allFrame.height-180, width: self.allFrame.width, height: 200)

            }) { (Bool) -> Void in
                if LocalData.userSex == "女"{
                    self.changeFamale()
                }else{
                    self.changeMan()
                }
                
        }
        UIButton.animateWithDuration(0.5, animations: { () -> Void in

            self.confiremBut.frame = CGRect(x: 0, y: self.allFrame.height-30, width: self.allFrame.width, height: 50)
            }) { (Bool) -> Void in
                
        }
        UIDatePicker.animateWithDuration(0.5, animations: { () -> Void in
            self.birthPicker.frame = CGRect(x: 0, y: self.allFrame.height-180, width: self.allFrame.width, height: 170)
            }) { (Bool) -> Void in
                
        }

    }
    
    @IBAction func changeNick(sender: AnyObject) {
        let alertController = UIAlertController(title: "修改昵称", message: "请输入你的新昵称", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {(actionSheet: UIAlertAction!)in (self.cancelAction())})
        let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler:  {(actionSheet: UIAlertAction!)in (self.NickokAction())})
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        alertController.addTextFieldWithConfigurationHandler { (TextField) -> Void in
            TextField.text = LocalData.userNick
            TextField.addTarget(self, action: "saveNick:", forControlEvents: UIControlEvents.EditingChanged)
        }
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    func NickokAction(){
        OtherAlert = UIAlertView(title: nil, message: "修改中", delegate: nil, cancelButtonTitle: nil)
        OtherAlert.show()
        if nickName.text == ""{
            self.errorMessage("提示", info: "昵称不能为空")
        }else{
            APIPOST.changeUserInfo("nickname", InformationValue: nickName.text!) { (res, err) -> Void in
                self.OtherAlert.dismissWithClickedButtonIndex(0, animated: false)
                if res{
                    
                    LocalData.userNick = self.nickName.text!
                    //self.errorMessage("", info: "修改成功")
                }else{
                    self.errorMessage("", info: "修改失败")
                }
            }
        }
        
    }
    
    func cancelAction(){
        
    }
    func saveNick(sender:UITextField){
        self.nickName.text = sender.text!
    }

    
    
    @IBAction func cahngeIntro(sender: AnyObject) {
        let alertController = UIAlertController(title: "修改个人签名", message: "请输入你的新签名", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {(actionSheet: UIAlertAction!)in (self.cancelAction())})
        let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler:  {(actionSheet: UIAlertAction!)in (self.IntroOkAction())})
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        alertController.addTextFieldWithConfigurationHandler { (TextField) -> Void in
            TextField.text = LocalData.userIntro
            TextField.addTarget(self, action: "saveIntro:", forControlEvents: UIControlEvents.EditingChanged)
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func IntroOkAction(){
        OtherAlert = UIAlertView(title: nil, message: "修改中", delegate: nil, cancelButtonTitle: nil)
        OtherAlert.show()
        APIPOST.changeUserInfo("sign", InformationValue: Intro.text!) { (res, err) -> Void in
            self.OtherAlert.dismissWithClickedButtonIndex(0, animated: false)
            if res{
                LocalData.userIntro = self.Intro.text!
                self.errorMessage("", info: "修改成功")
            }
        }
    }
    func saveIntro(sender:UITextField){
        self.Intro.text = sender.text!
    }

    
  ///////////////////////////////////////////////////////////////////////////////////////////
    
    
    func setBack(){
        nickName.resignFirstResponder()
        background.frame = CGRect(x: 0, y: -20, width: allFrame.width, height: allFrame.height + 20)
        background.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        background.addTarget(self, action: "hideBack", forControlEvents: UIControlEvents.TouchDown)
        
        Sexback.frame = CGRect(x: 0, y: allFrame.height-20, width: allFrame.width, height: 200)
        Sexback.backgroundColor = UIColor(red: 231/255, green: 232/255, blue: 234/255, alpha: 1)
        //按钮切换
        manBut.frame = CGRect(x: allFrame.width/4.0 - 30 , y:allFrame.height + 50, width: 60, height: 60)
        manBut.setBackgroundImage(UIImage(named: "选项A按钮（未选）"), forState: UIControlState.Normal)
        manBut.addTarget(self, action: "changeMan", forControlEvents: UIControlEvents.TouchUpInside)
        
        famaleBut.frame = CGRect(x: allFrame.width/4*3 - 30, y: allFrame.height  + 50, width: 60, height: 60)
        famaleBut.setBackgroundImage(UIImage(named: "选项B按钮（未选）"), forState: UIControlState.Normal)
        famaleBut.addTarget(self, action: "changeFamale", forControlEvents: UIControlEvents.TouchUpInside)
        //文字
        manLable.frame = CGRect(x: allFrame.width/4.0 - 20 , y:allFrame.height + 116 , width: 40, height: 22)
        manLable.text = "男性"
        manLable.textAlignment = NSTextAlignment.Center
        manLable.font = UIFont(name: "System", size: 15)
        
        famaleLable.frame = CGRect(x: allFrame.width/4.0*3 - 20 , y:allFrame.height + 116, width: 40, height: 22)
        famaleLable.text = "女性"
        famaleLable.textAlignment = NSTextAlignment.Center
        famaleLable.font = UIFont(name: "System", size: 15)
        //图标
        manSelect.frame = CGRect(x: allFrame.width/4.0 - 5 , y:allFrame.height + 148, width: 10, height: 10)
        manSelect.image = UIImage(named: "选项(未选)")
        
        famaleSelect.frame = CGRect(x: allFrame.width/4.0*3 - 5 , y:allFrame.height + 148, width: 10, height: 10)
        famaleSelect.image = UIImage(named: "选项(未选)")
        //确认按钮
        confiremBut.frame = CGRect(x: 0, y: allFrame.height+170, width: allFrame.width, height: 50)
        confiremBut.setImage(UIImage(named: "确认触发按钮"), forState: UIControlState.Normal)
        confiremBut.backgroundColor = UIColor(red: 220/255, green: 221/255, blue: 223/255, alpha: 1)
        confiremBut.addTarget(self, action: "conform", forControlEvents: UIControlEvents.TouchUpInside)
        //生日选择器
        birthPicker.frame = CGRect(x: 0, y: allFrame.height+20, width: allFrame.width, height: 170)
        birthPicker.datePickerMode = UIDatePickerMode.Date
        birthPicker.addTarget(self, action: "handleData:", forControlEvents: UIControlEvents.ValueChanged)
        birthPicker.maximumDate = "2010-01-01".toDate()
        birthPicker.minimumDate = "1900-01-01".toDate()
        
        birthPicker.date = LocalData.userBirth.toDate("yyyy/MM/dd")!
        birthStringKeep = LocalData.userBirth
    }
    func hideBack(){
        if canHide{
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                
                self.Sexback.frame = CGRect(x: 0, y: self.allFrame.height-20, width: self.allFrame.width, height: 200)
                self.manBut.frame = CGRect(x: self.allFrame.width/4.0 - 30 , y:self.allFrame.height + 50, width: 60, height: 60)
                self.famaleBut.frame = CGRect(x: self.allFrame.width/4*3 - 30, y: self.allFrame.height  + 50, width: 60, height: 60)
                self.manLable.frame = CGRect(x: self.allFrame.width/4.0 - 20 , y:self.allFrame.height + 116 , width: 40, height: 22)
                self.famaleLable.frame = CGRect(x: self.allFrame.width/4.0*3 - 20 , y:self.allFrame.height + 116, width: 40, height: 22)
                self.manSelect.frame = CGRect(x: self.allFrame.width/4.0 - 5 , y:self.allFrame.height + 148, width: 10, height: 10)
                self.famaleSelect.frame = CGRect(x: self.allFrame.width/4.0*3 - 5 , y:self.allFrame.height + 148, width: 10, height: 10)
                self.confiremBut.frame = CGRect(x: 0, y: self.allFrame.height+170, width: self.allFrame.width, height: 50)
                }) { (Bool) -> Void in
                    self.confiremBut.removeFromSuperview()
                    self.manSelect.removeFromSuperview()
                    self.famaleSelect.removeFromSuperview()
                    self.manLable.removeFromSuperview()
                    self.famaleLable.removeFromSuperview()
                    self.manBut.removeFromSuperview()
                    self.famaleBut.removeFromSuperview()
                    self.Sexback.removeFromSuperview()
                    self.background.removeFromSuperview()
                    self.birthPicker.removeFromSuperview()
                    self.background.enabled = true
            }
            
            //position.constant = 0
            
            if LocalData.userSex == "男"{
                sexTypekeep.image = UIImage(named: "选项A按钮（已选）")
            }else{
                sexTypekeep.image = UIImage(named: "选项B按钮（已选）")
            }
            let dateBirth = LocalData.userBirth.toDate("yyyy/MM/dd")
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            birthKeep.text = dateFormatter.stringFromDate(dateBirth!)
            
            setBack()
        }
    }
    func changeMan(){
        
        UIButton.animateWithDuration(0.2, animations: { () -> Void in
            self.manBut.frame = CGRect(x: self.allFrame.width/4 - 30, y: self.allFrame.height - 160, width: 60, height: 60)
            self.manBut.setBackgroundImage(UIImage(named: "选项A按钮（已选）"), forState: UIControlState.Normal)
            
            }, completion: { (Bool) -> Void in

                self.canHide = true
        })
        famaleBut.enabled = true
        manBut.enabled = false
        UIButton.animateWithDuration(0.2, animations: { () -> Void in
            self.famaleBut.frame = CGRect(x: self.allFrame.width/4*3 - 30, y: self.allFrame.height - 150, width: 60, height: 60)
            self.famaleBut.setBackgroundImage(UIImage(named: "选项B按钮（未选）"), forState: UIControlState.Normal)
            }, completion: { (Bool) -> Void in

                self.canHide = true
        })
        manSelect.image = UIImage(named: "选项(已选)")
        famaleSelect.image = UIImage(named: "选项(未选)")
        sexTypekeep.image = UIImage(named: "选项A按钮（已选）")
        sexStringKeep =  "男"
    }
    func changeFamale(){
        famaleBut.enabled = false
        manBut.enabled = true
        UIButton.animateWithDuration(0.2, animations: { () -> Void in
            self.famaleBut.frame = CGRect(x: self.allFrame.width/4*3 - 30, y: self.allFrame.height - 160, width: 60, height: 60)
            self.famaleBut.setBackgroundImage(UIImage(named: "选项B按钮（已选）"), forState: UIControlState.Normal)
            }, completion: { (Bool) -> Void in
                self.canHide = true

        })
        UIButton.animateWithDuration(0.2, animations: { () -> Void in
            self.manBut.frame = CGRect(x: self.allFrame.width/4 - 30, y: self.allFrame.height - 150, width: 60, height: 60)
            self.manBut.setBackgroundImage(UIImage(named: "选项A按钮（未选）"), forState: UIControlState.Normal)
            }, completion: { (Bool) -> Void in

                self.canHide = true
        })
        famaleSelect.image = UIImage(named: "选项(已选)")
        manSelect.image = UIImage(named: "选项(未选)")
        sexTypekeep.image = UIImage(named: "选项B按钮（已选）")
        sexStringKeep =  "女"
        //Sex.text = "女"
        //checkRes[2] = true
        //self.check()
    }
    //生日日期选择
    func handleData(sender: UIDatePicker){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let text = dateFormatter.stringFromDate(sender.date)
        birthStringKeep = text
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let text2 = dateFormatter.stringFromDate(sender.date)
        birthKeep.text = text2
        print(text)
        //checkRes[3] = true
        //self.check()
    }
    func conform(){
        LocalData.userSex = sexStringKeep
        if atType == "gender"{
            OtherAlert = UIAlertView(title: nil, message: "修改中", delegate: nil, cancelButtonTitle: nil)
            OtherAlert.show()
            APIPOST.changeUserInfo(atType, InformationValue: sexStringKeep) { (res, err) -> Void in
                self.OtherAlert.dismissWithClickedButtonIndex(0, animated: false)
                if res{
                    LocalData.userSex = self.sexStringKeep
                    //self.errorMessage("", info: "修改成功")
                }else{
                    self.errorMessage("", info: "修改失败")
                }
                self.hideBack()
            }
        }else{
            OtherAlert = UIAlertView(title: nil, message: "修改中", delegate: nil, cancelButtonTitle: nil)
            OtherAlert.show()
            APIPOST.changeUserInfo(atType, InformationValue: birthStringKeep) { (res, err) -> Void in
                self.OtherAlert.dismissWithClickedButtonIndex(0, animated: false)
                if res{
                    LocalData.userBirth = self.birthStringKeep
                    //self.errorMessage("", info: "修改成功")
                }else{
                    self.errorMessage("", info: "修改失败")
                }
                self.hideBack()
            }
        }
        
        
    }
    
    func boundOthers(sender:UIButton){
        print(sender.tag)
        
    }
    
    @IBAction func clear(sender: AnyObject) {
        nickName.resignFirstResponder()
        Intro.resignFirstResponder()
    }
    
    @IBAction func takePhone(sender: AnyObject) {
        //拍照
        hideBack()
        let action = UIAlertController(title: "更新头像", message: "选取本地图库图片更新头像,如有权限提醒请通过", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let op0 = UIAlertAction(title: "从相册中选取", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!)in (self.choicelocal())})
        let op1 = UIAlertAction(title: "拍照选取", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!)in (self.takephoto())})
        let opend = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {(actionSheet: UIAlertAction!)in (print("Cancel"))})
        action.addAction(op0)
        action.addAction(op1)
        action.addAction(opend)
        self.presentViewController(action, animated: true, completion: nil)
        
    }
    func choicelocal(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            //print("Button capture")
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            //imag.mediaTypes = [kUTTypeImage];
            imag.allowsEditing = true
            
            self.presentViewController(imag, animated: true, completion: nil)
        }
    }
    func takephoto(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            //print("Button capture")
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.Camera;
            //imag.mediaTypes = [kUTTypeImage];
            imag.allowsEditing = true
            
            self.presentViewController(imag, animated: true, completion: nil)
        }
    }
    //选取并上传图片
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]){
        let selectedImage : UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        print("头像赋值")
        //headPic.image = selectedImage
        //uploadPicture
        
        self.headPic.image = selectedImage
        
        
        //self.headBut.setTitle("上传中....", forState: UIControlState.Disabled)
        //self.table.reloadData()
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd/mm/ss"
        let text = dateFormatter.stringFromDate(NSDate())
        let picName = (LocalData.userid + text).sha1()!
        print(picName)
        self.PicProcess.frame = CGRect(x: 30, y: 30, width: 40, height: 40)
        self.headPic.addSubview(PicProcess)
        self.PicProcess.progressTintColor = UIColor(red: 125/255, green: 236/255, blue: 1, alpha: 0.6)
        self.PicProcess.trackTintColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        SPic.uploadPicWithPro(picName, Pic: selectedImage, com: { (succsess, res) -> Void in
            
            
            }) { (pro) -> Void in
                //print(pro)
                
                
                self.PicProcess.setProgress(pro, animated: true)
                //self.table.reloadData()
                if pro == 1.0{
                    self.PicProcess.removeFromSuperview()
                    APIPOST.changeUserInfo("headphoto", InformationValue: Connect.picMain + picName + ".png", com:
                        { (res,err) -> Void in
                            if res{
                                LocalData.userPic = Connect.picMain + picName + ".png"
                                self.errorMessage("", info: "修改成功")
                            }
                    })
                    
                }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func showSystemMes(sender: AnyObject) {
        checkLogin { (res) -> Void in
            if res{
                self.mesback.frame = CGRect(x: 0, y: 0, width: self.nowFrame.width, height: self.nowFrame.height + 20)
                self.mesback.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.8)
                self.mesback.addTarget(self, action: "hideMessage", forControlEvents: UIControlEvents.TouchUpInside)
                self.Mes.frame = CGRect(x: 8, y: 110, width: self.nowFrame.width - 16, height: self.nowFrame.height - 210)
                let tblView =  UIView(frame: CGRectZero)
                self.Mes.tableFooterView = tblView
                self.Mes.layer.cornerRadius = 8
                self.Mes.dataSource = self.data
                self.Mes.delegate = self.data
                MobClick.event("NotificationBtnClicked")
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "NeedReload", name: "NeedReload", object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotoFeedDetil", name: "gotoFeedDetil", object:nil)
                let hideBut = UIButton(frame: CGRect(x: 8, y: self.nowFrame.height - 124, width: self.nowFrame.width - 16, height: 40))
                hideBut.backgroundColor = UIColor.whiteColor()
                hideBut.layer.cornerRadius = 8
                hideBut.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
                hideBut.addTarget(self, action: "hideMessage", forControlEvents: UIControlEvents.TouchUpInside)
                
                
                let deletIamge = UIImageView(frame: CGRect(x: self.nowFrame.width/2 - 18, y:  self.nowFrame.height - 104, width: 36, height: 36))
                deletIamge.image = UIImage(named: "关闭消息按钮")
                let RightGuesTure = UISwipeGestureRecognizer(target: self, action: "ChangToStopJump")
                RightGuesTure.direction = .Left
                self.Mes.addGestureRecognizer(RightGuesTure)
                let MianTitle = UILabel(frame: CGRect(x:8 , y: 70 , width: self.nowFrame.width - 16, height: 66))
                MianTitle.text = "提醒通知\n"
                MianTitle.textAlignment = .Center
                MianTitle.numberOfLines = 2
                MianTitle.textColor = UIColor.darkGrayColor()
                MianTitle.font = UIFont.boldSystemFontOfSize(22)
                MianTitle.backgroundColor = UIColor.whiteColor()
                MianTitle.layer.masksToBounds = true
                MianTitle.layer.cornerRadius = 8
                
                let line = UILabel(frame: CGRect(x: 24, y: 110, width: self.nowFrame.width - 32, height: 0.5))
                line.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.7)
                
                self.view.addSubview(self.mesback)
                self.mesback.addSubview(MianTitle)
                self.mesback.addSubview(self.Mes)
                
                self.mesback.addSubview(hideBut)
                
                self.mesback.addSubview(line)
                self.mesback.addSubview(deletIamge)

                APIPOST.SystemInfoList({ (res) -> Void in
                    LocalData.UnreadNum = 0
                    let datas = JSON(res)["data"].arrayValue
                    print(datas)
                    LocalData.sysInfo = [SystemInfo]()
                    for one in datas{
                        let newInfo = SystemInfo()
                        if one["ReadTime"].stringValue == "nul"{
                            LocalData.UnreadNum = LocalData.UnreadNum + 1
                        }
                        newInfo.feedId = one["fromFeed"].stringValue
                        newInfo.fromUid = one["uid"].stringValue
                        newInfo.infoid = one["id"].stringValue
                        newInfo.Message = one["infodetail"].stringValue
                        newInfo.otherhidename = one["commentname"].stringValue
                        newInfo.Times = one["SaveTime"].stringValue
                        newInfo.countHight()
                        LocalData.sysInfo.append(newInfo)
                        
                    }
                    
                    
                    
                    self.Mes.reloadData()
                    
                })
                
            }
        }
    }
    
    func NeedReload(){
        Mes.reloadData()
    }
    //系统消息更新函数 只有有系统消息图标的地方才注册这个事件
    func SystemInfoUpdate(){
        if LocalData.UnreadNum != 0{
            self.messageNumLableL.alpha = 1
            self.messageNumLableL.text = "\(LocalData.UnreadNum)"
        }else{
            self.messageNumLableL.alpha = 0
        }
        APIPOST.SystemInfoList({ (res) -> Void in
            LocalData.UnreadNum = 0
            let datas = JSON(res)["data"].arrayValue
            print(datas)
            LocalData.sysInfo = [SystemInfo]()
            for one in datas{
                let newInfo = SystemInfo()
                if one["ReadTime"].stringValue == "nul"{
                    LocalData.UnreadNum++
                }
                newInfo.feedId = one["fromFeed"].stringValue
                newInfo.fromUid = one["uid"].stringValue
                newInfo.infoid = one["id"].stringValue
                newInfo.Message = one["infodetail"].stringValue
                newInfo.otherhidename = one["commentname"].stringValue
                newInfo.Times = one["SaveTime"].stringValue
                newInfo.ReadTime = one["ReadTime"].stringValue
                newInfo.Commentid = one["commentid"].stringValue
                newInfo.countHight()
                LocalData.sysInfo.append(newInfo)
            }
            if LocalData.UnreadNum != 0{
                self.messageNumLableL.alpha = 1
                self.messageNumLableL.text = "\(LocalData.UnreadNum)"
            }else{
                self.messageNumLableL.alpha = 0
            }
            
        })
    }
    func hideMessage(){
        SystemInfoUpdate()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "gotoFeedDetil", object: nil)
        mesback.removeFromSuperview()
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
