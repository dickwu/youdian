//
//  baseMessage.swift
//  Udian
//
//  Created by farmerwu_pc on 15/7/11.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class baseMessage: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,UITextFieldDelegate{
    let allFrame = UIScreen.mainScreen().applicationFrame
    @IBOutlet weak var position: NSLayoutConstraint!
    @IBOutlet weak var headPic: UIImageView!
    var AreUpload = false
    
    @IBOutlet weak var back1: UILabel!
    @IBOutlet weak var back2: UILabel!
    @IBOutlet weak var back3: UILabel!
    
    
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var Sex: UITextField!
    @IBOutlet weak var birthDay: UITextField!
    
    @IBOutlet weak var NextBut: UIButton!
    
    let PicProcess = DACircularProgressView()
    //检查
    var checkRes = [false,false,false,false]
    
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
        
        back3.layer.masksToBounds = true
        back3.layer.cornerRadius = 4
        back3.layer.borderColor = UIColor.lightGrayColor().CGColor
        back3.layer.borderWidth = 1
        
        NextBut.layer.masksToBounds = true
        NextBut.layer.cornerRadius = 6
        setBack()
        headPic.layer.cornerRadius = 50
        headPic.layer.masksToBounds = true
        Sex.enabled = false
        birthDay.enabled = false
        MobClick.event("SetPasswordNextBtnClicked")
        

    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func viewWillAppear(animated: Bool) {
        check()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
        birthPicker.date = "1992-01-01".toDate()!
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
                
        })
        manSelect.image = UIImage(named: "选项(已选)")
        famaleSelect.image = UIImage(named: "选项(未选)")
        Sex.text = "男"
        checkRes[2] = true
        self.check()
    }
    func changeFamale(){
        famaleBut.enabled = false
        manBut.enabled = true
        UIButton.animateWithDuration(0.2, animations: { () -> Void in
            self.famaleBut.frame = CGRect(x: self.allFrame.width/4*3 - 30, y: self.allFrame.height - 160, width: 60, height: 60)
            self.famaleBut.setBackgroundImage(UIImage(named: "选项B按钮（已选）"), forState: UIControlState.Normal)
            }, completion: { (Bool) -> Void in
                
        })
        UIButton.animateWithDuration(0.2, animations: { () -> Void in
            self.manBut.frame = CGRect(x: self.allFrame.width/4 - 30, y: self.allFrame.height - 150, width: 60, height: 60)
            self.manBut.setBackgroundImage(UIImage(named: "选项A按钮（未选）"), forState: UIControlState.Normal)
            }, completion: { (Bool) -> Void in
                
        })
        famaleSelect.image = UIImage(named: "选项(已选)")
        manSelect.image = UIImage(named: "选项(未选)")
        Sex.text = "女"
        checkRes[2] = true
        self.check()
    }
    func conform(){
        hideBack()
        
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
            }
            position.constant = 0
            setBack()
        }
    }
    @IBAction func changeSex() {
        nickName.resignFirstResponder()
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
        
        UILabel.animateWithDuration(0.5, animations: { () -> Void in
            self.Sexback.frame = CGRect(x: 0, y: self.allFrame.height-180, width: self.allFrame.width, height: 200)
            self.manLable.frame = CGRect(x: self.allFrame.width/4.0 - 20 , y:self.allFrame.height - 82, width: 40, height: 22)
            self.famaleLable.frame = CGRect(x: self.allFrame.width/4.0*3 - 20 , y:self.allFrame.height - 82, width: 40, height: 22)
            }) { (Bool) -> Void in
                if self.Sex.text == ""{
                    self.changeMan()
                }
                
        }
        UIImageView.animateWithDuration(0.5, animations: { () -> Void in
            self.manSelect.frame = CGRect(x: self.allFrame.width/4.0 - 5 , y:self.allFrame.height - 52, width: 10, height: 10)
            self.famaleSelect.frame = CGRect(x: self.allFrame.width/4.0*3 - 5 , y:self.allFrame.height - 52, width: 10, height: 10)
            }) { (Bool) -> Void in
                
        }
        UIButton.animateWithDuration(0.5, animations: { () -> Void in
            self.manBut.frame = CGRect(x: self.allFrame.width/4.0 - 30 , y:self.allFrame.height - 150, width: 60, height: 60)
            self.famaleBut.frame = CGRect(x: self.allFrame.width/4*3 - 30 , y:self.allFrame.height - 150, width: 60, height: 60)
            self.confiremBut.frame = CGRect(x: 0, y: self.allFrame.height-30, width: self.allFrame.width, height: 50)
            }) { (Bool) -> Void in
                
        }
        
    }
    
    //修改生日
    @IBAction func changeBirth() {
        nickName.resignFirstResponder()
        showBirth()
    }
    func showBirth(){
        self.view.addSubview(background)
        self.view.addSubview(Sexback)
        self.view.addSubview(birthPicker)
        self.view.addSubview(confiremBut)
        position.constant = -50
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
    //生日日期选择
    func handleData(sender: UIDatePicker){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let text = dateFormatter.stringFromDate(sender.date)
        birthDay.text = text
        //print(text)
        checkRes[3] = true
        self.check()
    }
    
    
    func check(){
        print(checkRes)
        if checkRes[0]&&checkRes[1]&&checkRes[2]&&checkRes[3]{
            NextBut.enabled = true
            NextBut.backgroundColor = UIColor.blackColor()
        }else{
            NextBut.enabled = false
            NextBut.backgroundColor = UIColor.lightGrayColor()
        }
    }
    
    //完成
    @IBAction func GoNext() {
        NextBut.enabled = false
        NextBut.backgroundColor = UIColor.lightGrayColor()
        NextBut.setTitle("注册中", forState: UIControlState.Normal)
        MobClick.event("CompletBtnClicked")
        APIPOST.addnewone(LocalData.KeepUserid, pwd: LocalData.KeepPass.sha512()!.uppercaseString, nickname: nickName.text!, headphoto: LocalData.KeepuserPic, birthday: birthDay.text!, gender: Sex.text!) { (res, err) -> Void in
            if res{
                //注册成功
                LocalData.userid = LocalData.KeepUserid
                LocalData.userPWD = LocalData.KeepPass
                LocalData.SuserPWD = LocalData.userPWD.sha512()!.uppercaseString
                self.disShow()
                APIPOST.UserLogin { (res, err) -> Void in
                    print(res)
                    APIPOST.UpdateUserInfo(LocalData.uid, com: { (res) -> Void in
                        
                    })
                }
                self.errorMessage("提示", info: "注册成功")
                
            }else{
                //注册失败
                self.errorMessage("提示", info: "注册失败\n请重试")
                self.NextBut.enabled = true
                self.NextBut.backgroundColor = UIColor.blackColor()
                self.NextBut.setTitle("完善设置", forState: UIControlState.Normal)
            }
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        hideBack()
        position.constant = -64
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if nickName.text! != ""{
            checkNickName()
        }else{
            self.checkRes[1] = false
            self.check()
        }
        return true
    }
    @IBAction func clear(sender: AnyObject) {
        hideBack()
        nickName.resignFirstResponder()
        position.constant = 0
    }

    func checkNickName(){
        //昵称检查
        APIPOST.checkNick(nickName.text!, com: { (res) -> Void in
            if res{
                self.checkRes[1] = false
                self.check()
                self.errorMessage("提示", info: "昵称重复了\n不就一个昵称吗？\n敢不敢再个性一点！")
            }else{
                self.checkRes[1] = true
                self.check()
            }
            }) { (res) -> Void in
                
        }
        
    }
    
    //上传头像
    @IBAction func uploadPIc(sender: AnyObject) {
        hideBack()
        let action = UIAlertController(title: "更新头像", message: "选取本地图库图片更新头像,如有权限提醒请通过", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let op0 = UIAlertAction(title: "从相册中选取", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!)in (self.choicelocal())})
        //let op1 = UIAlertAction(title: "拍照选取", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!)in (self.takephoto())})
        let opend = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {(actionSheet: UIAlertAction!)in (print("Cancel"))})
        //action.addAction(op1)
        action.addAction(op0)
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
    //选取并上传图片
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]){
        let selectedImage : UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        print("头像赋值")
        self.headPic.image = selectedImage
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd/mm/ss"
        let text = dateFormatter.stringFromDate(NSDate())
        let picName = (LocalData.userid + text).sha1()!
        self.PicProcess.frame = CGRect(x: 30, y: 30, width: 40, height: 40)
        self.headPic.addSubview(PicProcess)
        SPic.uploadPicWithPro(picName, Pic: self.headPic.image!, com: { (succsess, res) -> Void in
            
            
            }) { (pro) -> Void in
                print(pro)
                
                self.PicProcess.progressTintColor = UIColor(red: 125/255, green: 236/255, blue: 1, alpha: 1)
                self.PicProcess.trackTintColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
                self.PicProcess.setProgress(pro, animated: true)
                if pro == 1.0{
                    LocalData.KeepuserPic = Connect.picMain + picName + ".png"
                    self.PicProcess.removeFromSuperview()
                    self.checkRes[0] = true
                    self.check()
                }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    @IBAction func back() {
        hideBack()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
}
