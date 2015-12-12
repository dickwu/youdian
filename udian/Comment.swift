//
//  Comment.swift
//  Udian
//
//  Created by farmerwu_pc on 9/4/15.
//  Copyright © 2015 qiuqian. All rights reserved.
//

import UIKit



private class OneComment {
    private let nowFrame = UIScreen.mainScreen().applicationFrame
    var uid = String()//发送人的uid
    var commentID = String()//评论id
    var choicedLine = Int()
    var AreCanShow = Bool()//是否匿名
    var headPic = String()
    var name = String()
    var zanNum = String()
    var AreZan = Bool()
    var time = String()
    var city = String()
    var floorNum = String()
    var CommentText = String()
    var HighforCell = CGFloat()
    var AreNeedLoad = Bool()
    
    
    
    func countHigh(){
        let NSone:NSString = NSString(string: CommentText)
        let oneFrame = NSone.sizeWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(15)])
        HighforCell = (oneFrame.width + nowFrame.width - 100)/(nowFrame.width - 100) * oneFrame.height
        if otheruid != "0"{
            HighforCell += oneFrame.height/2
        }
        
    }
    
    //@功能
    var otheruid = String()
    var otherName = String()
    var fromvoteselect = String()
    
}



class Comment: UIViewController,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate{
    //接口参数
    var AreChoiced = false
    var ChoicedLine = 0
    var feedId = String()
    var CommentTexts = ["","","","",""] //各个投票的标题
    var CommentIDS = [String]()
    var AreNeedToend = false
    
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var hightForKeyboard: NSLayoutConstraint!
    @IBOutlet weak var hightForBack: NSLayoutConstraint!
    @IBOutlet weak var commentText: UITextView!

    
    @IBOutlet weak var numOfNotifiction: UILabel!
    
    @IBOutlet weak var changeAreShowName: UIButton!
    @IBOutlet weak var changeInputBut: UIButton!
    
    
    @IBOutlet weak var placeHolder: UILabel!
    
    var MyName = ""
    var Myhead = ""
    var AreCanSendNew = true//是否可以发送新的
    var AreNeedResent = false
    
    var AreNeedloadMore = false
    var AreNeedloadBefore = false
    
    var AreHaveNewComment = false
    
    
    var AreNotAtGetMore = true
    
    
    
    
    var AreAtOthers = false
    var OtherId = "0"
    var otherName = ""
    var otherhoicedId = ""
    var otherCommentId = ""
    
    var AreShowName = true
    var AreShouldHide = false
    var AreEmoji = true
    let nowFrame = UIScreen.mainScreen().applicationFrame
    var savedhight:CGFloat = 0

    //消息
    let Mes = UITableView()
    let mesback = UIButton()
    let data = MeaageData()
    //-------------------------
    //评论判断
    let backofChoice = UIButton()
    let choicesButs = [UIButton(),UIButton(),UIButton(),UIButton(),UIButton()]
    let choiceTexts = [UILabel(),UILabel(),UILabel(),UILabel(),UILabel()]
    
