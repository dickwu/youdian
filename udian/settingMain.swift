//
//  settingMain.swift
//  Udian
//
//  Created by farmerwu_pc on 15/8/17.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class settingMain: UIViewController {
    
    let nowFrame = UIScreen.mainScreen().applicationFrame
    @IBOutlet weak var messageNum: UILabel!

    
    //--------------------------------------
    //消息
    let Mes = UITableView()
    let mesback = UIButton()
    let data = MeaageData()
    var canload = true
    
    
    var share = ShareView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messageNum.layer.masksToBounds = true
        messageNum.layer.cornerRadius = 7
        
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        SystemInfoUpdate()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SystemInfoUpdate", name: "SystemInfoUpdate", object: nil)
        //hideShare
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideshare", name: "hideShare", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushTofeed", name: "PushJump", object: nil)
    }
    override func viewDidAppear(animated: Bool) {
        if canload{
            load()
            loadQuite()
            loadmore()
            loadThree()
            loadVersion()
            canload = false
        }
    }
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver("gotoFeedDetil", name: "gotoFeedDetil", object: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        for one in view.subviews{
            if one.tag == 4600{
                one.removeFromSuperview()
            }
        }
        loadQuite()
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver("gotoFeedDetil", name: "gotoFeedDetil", object: nil)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func load(){
        let backgrond = UIImageView(frame: CGRect(x: 8, y: 72, width: nowFrame.width - 16, height:  nowFrame.width/4 + 16))
        backgrond.backgroundColor = UIColor.whiteColor()
        backgrond.layer.cornerRadius = 4
        backgrond.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
        backgrond.layer.borderWidth = 1
        backgrond.layer.shadowColor = UIColor.lightGrayColor().CGColor
        backgrond.layer.shadowOffset = CGSizeMake(1.25, 1.25)
        backgrond.layer.shadowOpacity = 1
        backgrond.layer.shadowRadius = 0
        let head = UIImageView(frame: CGRect(x: nowFrame.width*7/16 - 12 , y: 8, width: nowFrame.width/8 + 8, height: nowFrame.width/8 + 8))
        head.image = UIImage(named: "个人设置触发按钮")
        backgrond.addSubview(head)
        let headText = UILabel(frame: CGRect(x: nowFrame.width*7/16 - 30, y: nowFrame.width/8 + 24, width: nowFrame.width/8 + 44, height: 20))
        headText.text = "个人设置"
        headText.textAlignment = .Center
        backgrond.addSubview(headText)
        let goSet = UIButton(frame: CGRect(x: 8, y: 72, width: nowFrame.width - 16, height:  nowFrame.width/4 + 16))
        goSet.addTarget(self, action: "goset", forControlEvents: UIControlEvents.TouchUpInside)
        
        let explainL = UILabel(frame: CGRect(x: 8, y: nowFrame.width/4 + 94, width: nowFrame.width - 16, height: 40))
        explainL.textColor = UIColor.lightGrayColor()
        explainL.font = UIFont.systemFontOfSize(13)
        explainL.numberOfLines = 0
        explainL.text = "在 ”个人设置“ 里，你可以个性化你的头像，签名，及其他一切与你个人相关的属性"
        explainL.textAlignment = .Center
        self.view.addSubview(backgrond)
        self.view.addSubview(explainL)
        self.view.addSubview(goSet)
    }
    func loadmore(){
        //设置绑定按钮
        let twoWidth = (nowFrame.width - 8)/4
        let oneWidth:CGFloat = (nowFrame.width - 8)/3
        var twoExplains = [""]
        if LocalData.AreOpenSound{
            twoExplains = ["关闭声音","修改密码","给我们打分","分享给朋友"]
        }else{
            twoExplains = ["打开声音","修改密码","给我们打分","分享给朋友"]
        }
        for i in 0...3{
            let ii = CGFloat(i)
            let Oneback = UIImageView(frame: CGRect(x: twoWidth*ii + 8, y: 116 + oneWidth , width: twoWidth - 8, height: twoWidth - 8))
            Oneback.backgroundColor = UIColor.whiteColor()
            Oneback.layer.cornerRadius = 8
            Oneback.layer.borderWidth = 1
            Oneback.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
            Oneback.layer.shadowColor = UIColor.lightGrayColor().CGColor
            Oneback.layer.shadowOffset = CGSizeMake(1.25, 1.25)
            Oneback.layer.shadowOpacity = 1
            Oneback.layer.shadowRadius = 0
            Oneback.tag = 200 + i
            let oneImage = UIImageView(frame: CGRect(x: twoWidth/4 - 4  , y: 8, width: twoWidth/2, height: twoWidth/2))
            if i == 0 {
                if !LocalData.AreOpenSound{
                    oneImage.image = UIImage(named: "设置触发\(i+1)-2")
                }else{
                    oneImage.image = UIImage(named: "设置触发\(i+1)")
                }
            }else{
                oneImage.image = UIImage(named: "设置触发\(i+1)")
            }
            
            Oneback.addSubview(oneImage)
            
            let explain = UILabel(frame: CGRect(x: 0, y: twoWidth/2 + 10 , width: twoWidth - 8, height: 20))
            explain.font = UIFont.systemFontOfSize(13)
            explain.textColor = UIColor.darkGrayColor()
            explain.text = twoExplains[i]
            explain.textAlignment = .Center
            explain.tag = 300 + i
            Oneback.addSubview(explain)
            
            let goBut = UIButton(frame: CGRect(x: twoWidth*ii + 8, y: 116 + oneWidth , width: twoWidth - 8, height: twoWidth - 8))
            goBut.tag = 101 + i
            goBut.addTarget(self, action: "boundOthers:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(Oneback)
            self.view.addSubview(goBut)
        }
            }
    
    func loadThree(){
        //设置绑定按钮
        let twoWidth = (nowFrame.width - 8)/4
        let oneWidth:CGFloat = (nowFrame.width - 8)/3
        let threExplains = ["意见反馈","用户协议","关于优点"]
        for i in 0...2{
            let ii = CGFloat(i)
            let Oneback = UIImageView(frame: CGRect(x: twoWidth*ii + 8, y: 120 + oneWidth + twoWidth, width: twoWidth - 8, height: twoWidth - 8))
            Oneback.backgroundColor = UIColor.whiteColor()
            Oneback.layer.cornerRadius = 8
            Oneback.layer.borderWidth = 1
            Oneback.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
            Oneback.layer.shadowColor = UIColor.lightGrayColor().CGColor
            Oneback.layer.shadowOffset = CGSizeMake(1.25, 1.25)
            Oneback.layer.shadowOpacity = 1
            Oneback.layer.shadowRadius = 0
            Oneback.tag = 400+i
            let oneImage = UIImageView(frame: CGRect(x: twoWidth/4 - 4  , y: 8, width: twoWidth/2, height: twoWidth/2))
            oneImage.image = UIImage(named: "设置触发按\(i+1)")
            Oneback.addSubview(oneImage)
            
            let explain = UILabel(frame: CGRect(x: 0, y: twoWidth/2 + 10 , width: twoWidth - 8, height: 20))
            explain.font = UIFont.systemFontOfSize(13)
            explain.textColor = UIColor.darkGrayColor()
            explain.text = threExplains[i]
            explain.textAlignment = .Center
            Oneback.addSubview(explain)
            
            let goBut = UIButton(frame: CGRect(x: twoWidth*ii + 8, y: 120 + oneWidth + twoWidth , width: twoWidth - 8, height: twoWidth - 8))
            goBut.tag = 105 + i
            goBut.addTarget(self, action: "boundOthers:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(Oneback)
            self.view.addSubview(goBut)
        }

    }
    func loadQuite(){
        let goBut = UIButton(frame: CGRect(x: 8, y: nowFrame.height - 50 , width: nowFrame.width - 16 , height: 40))
        goBut.backgroundColor = UIColor(red: 153/255, green: 151/255, blue: 151/255, alpha: 1)
        goBut.tag = 4600
        goBut.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        goBut.titleLabel!.font = UIFont.boldSystemFontOfSize(17)
        goBut.layer.cornerRadius = 4
        if LocalData.SuserPWD != ""{
            goBut.setTitle("退出登录", forState: UIControlState.Normal)
            goBut.addTarget(self, action: "quiteCount", forControlEvents: UIControlEvents.TouchUpInside)
        }else{
            goBut.setTitle("登录", forState: UIControlState.Normal)
            goBut.addTarget(self, action: "backtoLogin", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        self.view.addSubview(goBut)
    }
    func loadVersion(){
        let version = UILabel(frame: CGRect(x: 8, y: nowFrame.height - 6, width: nowFrame.width - 16, height: 20))
        version.text = "全民优点 V1.0"
        version.textColor = UIColor.lightGrayColor()
        version.font = UIFont.systemFontOfSize(12)
        version.textAlignment = .Center
        self.view.addSubview(version)
    }
    
    func quiteCount(){
        checkLogin { (res) -> Void in
            if res{
                let alertController = UIAlertController(title: "确认注销", message: "注销以后将把保存在本地的密码清空", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {(actionSheet: UIAlertAction!)in (self.cancelAction())})
                let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler:  {(actionSheet: UIAlertAction!)in (self.okAction())})
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
    }
    func okAction(){
        self.backtoLogin()
    }
    func cancelAction(){
        
    }

    
    func boundOthers(sender:UIButton){
        print(sender.tag)
        let row = sender.tag - 100
        switch row{
            case 1:
                if LocalData.AreOpenSound {
                    LocalData.AreOpenSound = false
                    let types:UIUserNotificationType = [.Alert, .Badge]
                    let setting = UIUserNotificationSettings(forTypes: types, categories: nil)
                    UIApplication.sharedApplication().registerUserNotificationSettings(setting)
                }else{
                    LocalData.AreOpenSound = true
                    let types:UIUserNotificationType = [.Alert, .Badge, .Sound]
                    let setting = UIUserNotificationSettings(forTypes: types, categories: nil)
                    UIApplication.sharedApplication().registerUserNotificationSettings(setting)
                }
                
            reloadData()
            case 2:
                checkLogin { (res) -> Void in
                    if res{
                        let story = UIStoryboard(name: "Main", bundle: nil)//获取故事版
                        let filte = story.instantiateViewControllerWithIdentifier("PassNew") as! PassNew//定位视图
                        self.navigationController?.pushViewController(filte, animated: true)
                    }
            }
            case 3:
                MobClick.event("ScoringBtn")
                UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/app/1032310386")!)
            case 4:
                if LocalData.CanShowShare{
                    LocalData.CanShowShare = false
                    MobClick.event("RecommendationBtn")
                    share = ShareView(frame: CGRect(x: 0, y: nowFrame.width*0.6, width: nowFrame.width, height: nowFrame.height + 20 ))
                    share.SharePic = "http://7xkb3o.com1.z0.glb.clouddn.com/logo2048LOGO.png"
                    share.ShareTitle = "全民优点 不一样的评论 不一样的观点"
                    share.ShareUrl = "http://www.findkey.com.cn"
                    self.view.addSubview(share)
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.share.frame = CGRect(x: 0, y: 0, width: self.nowFrame.width, height: self.nowFrame.height + 20)
                        }) { (bool) -> Void in
                            LocalData.CanShowShare = true
                    }
                }
            case 5:
                MobClick.event("FeedbackBtn")
                checkLogin({ (res) -> Void in
                    if res{
                        let story = UIStoryboard(name: "Main", bundle: nil)
                        let filte = story.instantiateViewControllerWithIdentifier("feedBack") as! feedBack
                        self.navigationController?.pushViewController(filte, animated: true)
                    }
                })
            case 6:
                //UserProtocol
                let story = UIStoryboard(name: "back", bundle: nil)
                let filte = story.instantiateViewControllerWithIdentifier("UserProtocol") as UIViewController
                //self.tabBarController?.tabBar.hidden = true
                MobClick.event("AgreementBtn")
                self.navigationController?.pushViewController(filte, animated: true)
            case 7:
                let story = UIStoryboard(name: "Main", bundle: nil)
                let filte = story.instantiateViewControllerWithIdentifier("aboutUdian") as! aboutUdian
                //self.tabBarController?.tabBar.hidden = true
                MobClick.event("AboutUsBtn")
                self.navigationController?.pushViewController(filte, animated: true)
        default:break
        }
    }
    
    func reloadData(){
        for one in self.view.subviews{
            if one.tag != 0  && one.tag < 900{
                one.removeFromSuperview()
            }
        }
        loadmore()
        loadThree()
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
            self.messageNum.alpha = 1
            self.messageNum.text = "\(LocalData.UnreadNum)"
        }else{
            self.messageNum.alpha = 0
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
                self.messageNum.alpha = 1
                self.messageNum.text = "\(LocalData.UnreadNum)"
            }else{
                self.messageNum.alpha = 0
            }
            
        })
    }
    func hideMessage(){
        SystemInfoUpdate()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "gotoFeedDetil", object: nil)
        mesback.removeFromSuperview()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func goset(){
        checkLogin { (res) -> Void in
            if res{
                let story = UIStoryboard(name: "Main", bundle: nil)//获取故事版
                let filte = story.instantiateViewControllerWithIdentifier("myinfo") as! myinfo//定位视图
                self.navigationController?.pushViewController(filte, animated: true)
            }
        }
        
    }
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func hideshare(){
        LocalData.CanShowShare = false
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.share.frame = CGRect(x: 0, y: self.nowFrame.width*0.6, width: self.nowFrame.width, height: self.nowFrame.height + 20)
            }) { (bool) -> Void in
                LocalData.CanShowShare = true
                self.share.removeFromSuperview()
                //share.allback.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
        }
    }

}