    let ColorChoiced = [
        UIColor(red: 185/255, green: 88/255, blue: 88/255, alpha: 1),
        UIColor(red: 53/255,  green: 122/255, blue: 153/255, alpha: 1),
        UIColor(red: 120/255, green: 157/255, blue: 63/255,  alpha: 1),
        UIColor(red: 188/255, green: 123/255, blue: 39/255,  alpha: 1),
        UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1)
    ]
    let ColorShow = [
        UIColor(red: 253/255, green: 140/255, blue: 103/255, alpha: 1),
        UIColor(red: 44/255,  green: 152/255, blue: 201/255, alpha: 1),
        UIColor(red: 149/255, green: 204/255, blue: 61/255,  alpha: 1),
        UIColor(red: 253/255, green: 154/255, blue: 26/255,  alpha: 1),
        UIColor(red: 149/255, green: 149/255, blue: 149/255, alpha: 1)
    ]
    //评论数据


    private var comments = [OneComment]()
    private var Mycomments = [OneComment]()
    let activityMore = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    //保存的line用于举报
    var SavedLine = Int()
    var AreNeedGetNew = true
    var OtherAlert = UIAlertView()
    var AreNeedJumpToCell = false
    
    

    override func viewWillAppear(animated: Bool) {
        
        self.table.reloadData()
        
        if FeedbaseData.getsavedCommentid(feedId) == "-1"{
            updatedata()
        }else{
            JumpGetData()
        }
        
        NSNotificationCenter.defaultCenter().removeObserver("gotoFeedDetil", name: "gotoFeedDetil", object: nil)
        MobClick.beginLogPageView("评论页")
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver("gotoFeedDetil", name: "gotoFeedDetil", object: nil)
        MobClick.endLogPageView("评论页")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showKeyBoard:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideKeyBoard:", name: UIKeyboardWillHideNotification, object: nil)
        
        commentText.layer.cornerRadius = 6
        numOfNotifiction.layer.masksToBounds = true
        numOfNotifiction.layer.cornerRadius = 7
        
        backofChoice.addTarget(self, action: "hideChoice", forControlEvents: UIControlEvents.TouchUpInside)
        if AreChoiced{
            if ChoicedLine == CommentTexts.count - 1{
                commentText.layer.borderColor = ColorShow[4].CGColor
            }else{
                commentText.layer.borderColor = ColorShow[ChoicedLine].CGColor
            }
        }
        table.scrollsToTop = true
        //去空行
        let tblView =  UIView(frame: CGRect(x: 0, y: 0, width: nowFrame.width + 20, height: 12))
        self.table.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        self.table.tableFooterView = tblView
        //去中间间隔线
        self.table.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //多手势响应
        table.userInteractionEnabled = true
        //长按手势
        let LongTouchGesture = UILongPressGestureRecognizer(target: self, action: "showReport:")
        LongTouchGesture.minimumPressDuration = 0.5
        LongTouchGesture.delegate = self
        self.view.addGestureRecognizer(LongTouchGesture)
        //优先点击手势

        //手势返回
        let backGesture = UISwipeGestureRecognizer()
        backGesture.direction = .Right
        backGesture.addTarget(self, action: "swipeback:")
        backGesture.delegate = self
        self.table.addGestureRecognizer(backGesture)
        
        if AreChoiced{
            commentText.layer.borderWidth = 3
            if ChoicedLine == CommentTexts.count - 1{
                commentText.layer.borderColor = ColorShow[4].CGColor
            }else{
                commentText.layer.borderColor = ColorShow[ChoicedLine].CGColor
            }
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "commentFeed", name: "comment", object: nil)
        //delele
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deleleText", name: "deleleCommentText", object: nil)
        
        placeHolder.layer.cornerRadius = 6
        placeHolder.layer.masksToBounds = true
        placeHolder.text = "  输入你想要评论的内容"
        
        SystemInfoUpdate()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SystemInfoUpdate", name: "SystemInfoUpdate", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushTofeed", name: "PushJump", object: nil)
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "AddRightBar", userInfo: nil, repeats: false)
        
        
    }
    func AddRightBar(){
        //righSideBar.frame =  CGRect(x: nowFrame.width - 12, y: 64, width: nowFrame.width, height: nowFrame.height-94)
        //righSideBar.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        //self.view.addSubview(righSideBar)
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if AreHaveNewComment{
            return 2
        }else{
            return 1
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        print("检测到触碰")
        let point = touch.locationInView(view)
        savedhight = point.y
        //print(savedhight)
        return true
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func showKeyBoard(notification:NSNotification){
        let info = notification.userInfo!
        let keyFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        

        if nowFrame.height - savedhight + 20 < keyFrame.height + 110{
            table.contentOffset.y += keyFrame.height - (nowFrame.height - savedhight + 20) + 90
        }
        
        
        hightForKeyboard.constant = keyFrame.height
        //righSideBar.frame =  CGRect(x: nowFrame.width - 12, y: 64, width: nowFrame.width, height: nowFrame.height-94 - keyFrame.height)
    }
    func hideKeyBoard(notification:NSNotification){
        hightForKeyboard.constant = 0
        
        //righSideBar.frame =  CGRect(x: nowFrame.width - 12, y: 64, width: nowFrame.width, height: nowFrame.height-94)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("获得内存警告")
        // Dispose of any resources that can be recreated.
    }
    //评论主体配置-----------------------------------------------------------------------------------------------
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if AreHaveNewComment{
            //有发评论
            if section == 0{
                //正常评论
                //既有向上也有向下
                if AreNeedloadBefore && AreNeedloadMore{
                    return comments.count + 2
                }else{
                    if AreNeedloadMore || AreNeedloadBefore{
                        return comments.count + 1
                    }else{
                        return comments.count
                    }
                }
                //
                
            }else{
                return Mycomments.count
            }
        }else{
            if AreNeedloadBefore && AreNeedloadMore{
                return comments.count + 2
            }else{
                if AreNeedloadMore || AreNeedloadBefore{
                    return comments.count + 1
                }else{
                    return comments.count
                }
            }
            
            
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if AreHaveNewComment{
            //正常评论部分
            if indexPath.section == 0{
                //既有向上也有向下加载
                if AreNeedloadMore && AreNeedloadBefore{
                    if indexPath.row == 0 || indexPath.row == comments.count + 1{
                        return 60
                    }else{
                        return 80 + comments[indexPath.row - 1].HighforCell
                    }
                }else{
                    //只有向上加载
                    if AreNeedloadBefore{
                        if indexPath.row == 0{
                            return 60
                        }else{
                            return 80 + comments[indexPath.row - 1].HighforCell
                        }
                    }
                    //只有向下加载
                    if AreNeedloadMore{
                        if indexPath.row < comments.count{
                            return 80 + comments[indexPath.row].HighforCell
                        }else{
                            return 60
                        }
                    }
                    //都没有的
                    return 80 +  comments[indexPath.row].HighforCell
                    
                }
            }else{
                //发表评论部分
                return  80 + Mycomments[indexPath.row].HighforCell
            }
        }else{
            //没有评论的情况
            //既有向上也有向下加载
            if AreNeedloadMore && AreNeedloadBefore{
                if indexPath.row == 0 || indexPath.row == comments.count + 1{
                    return 60
                }else{
                    return 80 + comments[indexPath.row - 1].HighforCell
                }
            }else{
                //只有向上加载
                if AreNeedloadBefore{
                    if indexPath.row == 0{
                        return 60
                    }else{
                        return 80 + comments[indexPath.row - 1].HighforCell
                    }
                }
                //只有向下加载
                if AreNeedloadMore{
                    if indexPath.row < comments.count{
                        return 80 + comments[indexPath.row].HighforCell
                    }else{
                        return 60
                    }
                }
                //都没有的
                return 80 +  comments[indexPath.row].HighforCell
                
            }

        }
        
    }
    //删除配置
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        //发表了评论
        if AreHaveNewComment{
            //评论列表区
            if indexPath.section == 0{
                //既有向上也有向下加载
                if AreNeedloadBefore && AreNeedloadMore{
                    if indexPath.row != 0 && indexPath.row != comments.count + 1{
                        return (comments[indexPath.row-1].uid == LocalData.uid)
                    }else{
                        return false
                    }
                }else{
                    if AreNeedloadBefore || AreNeedloadMore{
                        if AreNeedloadBefore{
                            //只有向上加载
                            if indexPath.row == 0{
                                return false
                            }else{
                                return comments[indexPath.row-1].uid == LocalData.uid
                            }
                            
                        }else{
                            //只有向下加载
                            if indexPath.row == comments.count{
                                return comments[indexPath.row].uid == LocalData.uid
                            }else{
                                return false
                            }
                        }
                        
                        
                    }else{
                        return comments[indexPath.row].uid == LocalData.uid
                    }
                }
                
                
            }else{
                //自己发的评论
                return true
            }

        }else{
            
            //没有发表评论
            //既有向上也有向下加载
            if AreNeedloadBefore && AreNeedloadMore{
                if indexPath.row != 0 && indexPath.row != comments.count + 1{
                    return (comments[indexPath.row-1].uid == LocalData.uid)
                }else{
                    return false
                }
            }else{
                if AreNeedloadBefore || AreNeedloadMore{
                    if AreNeedloadMore {
                        //只有向上加载
                        if indexPath.row == 0{
                            return false
                        }else{
                            return comments[indexPath.row-1].uid == LocalData.uid
                        }
                        
                    }else{
                        //只有向下加载
                        
                        if indexPath.row == comments.count{
                            return false
                        }else{
                            return comments[indexPath.row].uid == LocalData.uid
                            
                        }
                    }
                    
                    
                }else{
                    return comments[indexPath.row].uid == LocalData.uid
                }
            }
        }
        
        
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "         "
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //print("删除")
            var row = indexPath.row
            
            if AreNeedloadBefore{
                row = indexPath.row - 1
            }
            
            
            MobClick.event("DeleteCommentClicked")
            if AreHaveNewComment{
                if indexPath.section == 0{
                    APIPOST.DeletcommentInfo(comments[row].commentID, feedid: feedId, position : comments[row].floorNum, com: { (res) -> Void in
                        print(res)
                    })
                    comments.removeAtIndex(row)
                }else{
                    APIPOST.DeletcommentInfo(Mycomments[row].commentID, feedid: feedId, position : Mycomments[row].floorNum, com: { (res) -> Void in
                        print(res)
                    })
                    Mycomments.removeAtIndex(row)
                }
            }else{
                APIPOST.DeletcommentInfo(comments[row].commentID, feedid: feedId, position : comments[row].floorNum, com: { (res) -> Void in
                    print(res)
                })
                comments.removeAtIndex(row)
            }
            
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        if AreHaveNewComment{
            if indexPath.section == 0 {
                //既有向上也有向下
                if AreNeedloadBefore && AreNeedloadMore{
                    if indexPath.row == 0 || indexPath.row == comments.count + 1{
                        cell = MoreLenCell(indexPath.row)
                    }else{
                        cell = NormalCell(indexPath.row - 1)
                    }
                }else{
                    if AreNeedloadBefore{
                        if indexPath.row == 0{
                            cell = MoreLenCell(0)
                        }else{
                            cell = NormalCell(indexPath.row - 1)
                        }
                    }else{
                        if AreNeedloadMore{
                            if indexPath.row == comments.count{
                                cell = MoreLenCell(indexPath.row)
                            }else{
                                cell = NormalCell(indexPath.row)
                            }
                            
                        }else{
                            cell = NormalCell(indexPath.row)
                        }
                    }

                }
                
            }else{
                cell = MycommentCell(indexPath)
            }
        }else{
            //没有评论
            //既有向上也有向下
            if AreNeedloadBefore && AreNeedloadMore{
                if indexPath.row == 0 || indexPath.row == comments.count + 1{
                    cell = MoreLenCell(indexPath.row)
                }else{
                    cell = NormalCell(indexPath.row - 1)
                }
            }else{
                //只有向上
                if AreNeedloadBefore{
                    if indexPath.row == 0{
                        cell = MoreLenCell(0)
                    }else{
                        cell = NormalCell(indexPath.row - 1)
                    }
                }else{
                    //只有向下
                    if AreNeedloadMore{
                        if indexPath.row == comments.count{
                            cell = MoreLenCell(indexPath.row)
                        }else{
                            cell = NormalCell(indexPath.row)
                        }
                    }else{
                        //都没有
                         cell = NormalCell(indexPath.row)
                    }

                }
            }
            
            
            if !AreNeedloadBefore && !AreNeedloadMore{
               
            }
            
        }

        return cell
        
    }
            
            
    func MoreLenCell(row:Int)-> UITableViewCell{
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        if comments.count == 0{
            activityMore.center = CGPoint(x: nowFrame.width/2, y: 30)
            cell.addSubview(activityMore)
            activityMore.startAnimating()
            return cell
        }
        
        if AreHaveNewComment{
            let MoreBut = UIButton(frame: CGRect(x: 0, y: 0, width: nowFrame.width, height: 60))
            MoreBut.setTitle("点击加载更多", forState: UIControlState.Normal)
            if row == 0{
                MoreBut.addTarget(self, action: "addBeforeData", forControlEvents: UIControlEvents.TouchUpInside)
            }else{
                MoreBut.addTarget(self, action: "addMoreData", forControlEvents: UIControlEvents.TouchUpInside)
            }
            cell.addSubview(MoreBut)
            
        }else{
            
            if AreNotAtGetMore{
                AreNotAtGetMore = false
                if row == 0 {
                    addBeforeData()
                }else{
                    
                   addMoreData()
                }
                
            }
            
            activityMore.center = CGPoint(x: nowFrame.width/2, y: 30)
            cell.addSubview(activityMore)
            activityMore.startAnimating()
        }
        return cell
    }
    
    
    func NormalCell(row:Int) -> UITableViewCell{
        let cell = self.table.dequeueReusableCellWithIdentifier("one")!
        let colorback = cell.viewWithTag(10) as! UILabel
        let whiteBack = cell.viewWithTag(11) as! UILabel
        let headPic = cell.viewWithTag(12) as! UIImageView
        let name = cell.viewWithTag(13) as! UILabel
        let atBut = cell.viewWithTag(14) as! UIButton
        let zanNum = cell.viewWithTag(15) as! UILabel
        let zanBut = cell.viewWithTag(16) as! UIButton
        let floorNum = cell.viewWithTag(17) as! UILabel
        let timelable = cell.viewWithTag(18) as! UILabel
        let city = cell.viewWithTag(19) as! UILabel
        let commentTextLable = cell.viewWithTag(20) as! UILabel
        let zanPic = cell.viewWithTag(21) as! UIImageView
        let ReportBut = cell.viewWithTag(50) as! UIButton
        let activity = cell.viewWithTag(60) as! UIActivityIndicatorView
        let ResendPic = cell.viewWithTag(61) as! UIImageView
        let ResendBut = cell.viewWithTag(62) as! UIButton
        for one in cell.subviews{
            if one.tag>300{
                one.removeFromSuperview()
            }
        }
        
        ReportBut.setTitle("\(row)", forState: UIControlState.Normal)
        ReportBut.addTarget(self, action: "SaveLine:", forControlEvents: UIControlEvents.TouchDown)
        
        commentTextLable.text = nil
        
        name.text = comments[row].name
        
        headPic.layer.masksToBounds = true
        headPic.layer.cornerRadius = 23
        SPic.dowmloadPic(comments[row].headPic, proce: { (pro) -> Void in
            
            }, com: { (img) -> Void in
                headPic.image = img
        })
        
        
        if comments[row].AreZan{
            zanPic.image = UIImage(named: "赞图标(已赞)")
        }else{
            zanPic.image = UIImage(named: "赞图标(未赞)")
        }
        let timeDate = comments[row].time
        if timeDate != ""{
            let date = timeDate.toDateTime("yyyy-MM-dd HH:mm:ss")!
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm yyyy-MM-dd"
            let text = dateFormatter.stringFromDate(date)
            timelable.text = text
        }
        city.text = comments[row].city
        atBut.setTitle("\(row)", forState: UIControlState.Normal)
        atBut.removeTarget(self, action: "atMyself", forControlEvents: UIControlEvents.TouchUpInside)
        atBut.addTarget(self, action: "atOther:", forControlEvents: UIControlEvents.TouchUpInside)
        zanBut.setTitle("\(row)", forState: UIControlState.Normal)
        zanBut.addTarget(self, action: "zanOthers:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        colorback.layer.masksToBounds = true
        colorback.layer.cornerRadius = 6
        colorback.layer.shouldRasterize = true
        if comments[row].choicedLine == CommentTexts.count-1{
            colorback.backgroundColor = ColorShow[4]
        }else{
            colorback.backgroundColor = ColorShow[comments[row].choicedLine]
        }
        whiteBack.layer.masksToBounds = true
        whiteBack.layer.cornerRadius = 6
        whiteBack.layer.shouldRasterize = true
        
        
        
        zanNum.text = comments[row].zanNum
        
        floorNum.layer.borderColor = UIColor.darkGrayColor().CGColor
        floorNum.layer.borderWidth = 1
        floorNum.layer.cornerRadius = 4
        floorNum.layer.shouldRasterize = true
        floorNum.layer.masksToBounds = true
        floorNum.textColor = UIColor.darkGrayColor()
        floorNum.numberOfLines = 0
        
        floorNum.text = " \(comments[row].floorNum)楼 "
        
        
        
        
        if comments[row].otheruid != "0" && AreNeedGetNew {
            let name:NSString = comments[row].otherName
            let newcomment:NSString = "@\(name) " + self.comments[row].CommentText
            let attri = NSMutableAttributedString(string: "@\(name) " + self.comments[row].CommentText)
            var attributesForRed:[String:AnyObject] = [
                //  设置字号为60
                NSFontAttributeName:UIFont.boldSystemFontOfSize(15),
                //  设置文本颜色为黄色
                NSForegroundColorAttributeName:self.ColorShow[4]
                
            ]
            
            for i in 0...self.CommentIDS.count-1{
                if self.comments[row].fromvoteselect == self.CommentIDS[i]{
                    if i == self.CommentIDS.count-1{
                        attributesForRed = [
                            //  设置字号为60
                            NSFontAttributeName:UIFont.boldSystemFontOfSize(15),
                            //  设置文本颜色为黄色
                            NSForegroundColorAttributeName:self.ColorShow[4]
                            
                            //NSUnderlineStyleAttributeName:1
                            //  设置背景颜色为蓝色
                            //NSBackgroundColorAttributeName:UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
                        ]
                        
                    }else{
                        attributesForRed = [
                            //  设置字号为60
                            NSFontAttributeName:UIFont.boldSystemFontOfSize(15),
                            //  设置文本颜色为黄色
                            NSForegroundColorAttributeName:self.ColorShow[i]
                            
                            //NSUnderlineStyleAttributeName:1
                            //  设置背景颜色为蓝色
                            //NSBackgroundColorAttributeName:UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
                        ]
                        
                        
                    }
                }
                
                
                attri.setAttributes(attributesForRed, range: newcomment.rangeOfString("@\(name) "))
                commentTextLable.attributedText = attri
                
                
            }
        }else{
            commentTextLable.text = comments[row].CommentText
        }
        
        //删除时的配置
        if LocalData.uid == comments[row].uid{
            let transLable = UILabel(frame: CGRect(x: nowFrame.width, y: 0, width: 4, height: comments[row].HighforCell + 80))
            transLable.tag = 400
            transLable.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
            transLable.layer.borderWidth = 0.6
            transLable.layer.borderColor =  UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1).CGColor
            let deleback = UILabel(frame: CGRect(x: nowFrame.width + 4, y: 0, width: nowFrame.width, height: comments[row].HighforCell + 80))
            deleback.tag = 500
            deleback.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
            deleback.layer.borderWidth = 0.6
            deleback.layer.borderColor =  UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1).CGColor
            let deleBut = UIButton(frame: CGRect(x: nowFrame.width - 4 , y: 8, width: 500, height: comments[row].HighforCell + 72))
            deleBut.tag = 501
            let deleImage = UIImageView(frame: CGRect(x: nowFrame.width + 8, y: comments[row].HighforCell/2 + 23, width: 34, height: 34))
            deleImage.tag = 502
            deleImage.image = UIImage(named: "删除图标")
            deleBut.backgroundColor = UIColor(red: 134/255, green: 135/255, blue: 136/255, alpha: 1)
            deleBut.layer.masksToBounds = true
            deleBut.layer.cornerRadius = 6
            cell.addSubview(transLable)
            cell.addSubview(deleback)
            cell.addSubview(deleBut)
            cell.addSubview(deleImage)
        }
        //加载中的处理
        ResendBut.enabled = false
        ResendPic.alpha = 0
        floorNum.alpha = 1
        zanNum.alpha = 1
        activity.alpha = 0
        
        FeedbaseData.saveFeedinfo(feedId, comment: comments[row].floorNum)
        
        return cell

    }
    
    func MycommentCell(indexPath:NSIndexPath) -> UITableViewCell{
        let cell = self.table.dequeueReusableCellWithIdentifier("one")!
        let row = indexPath.row
        let colorback = cell.viewWithTag(10) as! UILabel
        let whiteBack = cell.viewWithTag(11) as! UILabel
        let headPic = cell.viewWithTag(12) as! UIImageView
        let name = cell.viewWithTag(13) as! UILabel
        let atBut = cell.viewWithTag(14) as! UIButton
        let zanNum = cell.viewWithTag(15) as! UILabel
        let zanBut = cell.viewWithTag(16) as! UIButton
        let floorNum = cell.viewWithTag(17) as! UILabel
        let timelable = cell.viewWithTag(18) as! UILabel
        let city = cell.viewWithTag(19) as! UILabel
        let commentTextLable = cell.viewWithTag(20) as! UILabel
        let zanPic = cell.viewWithTag(21) as! UIImageView
        let ReportBut = cell.viewWithTag(50) as! UIButton
        let activity = cell.viewWithTag(60) as! UIActivityIndicatorView
        let ResendPic = cell.viewWithTag(61) as! UIImageView
        let ResendBut = cell.viewWithTag(62) as! UIButton
        for one in cell.subviews{
            if one.tag>300{
                one.removeFromSuperview()
            }
        }
        
        ReportBut.setTitle("-1", forState: UIControlState.Normal)
        ReportBut.addTarget(self, action: "SaveLine:", forControlEvents: UIControlEvents.TouchDown)
        
        commentTextLable.text = nil
        
        name.text = Mycomments[row].name
        
        headPic.layer.masksToBounds = true
        headPic.layer.cornerRadius = 23
        SPic.dowmloadPic(Mycomments[row].headPic, proce: { (pro) -> Void in
            
            }, com: { (img) -> Void in
                headPic.image = img
        })
        
        
        if Mycomments[row].AreZan{
            zanPic.image = UIImage(named: "赞图标(已赞)")
        }else{
            zanPic.image = UIImage(named: "赞图标(未赞)")
        }
        let timeDate = Mycomments[row].time
        if timeDate != ""{
            let date = timeDate.toDateTime("yyyy-MM-dd HH:mm:ss")!
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm yyyy-MM-dd"
            let text = dateFormatter.stringFromDate(date)
            timelable.text = text
        }
        city.text = Mycomments[row].city
        atBut.setTitle("\(row)", forState: UIControlState.Normal)
        atBut.removeTarget(self, action: "atOther", forControlEvents: UIControlEvents.TouchUpInside)
        atBut.addTarget(self, action: "atMyself:", forControlEvents: UIControlEvents.TouchUpInside)
        
        zanBut.setTitle("\(row)", forState: UIControlState.Normal)
        zanBut.addTarget(self, action: "zanMyself:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        colorback.layer.masksToBounds = true
        colorback.layer.cornerRadius = 6
        colorback.layer.shouldRasterize = true
        if Mycomments[row].choicedLine == CommentTexts.count-1{
            colorback.backgroundColor = ColorShow[4]
        }else{
            colorback.backgroundColor = ColorShow[Mycomments[row].choicedLine]
        }
        whiteBack.layer.masksToBounds = true
        whiteBack.layer.cornerRadius = 6
        whiteBack.layer.shouldRasterize = true
        
        
        
        zanNum.text = Mycomments[row].zanNum
        
        floorNum.layer.borderColor = UIColor.darkGrayColor().CGColor
        floorNum.layer.borderWidth = 1
        floorNum.layer.cornerRadius = 4
        floorNum.layer.shouldRasterize = true
        floorNum.layer.masksToBounds = true
        floorNum.textColor = UIColor.darkGrayColor()
        floorNum.numberOfLines = 0
        
        floorNum.text = " \(Mycomments[row].floorNum)楼 "
        
        
        
        
        if Mycomments[row].otheruid != "0" && AreNeedGetNew {
            let name:NSString = Mycomments[row].otherName
            let newcomment:NSString = "@\(name) " + self.Mycomments[row].CommentText
            let attri = NSMutableAttributedString(string: "@\(name) " + self.Mycomments[row].CommentText)
            var attributesForRed:[String:AnyObject] = [
                //  设置字号为60
                NSFontAttributeName:UIFont.boldSystemFontOfSize(15),
                //  设置文本颜色为黄色
                NSForegroundColorAttributeName:self.ColorShow[4]
                
            ]
            
            for i in 0...self.CommentIDS.count-1{
                if self.Mycomments[row].fromvoteselect == self.CommentIDS[i]{
                    if i == self.CommentIDS.count-1{
                        attributesForRed = [
                            //  设置字号为60
                            NSFontAttributeName:UIFont.boldSystemFontOfSize(15),
                            //  设置文本颜色为黄色
                            NSForegroundColorAttributeName:self.ColorShow[4]
                            
                            //NSUnderlineStyleAttributeName:1
                            //  设置背景颜色为蓝色
                            //NSBackgroundColorAttributeName:UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
                        ]
                        
                    }else{
                        attributesForRed = [
                            //  设置字号为60
                            NSFontAttributeName:UIFont.boldSystemFontOfSize(15),
                            //  设置文本颜色为黄色
                            NSForegroundColorAttributeName:self.ColorShow[i]
                            
                            //NSUnderlineStyleAttributeName:1
                            //  设置背景颜色为蓝色
                            //NSBackgroundColorAttributeName:UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
                        ]
                        
                        
                    }
                }
                
                
                attri.setAttributes(attributesForRed, range: newcomment.rangeOfString("@\(name) "))
                commentTextLable.attributedText = attri
                
                
            }
        }else{
            commentTextLable.text = Mycomments[row].CommentText
        }
        
        //删除时的配置
        if LocalData.uid == Mycomments[row].uid{
            let transLable = UILabel(frame: CGRect(x: nowFrame.width, y: 0, width: 4, height: Mycomments[row].HighforCell + 80))
            transLable.tag = 400
            transLable.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
            transLable.layer.borderWidth = 0.6
            transLable.layer.borderColor =  UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1).CGColor
            let deleback = UILabel(frame: CGRect(x: nowFrame.width + 4, y: 0, width: nowFrame.width, height: Mycomments[row].HighforCell + 80))
            deleback.tag = 500
            deleback.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
            deleback.layer.borderWidth = 0.6
            deleback.layer.borderColor =  UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1).CGColor
            let deleBut = UIButton(frame: CGRect(x: nowFrame.width - 4 , y: 8, width: 500, height: Mycomments[row].HighforCell + 72))
            deleBut.tag = 501
            let deleImage = UIImageView(frame: CGRect(x: nowFrame.width + 8, y: Mycomments[row].HighforCell/2 + 23, width: 34, height: 34))
            deleImage.tag = 502
            deleImage.image = UIImage(named: "删除图标")
            deleBut.backgroundColor = UIColor(red: 134/255, green: 135/255, blue: 136/255, alpha: 1)
            deleBut.layer.masksToBounds = true
            deleBut.layer.cornerRadius = 6
            cell.addSubview(transLable)
            cell.addSubview(deleback)
            cell.addSubview(deleBut)
            cell.addSubview(deleImage)
        }
        //加载中的处理
        if Mycomments[row].AreNeedLoad{
            floorNum.alpha = 0
            zanNum.alpha = 0
            zanBut.enabled = false
            atBut.enabled = false
            
            if AreNeedResent{
                activity.alpha = 0
                ResendPic.alpha = 1
                ResendBut.enabled = true
                ResendBut.addTarget(self, action: "reSentComment", forControlEvents: UIControlEvents.TouchUpInside)
            }else{
                activity.alpha = 1
                ResendPic.alpha = 0
                ResendBut.enabled = false
                activity.startAnimating()
            }
            
            
        }else{
            ResendBut.enabled = false
            ResendPic.alpha = 0
            floorNum.alpha = 1
            zanNum.alpha = 1
            activity.alpha = 0
            atBut.enabled = true
            zanBut.enabled = true
        }
        
        return cell

    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func changeAreShow(sender: UIButton) {
        checkLogin { (res) -> Void in
            if res{
                if self.AreShowName{
                    self.AreShowName = false
                    self.changeAreShowName.setImage(UIImage(named: "实名匿名按钮2"), forState: UIControlState.Normal)
                    print("匿名")
                    if self.MyName == "" || self.Myhead == LocalData.userPic{
                        APIPOST.CommentNoName(self.feedId, com: { (res) -> Void in
                            print(res)
                            let data = res["data"]
                            self.MyName = data["randname"].stringValue
                            self.Myhead = data["randavatar"].stringValue
                        })
                    }
                    
                    
                }else{
                    self.AreShowName = true
                    self.Myhead = LocalData.userPic
                    self.MyName = LocalData.userNick
                    self.changeAreShowName.setImage(UIImage(named: "实名匿名按钮1"), forState: UIControlState.Normal)
                }
            }
        }
        
    }

    
    @IBAction func changeInputType(sender: AnyObject) {
        commentText.resignFirstResponder()
        if AreEmoji{
            changeInputBut.setImage(UIImage(named: "输入按钮文字"), forState: UIControlState.Normal)
            let emojikey = emojiKeyboard(frame: CGRect(x: 0, y: 0, width: self.table.frame.width, height: 200))
            commentText.inputView = emojikey
            emojikey.EmojiInputview = commentText
            emojikey.EmojiInputview.delegate = self
            emojikey.FeedId = feedId
            emojikey.placeHolder = self.placeHolder
            AreEmoji = false    
        }else{
            changeInputBut.setImage(UIImage(named: "输入按钮表情"), forState: UIControlState.Normal)
            commentText.inputView = nil
            AreEmoji = true
        }
        commentText.becomeFirstResponder()
    }
    
    
    @IBAction func showSystemInfo(sender: AnyObject) {
        commentText.resignFirstResponder()
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
                    //print(datas)
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
                        newInfo.ReadTime = one["ReadTime"].stringValue
                        newInfo.Commentid = one["commentid"].stringValue
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
            self.numOfNotifiction.alpha = 1
            self.numOfNotifiction.text = "\(LocalData.UnreadNum)"
        }else{
            self.numOfNotifiction.alpha = 0
        }
        APIPOST.SystemInfoList({ (res) -> Void in
            LocalData.UnreadNum = 0
            let datas = JSON(res)["data"].arrayValue
            //print(datas)
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
                self.numOfNotifiction.alpha = 1
                self.numOfNotifiction.text = "\(LocalData.UnreadNum)"
            }else{
                self.numOfNotifiction.alpha = 0
            }
            
        })
    }

    func hideMessage(){
        mesback.removeFromSuperview()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "gotoFeedDetil", object: nil)
        Mes.removeFromSuperview()
    }
    //-----------------------------
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        if !AreChoiced{
           showDiffrentChoice()
        }else{
            if AreCanSendNew{
            commentText.layer.borderWidth = 3
            if ChoicedLine == CommentTexts.count - 1{
                commentText.layer.borderColor = ColorShow[4].CGColor
            }else{
                commentText.layer.borderColor = ColorShow[ChoicedLine].CGColor
                }
            }else{
                self.errorMessage("提示", info: "还有未成功发送的信息")
            }
        }
        return AreChoiced && AreCanSendNew
    }
    func hideChoice(){
        for i in 0...CommentTexts.count-1{
            choicesButs[i].removeFromSuperview()
            choiceTexts[i].removeFromSuperview()
        }
        backofChoice.removeFromSuperview()
    }
    func ChoiceType(sender:UIButton){
        let row = sender.tag - 100
        ChoicedLine = row
        hideChoice()
        AreShouldHide = true
        checkLogin { (res) -> Void in
            if res{
                APIPOST.TouPiaofeed(self.feedId, voteid: self.CommentIDS[row]) { (res) -> Void in
                    print(res)
                    if res["success"].stringValue == "true"{
                        self.AreChoiced = true
                        self.commentText.becomeFirstResponder()
                        //FeedbaseData.saveChoicedId(self.feedId, comment: self.CommentIDS[row])
                        MobClick.event("Vote")
                    }else{
                        self.errorMessage("提示", info: "已经投票过了")
                    }
                    
                }
            }
        }
        
        
    }
    
    
    func textViewDidChange(textView: UITextView) {
        let height = commentText.contentSize.height
        if commentText.text == ""{
            if AreAtOthers{
                placeHolder.text = " @\(otherName)"
            }else{
                placeHolder.text = "  输入你想要评论的内容"
            }
        }else{
            placeHolder.text = ""
        }
        
        if height == 34.0 {
            hightForBack.constant = 50
        }else{
            if height < 120{
                hightForBack.constant = 50 + height - 34.0
            }else{
                hightForBack.constant = 170 - 34.0
            }
        }
    }
    func deleleText(){
        if commentText.text == ""{
            self.OtherId = "0"
            AreAtOthers = false
            placeHolder.text = "  输入你想要评论的内容"
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        print(text)
        if text.length == 0 && textView.text == ""{
            self.OtherId = "0"
            AreAtOthers = false
            placeHolder.text = "  输入你想要评论的内容"
        }
        
        if text == "\n"{
            commentFeed()
            return false
        }else{
            return true
        }
        
        
    }
    func textViewDidEndEditing(textView: UITextView) {
        if commentText.text == ""{
            if AreAtOthers{
                placeHolder.text = "  @\(otherName)"
            }else{
                placeHolder.text = "  输入你想要评论的内容"
            }
        }else{
            placeHolder.text = ""
        }
    }
    
    
    @IBAction func back(sender: AnyObject) {
        LocalData.CanJump = true
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func atOther(sender:UIButton){
        
        let row = Int(sender.titleLabel!.text!)!
        if !AreChoiced{
            showDiffrentChoice()
        }else{
            commentText.layer.borderWidth = 3
            if ChoicedLine == CommentTexts.count - 1{
                commentText.layer.borderColor = ColorShow[4].CGColor
            }else{
                commentText.layer.borderColor = ColorShow[ChoicedLine].CGColor
            }
        }
        commentText.text = ""
        
        AreAtOthers = true
        OtherId = comments[row].uid
        otherName = comments[row].name
        otherhoicedId = CommentIDS[comments[row].choicedLine]
        otherCommentId = comments[row].floorNum
        commentText.resignFirstResponder()
        commentText.becomeFirstResponder()
        placeHolder.text = " @\(otherName)"
        
        MobClick.event("@")
        

    }
    func atMyself(sender:UIButton){
        let row = Int(sender.titleLabel!.text!)!
        if !AreChoiced{
            showDiffrentChoice()
        }else{
            commentText.layer.borderWidth = 3
            if ChoicedLine == CommentTexts.count - 1{
                commentText.layer.borderColor = ColorShow[4].CGColor
            }else{
                commentText.layer.borderColor = ColorShow[ChoicedLine].CGColor
            }
        }
        commentText.text = ""
        
        AreAtOthers = true
        OtherId = LocalData.uid
        otherName = Mycomments[row].name
        otherhoicedId = CommentIDS[Mycomments[row].choicedLine]
        otherCommentId = Mycomments[row].floorNum
        commentText.resignFirstResponder()
        commentText.becomeFirstResponder()
        placeHolder.text = " @\(otherName)"
        
        MobClick.event("@")
        
        
    }
    
    func showDiffrentChoice(){
        backofChoice.frame = CGRect(x: 0, y: 0, width: nowFrame.width, height: nowFrame.height + 20)
        backofChoice.setBackgroundImage(UIImage(named: "高斯模糊背景"), forState: UIControlState.Normal)
        
        
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        
        visualEffectView.frame = view.bounds
        
        backofChoice.addSubview(visualEffectView)
        self.view.addSubview(backofChoice)
        let oneHigh = (nowFrame.width - 16)/1180*135
        let partHigh = (nowFrame.width - 16)/1180*45
        let beginHigh:CGFloat = nowFrame.height/2 - CGFloat(CommentTexts.count)*(oneHigh + partHigh)/2
        for i in 0...CommentTexts.count-1{
            let ii = CGFloat(i)
            choicesButs[i].frame = CGRect(x: 8, y: beginHigh + ii*(oneHigh + partHigh), width: nowFrame.width - 16, height: oneHigh)
            choiceTexts[i].frame =  CGRect(x: 8, y: beginHigh + ii*(oneHigh + partHigh), width: nowFrame.width - 16, height: oneHigh)
            if i == CommentTexts.count-1{
                choiceTexts[i].backgroundColor = ColorChoiced[4]
            }else{
                choiceTexts[i].backgroundColor = ColorChoiced[i]
            }
            
            choiceTexts[i].numberOfLines = 0
            choiceTexts[i].font = UIFont.systemFontOfSize(15)
            choicesButs[i].layer.masksToBounds = true
            choicesButs[i].layer.cornerRadius = 6
            choiceTexts[i].layer.masksToBounds = true
            choiceTexts[i].layer.cornerRadius = 6
            choiceTexts[i].textAlignment = .Center
            //choicesButs[i].setTitle(CommentTexts[i], forState: UIControlState.Normal)
            choiceTexts[i].text = CommentTexts[i]
            //choicesButs[i].titleLabel!.font = UIFont.boldSystemFontOfSize(16)
            choicesButs[i].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            choicesButs[i].tag = 100+i
            choicesButs[i].addTarget(self, action: "ChoiceType:", forControlEvents: UIControlEvents.TouchUpInside)
            choicesButs[i].alpha = 0.8
            
            self.view.addSubview(choicesButs[i])
            self.view.addSubview(choiceTexts[i])
        }
        let explainLable = UILabel(frame: CGRect(x: 8, y: nowFrame.height/2 + CGFloat(CommentTexts.count)*(oneHigh + partHigh)/2, width: nowFrame.width - 16, height: 60))
        if nowFrame.width > 350{
            explainLable.text = "请选择一种你的观点继而发表评论时,你所发表的评论\n将会对应你观点的颜色"
        }else{
            explainLable.text = "请选择一种你的观点\n继而发表评论时,你所发表的评论\n将会对应你观点的颜色"
        }
        explainLable.textAlignment = .Center
        explainLable.numberOfLines = 3
        explainLable.textColor = UIColor.whiteColor()
        explainLable.font = UIFont.systemFontOfSize(13)
        backofChoice.addSubview(explainLable)
    }
    func GaussianBlurred(sourceImage:UIImage,Radius:UInt)->UIImage{
        let image = UIImage(CGImage: CGImageCreateWithImageInRect(sourceImage.CGImage, CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height))!)
        let ciImage = CIImage(CGImage: image.CGImage!)
        let filter = CIFilter(name: "CIGaussianBlur")!
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(Radius, forKey: kCIInputRadiusKey)
        let outputCIImage = filter.outputImage
        let context = CIContext(options: nil)
        return UIImage(CGImage: context.createCGImage(outputCIImage!, fromRect: ciImage.extent))
    }
    
    func zanOthers(sender:UIButton){
        let row = Int(sender.titleLabel!.text!)!
        if self.comments[row].AreZan{
            self.comments[row].zanNum = "\(Int(self.comments[row].zanNum)! - 1)"
            self.comments[row].AreZan = false
        }else{
            
            self.comments[row].zanNum = "\(Int(self.comments[row].zanNum)! + 1)"
            self.comments[row].AreZan = true
        }
        
        self.table.reloadData()
        checkLogin { (res) -> Void in
            if res{
                APIPOST.CommentCellZan(self.feedId, commentid: self.comments[row].commentID, position: self.comments[row].floorNum, com: { (ress) -> Void in
                    print(ress)
                    MobClick.event("CommentLikeBtnClicked")
                    if ress["success"].stringValue == "true"{
                    }else{
                        self.updatedata()
                    }
                })
            }
        }
        
    }
    func zanMyself(sender:UIButton){
        let row = Int(sender.titleLabel!.text!)!
        if self.Mycomments[row].AreZan{
            self.Mycomments[row].zanNum = "\(Int(self.Mycomments[row].zanNum)! - 1)"
            self.Mycomments[row].AreZan = false
        }else{
            
            self.Mycomments[row].zanNum = "\(Int(self.Mycomments[row].zanNum)! + 1)"
            self.Mycomments[row].AreZan = true
        }
        
        self.table.reloadData()
        checkLogin { (res) -> Void in
            if res{
                APIPOST.CommentCellZan(self.feedId, commentid: self.Mycomments[row].commentID, position:self.Mycomments[row].floorNum , com: { (ress) -> Void in
                    print(ress)
                    MobClick.event("CommentLikeBtnClicked")
                    if ress["success"].stringValue == "true"{
                    }else{
                        self.updatedata()
                    }
                })
            }
        }
        
    }

    
    func commentFeed(){
        print("即将发送评论")
        commentText.resignFirstResponder()
        if commentText.text != ""{
            if OtherId != ""{
                MobClick.event("@Notice")
            }
            if !AreShowName{
                MobClick.event("AnonymousComment")
            }else{
                MobClick.event("RealNameComment")
            }
            if AreShowName{
                self.Myhead = LocalData.userPic
                self.MyName = LocalData.userNick
            }else{
                //匿名
            }

            let AddnewComment = OneComment()
            AddnewComment.uid = LocalData.uid
            AddnewComment.commentID = ""
            AddnewComment.choicedLine = ChoicedLine
            AddnewComment.AreCanShow = AreShowName
            AddnewComment.headPic = Myhead
            AddnewComment.name = MyName
            AddnewComment.zanNum = "0"
            AddnewComment.AreZan = false
            AddnewComment.time = ""
            AddnewComment.city = LocalData.City
            AddnewComment.floorNum = ""
            AddnewComment.CommentText = commentText.text!
            AddnewComment.countHigh()
            AddnewComment.AreNeedLoad = true
            //@
            AddnewComment.otheruid = OtherId
            AddnewComment.otherName = otherName
            AddnewComment.fromvoteselect = otherhoicedId
            
            self.Mycomments.append(AddnewComment)
            self.AreNeedToend = true
            AreHaveNewComment = true
            
            self.table.reloadData()
            hightForBack.constant = 50
            commentText.text = ""
            self.OtherId = "0"
            self.AreAtOthers = false
            self.placeHolder.text = "  输入你想要评论的内容"
            self.AreCanSendNew = false
            
            
            let index = NSIndexPath(forRow: self.Mycomments.count-1, inSection: 1)
            self.table.scrollToRowAtIndexPath(index, atScrollPosition: .Bottom, animated: false)
            
            self.table.contentOffset.y += 12
            NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "ShowResent", userInfo: nil, repeats: false)
            uploadComment(AddnewComment)
            
        }else{
            //self.errorMessage("", info: "评论不能为空")
        }
        
    }
    func ShowResent(){
        if self.AreCanSendNew{
            AreNeedResent = false
        }else{
            AreNeedResent = true
        }
        self.table.reloadData()
    }
    private func uploadComment(data:OneComment){
        APIPOST.Commentfeed(data.CommentText, voteselect: CommentTexts[ChoicedLine], feedid: feedId, fromuid: data.otheruid, othername: data.otherName, voteid: CommentIDS[ChoicedLine], fromvoteselect: data.fromvoteselect, othercommentid: otherCommentId, randname: data.name, randavatar: data.headPic,sendtype:"", com: { (res) -> Void in
            print(res)
            if res["success"].stringValue == "true"{
                self.AreCanSendNew = true
                let data = res["data"]
                self.Mycomments[self.Mycomments.count-1].AreNeedLoad = false
                self.Mycomments[self.Mycomments.count-1].time = data["time"].stringValue
                self.Mycomments[self.Mycomments.count-1].floorNum = data["floor"].stringValue
                self.Mycomments[self.Mycomments.count-1].commentID = data["commentid"].stringValue
                self.table.reloadData()
                
            }
        })
    }
    func reSentComment(){
        let data = self.Mycomments[Mycomments.count-1]
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "ShowResent", userInfo: nil, repeats: false)
        AreNeedResent = false
        self.table.reloadData()
        APIPOST.Commentfeed(data.CommentText, voteselect: CommentTexts[ChoicedLine], feedid: feedId, fromuid: data.otheruid, othername: data.otherName, voteid: CommentIDS[ChoicedLine], fromvoteselect: data.fromvoteselect, othercommentid: otherCommentId, randname: data.name, randavatar: data.headPic,sendtype:"resend", com: { (res) -> Void in
            if res["success"].stringValue == "true"{
                self.AreCanSendNew = true
                let data = res["data"]
                self.Mycomments[self.Mycomments.count-1].AreNeedLoad = false
                self.Mycomments[self.Mycomments.count-1].time = data["time"].stringValue
                self.Mycomments[self.Mycomments.count-1].floorNum = data["floor"].stringValue
                self.Mycomments[self.Mycomments.count-1].commentID = data["commentid"].stringValue
                self.table.reloadData()
                
            }
        })
    }
    func updatedata(){
        print("评论列表\(feedId)")
        APIPOST.CommentList(feedId) { (res) -> Void in
            //print(res)
            self.activityMore.stopAnimating()
            self.comments = [OneComment]()
            self.table.reloadData()
            self.AreNeedloadBefore = res["length"].stringValue == "true"
            
            let datas = res["data"].arrayValue
            
            
            if datas.count == 0{
                self.AreNeedloadMore = false
                self.AreNeedloadBefore = false
            }
            
            
            for one in datas{
                let testone = OneComment()
                testone.CommentText = one["commentcontain"].stringValue
                testone.uid = one["uid"].stringValue
                let voteid = one["voteid"].stringValue
                
                for i in 0...self.CommentIDS.count-1{
                    if voteid == self.CommentIDS[i]{
                        testone.choicedLine = i
                        break
                    }
                }
                testone.AreNeedLoad = false
                testone.AreCanShow = one["hidename"].stringValue == "false"
                testone.city = one["location"].stringValue
                
                testone.floorNum = one["commentfloor"].stringValue
                testone.headPic = one["avatar"].stringValue
                
                testone.name = one["nickname"].stringValue
                
                testone.time = one["time"].stringValue
                testone.zanNum = one["commentzannum"].stringValue
                testone.AreZan = one["zan"].stringValue == "true"
                //@功能的的处理
                testone.otheruid =  one["fromuid"].stringValue
                testone.otherName = one["othername"].stringValue
                testone.fromvoteselect = one["fromvoteselect"].stringValue
                testone.commentID = one["commentid"].stringValue
                
                testone.countHigh()

                self.comments.append(testone)
            }
            self.table.reloadData()
            
            if self.comments.count > 5{
                if self.AreNeedloadBefore{
                    let Jumpindex = NSIndexPath(forRow: self.comments.count, inSection: 0)
                    self.table.scrollToRowAtIndexPath(Jumpindex, atScrollPosition: .Bottom, animated: false)
                }else{
                    let Jumpindex = NSIndexPath(forRow: self.comments.count-1, inSection: 0)
                    self.table.scrollToRowAtIndexPath(Jumpindex, atScrollPosition: .Bottom, animated: false)
                }
            }
            self.table.contentOffset.y += 12
            self.AreAtOthers = false
        }
    }
    
    func JumpGetData(){
        print("评论列表\(feedId)")
        let floor = FeedbaseData.getsavedCommentid(feedId)
        print("楼层是\(floor)")
        APIPOST.JumpToCommentList(feedId, startindex: floor) { (res) -> Void in
            //print(res)
            self.activityMore.stopAnimating()
            
            self.comments = [OneComment]()
            self.table.reloadData()
            self.AreNeedloadBefore = res["cangoup"].stringValue == "true"
            self.AreNeedloadMore = res["cangodown"].stringValue == "true"
            let datas = res["data"].arrayValue
            
            
            if datas.count == 0{
                self.AreNeedloadMore = false
                self.AreNeedloadBefore = false
            }
            
            var line = 0
            
            for one in datas{
                let testone = OneComment()
                testone.CommentText = one["commentcontain"].stringValue
                testone.uid = one["uid"].stringValue
                let voteid = one["voteid"].stringValue
                for i in 0...self.CommentIDS.count-1{
                    if voteid == self.CommentIDS[i]{
                        testone.choicedLine = i
                        break
                    }
                }
                testone.AreNeedLoad = false
                testone.AreCanShow = one["hidename"].stringValue == "false"
                testone.city = one["location"].stringValue
                
                testone.floorNum = one["commentfloor"].stringValue
                if testone.floorNum == floor{
                    line = self.comments.count
                }
                testone.headPic = one["avatar"].stringValue
                
                testone.name = one["nickname"].stringValue
                
                testone.time = one["time"].stringValue
                testone.zanNum = one["commentzannum"].stringValue
                testone.AreZan = one["zan"].stringValue == "true"
                //@功能的的处理
                testone.otheruid =  one["fromuid"].stringValue
                testone.otherName = one["othername"].stringValue
                testone.fromvoteselect = one["fromvoteselect"].stringValue
                testone.commentID = one["commentid"].stringValue
                
                testone.countHigh()
                
                self.comments.append(testone)
            }
            self.table.reloadData()
            
            if self.comments.count > 5{
                if self.AreNeedloadBefore{
                    let Jumpindex = NSIndexPath(forRow: line + 1, inSection: 0)
                    self.table.scrollToRowAtIndexPath(Jumpindex, atScrollPosition: .Top, animated: false)
                }else{
                    let Jumpindex = NSIndexPath(forRow: line, inSection: 0)
                    self.table.scrollToRowAtIndexPath(Jumpindex, atScrollPosition: .Top, animated: false)
                }
            }
        }
    }
    
    
    
    func addMoreData(){
        APIPOST.MoreCommentList(feedId, startindex: comments[comments.count-1].floorNum, direction: "down") { (res) -> Void in
            print(res)
            
            self.activityMore.stopAnimating()
            
            self.AreNeedloadMore = res["length"].stringValue == "true"
            let datas = res["data"].arrayValue
            for one in datas{
                let testone = OneComment()
                testone.CommentText = one["commentcontain"].stringValue
                testone.uid = one["uid"].stringValue
                let voteid = one["voteid"].stringValue
                for i in 0...self.CommentIDS.count-1{
                    if voteid == self.CommentIDS[i]{
                        testone.choicedLine = i
                        break
                    }
                }
                testone.AreNeedLoad = false
                testone.AreCanShow = one["hidename"].stringValue == "false"
                testone.city = one["location"].stringValue
                
                testone.floorNum = one["commentfloor"].stringValue
                testone.headPic = one["avatar"].stringValue
                
                testone.name = one["nickname"].stringValue
                
                testone.time = one["time"].stringValue
                testone.zanNum = one["commentzannum"].stringValue
                testone.AreZan = one["zan"].stringValue == "true"
                //@功能的的处理
                testone.otheruid =  one["fromuid"].stringValue
                testone.otherName = one["othername"].stringValue
                testone.fromvoteselect = one["fromvoteselect"].stringValue
                testone.commentID = one["commentid"].stringValue
                
                testone.countHigh()
                
                self.comments.append(testone)
            }
            if self.AreHaveNewComment{
                if self.comments[self.comments.count-1].floorNum.toUInt()! >= self.Mycomments[0].floorNum.toUInt()!{
                    self.AreHaveNewComment = false
                    self.Mycomments = [OneComment]()
                }
            
            }
            self.AreNotAtGetMore = true
            self.table.reloadData()

        }
    }
    
    func addBeforeData(){
        APIPOST.MoreCommentList(feedId, startindex: comments[0].floorNum, direction: "up") { (res) -> Void in
            print(res)
            
            self.activityMore.stopAnimating()
            self.AreNeedloadBefore = res["length"].stringValue == "true"
            var beforeComments = [OneComment]()
            let datas = res["data"].arrayValue
            for one in datas{
                let testone = OneComment()
                testone.CommentText = one["commentcontain"].stringValue
                testone.uid = one["uid"].stringValue
                let voteid = one["voteid"].stringValue
                for i in 0...self.CommentIDS.count-1{
                    if voteid == self.CommentIDS[i]{
                        testone.choicedLine = i
                        break
                    }
                }
                testone.AreNeedLoad = false
                testone.AreCanShow = one["hidename"].stringValue == "false"
                testone.city = one["location"].stringValue
                
                testone.floorNum = one["commentfloor"].stringValue
                testone.headPic = one["avatar"].stringValue
                
                testone.name = one["nickname"].stringValue
                
                testone.time = one["time"].stringValue
                testone.zanNum = one["commentzannum"].stringValue
                testone.AreZan = one["zan"].stringValue == "true"
                //@功能的的处理
                testone.otheruid =  one["fromuid"].stringValue
                testone.otherName = one["othername"].stringValue
                testone.fromvoteselect = one["fromvoteselect"].stringValue
                testone.commentID = one["commentid"].stringValue
                
                testone.countHigh()
                
                beforeComments.append(testone)
            }
            for one in self.comments{
                beforeComments.append(one)
            }
            self.comments = beforeComments
            
            self.AreNotAtGetMore = true
            let Jumpindex = NSIndexPath(forRow: 30, inSection: 0)
            self.table.scrollToRowAtIndexPath(Jumpindex, atScrollPosition: .Top, animated: false)
            self.table.reloadData()
            
            
        }

        
    }
    
    
    //举报的功能完善
    func SaveLine(sender:UIButton){
        SavedLine = Int(sender.titleLabel!.text!)!
        commentText.resignFirstResponder()
        if commentText.text == ""{
            self.OtherId = "0"
            self.AreAtOthers = false
            self.placeHolder.text = "  输入你想要评论的内容"
        }else{
            placeHolder.text = ""
        }
        
    }
    func showReport(sender:UIGestureRecognizer){
        print("长按")
        if SavedLine != -1{
            let action = UIAlertController(title: "举报不良信息", message: "选取举报类型", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let op0 = UIAlertAction(title: "情色相关", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!)in (self.postBad("情色相关"))})
            let op1 = UIAlertAction(title: "垃圾广告", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!)in (self.postBad("垃圾广告"))})
            let op2 = UIAlertAction(title: "反动言论", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!)in (self.postBad("反动言论"))})
            let op3 = UIAlertAction(title: "其它", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!)in (self.postBad("其它"))})
            let opend = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {(actionSheet: UIAlertAction!)in (print("Cancel"))})
            
            action.addAction(op0)
            action.addAction(op1)
            action.addAction(op2)
            action.addAction(op3)
            action.addAction(opend)
            self.presentViewController(action, animated: true, completion: nil)
        }
    }
    func postBad(BadType:String){
        print(BadType)
        print(SavedLine)
        OtherAlert = UIAlertView(title: "提交举报中", message: "", delegate: nil, cancelButtonTitle: nil)
        OtherAlert.show()
        checkLogin { (res) -> Void in
            if res{
                APIPOST.ReportInfo(self.comments[self.SavedLine].commentID, publishuid: self.comments[self.SavedLine].uid, reportcontain: self.comments[self.SavedLine].CommentText, feedid: self.feedId, typecontain: BadType, com: { (res) -> Void in
                    self.OtherAlert.dismissWithClickedButtonIndex(0, animated: false)
                    if res["success"].stringValue == "true"{
                        self.errorMessage("举报成功", info: "我们将尽快处理你的举报信息")
                    }
                })
            }
        }
        
    }

    
    
    @IBAction func clear(sender: AnyObject) {
        commentText.resignFirstResponder()
    }
    func swipeback(sender:UIPanGestureRecognizer){
        LocalData.CanJump = true
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func gotoTop(sender: AnyObject) {
        print("跳转")
        let Jumpindex = NSIndexPath(forRow: 0, inSection: 0)
        self.table.scrollToRowAtIndexPath(Jumpindex, atScrollPosition: .Top, animated: true)
    }
    
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
    
    
}
