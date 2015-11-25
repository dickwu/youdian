//
//  TwoChange.swift
//  Udian
//
//  Created by farmerwu_pc on 15/8/17.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class subFeed{
    var MainTitle = String()
    var MainPic = String()
    var senderPIc = String()
    var sendTime = String()
    var senderName = String()
    var senderUrl = String()
}



class TwoChange: UIViewController,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate{
    
    var AreTwoType = true
    var IdOfFeed = String()
    var AreLeft = true//true => 全民点评 false => 长观点
    var LeftUrl = "" //全民点评
    var RightUrl = "" //长观点
    var PicOfFeed = "" //feed背景图(用于分享)
    var MainTitle = ""//用于分享
    
    var CommentTitle = ""
    var CommentTypeNum = 0 //投票类型数
    var CommentPeopleNum = [0,0,0,0,0] //各个投票的数量
    var CommenIds = [String]()
    var CommentText = [String]() //各个投票的标题
    var AllZanNum = 10 //被赞过的次数
    var AllComment = 20 //评论数
    var AreBound = false //是否绑定长观点
    var AreNeedLoad = true
    
    //刷新时接口数据
    var AreAlreadyChoice = false
    var ChoicedNum = 2
    
    var boundNum = 0
    var boundFeeds = [subFeed]()
    
    //是否赞过
    var Arezan = false
    
    let nowFrame = UIScreen.mainScreen().applicationFrame
    @IBOutlet weak var leftBut: UIButton!
    @IBOutlet weak var rightBut: UIButton!
    @IBOutlet weak var MianTitle: UILabel!
    @IBOutlet weak var shareBut: UIButton!
    
    var url = ""
    var titleHigh:CGFloat = 0
    var CommentHigh:CGFloat = 0
    var AreAlreadyZan = false
    var allNum:CGFloat = 0
    
    let coler1 = UIColor(red: 253/255, green: 140/255, blue: 103/255, alpha: 1)
    let coler2 = UIColor(red: 253/255, green: 154/255, blue: 26/255,  alpha: 1)
    let coler3 = UIColor(red: 149/255, green: 204/255, blue: 61/255,  alpha: 1)
    let coler4 = UIColor(red: 44/255,  green: 152/255, blue: 201/255, alpha: 1)
    let coler5 = UIColor(red: 149/255, green: 149/255, blue: 149/255, alpha: 1)
    
    let angle = CAShapeLayer()
    //点赞和评论按钮
    let zanBut = UIButton()
    let CommentBut = UIButton()
    var zanNum = NumberLable()
    var Comnum = NumberLable()
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBOutlet weak var table: UITableView!
    var HtmlHight:CGFloat = 0
    var AreFirst = true
    var AreNeedJunp = false
    
    var AreNeedKeep = false
    
    var share = ShareView()
    
    override func viewWillAppear(animated: Bool) {
        
        
        
        if AreTwoType{
            
        }else{
            leftBut.alpha = 0
            rightBut.alpha = 0
            leftBut.enabled = false
            rightBut.enabled = false
            if AreLeft{
                MianTitle.text = "全民点评"
                url = LeftUrl
            }else{
                url = RightUrl
                MianTitle.text = "长观点"
            }
        }
        
        if !AreNeedKeep{
            //self.table.setContentOffset(CGPointMake(0, 0), animated: true)
            updateSubfeedData()
        }else{
            AreNeedKeep = false
        }
        LocalData.CanJump = true
        MobClick.beginLogPageView("详情页")
    }
    override func viewDidDisappear(animated: Bool) {
        MobClick.endLogPageView("详情页")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //self.view.layoutIfNeeded()
        if AreTwoType{
            showAngle()
            if AreLeft{
                showLeftAng()
            }else{
                showRigtAng()
            }
        }
        
        loadTwo()
        //去空行
        let tblView =  UIView(frame: CGRectZero)
        self.table.backgroundColor = UIColor.whiteColor()
        self.table.tableFooterView = tblView
        self.table.separatorStyle = UITableViewCellSeparatorStyle.None
        HtmlHight = nowFrame.height - 44
        
        APIPOST.Liulanfeed(IdOfFeed) { (res) -> Void in
            //print(res)
        }
        
        //hideShare
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideshare", name: "hideShare", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushTofeed", name: "PushJump", object: nil)
        LocalData.CanShowShare = true
        //手势返回
        let backGesture = UISwipeGestureRecognizer()
        backGesture.direction = .Right
        backGesture.addTarget(self, action: "swipeback")
        backGesture.delegate = self
        self.table.addGestureRecognizer(backGesture)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showAngle(){
        
        let path = CGPathCreateMutable()
        let oneWidth = nowFrame.width - 106
        angle.fillColor = UIColor.whiteColor().CGColor
        angle.strokeColor = UIColor.whiteColor().CGColor
        angle.lineWidth = 1
        CGPathMoveToPoint(path, nil, oneWidth/4 , 40)
        CGPathAddLineToPoint(path, nil, oneWidth/4 + 7, 34)
        CGPathAddLineToPoint(path, nil, oneWidth/4 + 14, 40)
        angle.path = path
        
        
    }
    func showLeftAng(){
        MobClick.event("AllCommentBtn")
        leftBut.layer.addSublayer(angle)
        url = LeftUrl
        AreFirst = true
        leftBut.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rightBut.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        HtmlHight = nowFrame.height - 44
        self.table.setContentOffset(CGPointMake(0, 0), animated: true)
        self.table.reloadData()
    }
    func showRigtAng(){
        MobClick.event("LongOpinionBtn")
        rightBut.layer.addSublayer(angle)
        url = RightUrl
        print(url)
        AreFirst = true
        rightBut.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        leftBut.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        HtmlHight = nowFrame.height - 44
        self.table.setContentOffset(CGPointMake(0, 0), animated: true)
        self.table.reloadData()
    }

    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if AreBound && !AreLeft{
            return boundNum
        }else{
            return 3
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if AreBound && !AreLeft{
            //print("绑定的长观点")
            return nowFrame.width/1200*750
        }else{
            if indexPath.row == 0{
                return HtmlHight
            }else{
                if indexPath.row == 1{
                    let NSone:NSString = NSString(string: CommentTitle)
                    let oneFrame = NSone.sizeWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(17)])
                    titleHigh = oneFrame.height * (oneFrame.width + nowFrame.width - 64) / (nowFrame.width - 62)
                    return titleHigh + 8
                }else{
                    return nowFrame.width*107/124 + CGFloat(CommentTypeNum)*(nowFrame.width/41*5 + 8)
                }
            }
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
       var cell = UITableViewCell()
        if AreBound && !AreLeft{
            cell = self.table.dequeueReusableCellWithIdentifier("two")!
            let row = indexPath.row
            let backImage = cell.viewWithTag(20) as! UIImageView
            let tip = cell.viewWithTag(21) as! UILabel
            let senderPic = cell.viewWithTag(22) as! UIImageView
            let senderInfo = cell.viewWithTag(23) as! UILabel
            let goBut = cell.viewWithTag(24) as! UIButton
            
            backImage.layer.cornerRadius = 4
            backImage.layer.masksToBounds = true
            
            if nowFrame.width > 375{
                tip.font = UIFont.boldSystemFontOfSize(22)
            }else{
                tip.font = UIFont.boldSystemFontOfSize(20)
            }
            tip.shadowColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.6)
            tip.shadowOffset = CGSize(width: 1.25, height: 1.25)

            backImage.yy_setImageWithURL(NSURL(string:boundFeeds[row].MainPic)!, options: [YYWebImageOptions.ProgressiveBlur , YYWebImageOptions.SetImageWithFadeAnimation])

            tip.text = boundFeeds[row].MainTitle
            senderPic.layer.cornerRadius = 12
            senderPic.layer.masksToBounds = true
            senderPic.image = nil
            SPic.dowmloadPic(boundFeeds[row].senderPIc, proce: { (pro) -> Void in
                
                }, com: { (img) -> Void in
                    senderPic.image = img
            })
            let timeDate = boundFeeds[row].sendTime
            let date = timeDate.toDateTime("yyyy-MM-dd HH:mm:ss")!
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm yyyy-MM-dd"
            let text = dateFormatter.stringFromDate(date)
            senderInfo.text = "\(boundFeeds[row].senderName)  \(text)"
            goBut.setTitle("\(row)", forState: UIControlState.Normal)
            goBut.addTarget(self, action: "gotoSubLong:", forControlEvents: UIControlEvents.TouchUpInside)

        }else{
            if indexPath.row == 0{
                cell = self.table.dequeueReusableCellWithIdentifier("web")!
                let webview = cell.viewWithTag(20) as! UIWebView
                webview.scrollView.bounces = true
                webview.scrollView.alwaysBounceHorizontal = true
                webview.scrollView.alwaysBounceVertical = true
                webview.scrollView.scrollEnabled = false
                webview.delegate = self
                if AreFirst{
                    webview.loadRequest(NSURLRequest(URL: NSURL(string: url + "&userid=\(LocalData.uid)")!))
                }
            }else{
                if indexPath.row == 1  {
                    cell = CommentTitleCell()
                }else{
                    if CommentTypeNum != 0{
                        cell = CommentCell()
                    }
                }
            }
        }
        return cell
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(url)
        if request.URLString == url + "&userid=\(LocalData.uid)"{
            
            return true
        }else{
            let allUrls:NSString = request.URLString
            print(allUrls)
            let parts = allUrls.componentsSeparatedByString("&,")
            print(parts)
            if parts.count == 1 {
                if AreLeft{
                    let story = UIStoryboard(name: "Main", bundle: nil)//获取故事版
                    let filte = story.instantiateViewControllerWithIdentifier("webView") as! webViewer//定位视图
                    filte.url = request.URLString
                    self.AreNeedKeep = true
                    self.navigationController?.pushViewController(filte, animated: true)
                }else{
                    return true
                }
                
            }else{
                
                var browserList = [MWPhoto]()
                for i in 0...parts.count-2{
                    browserList.append(MWPhoto(URL: NSURL(string: parts[i])))
                }
                
                let browser = MWPhotoBrowser(photos: browserList)
                //browser.delegate = self
                browser.setCurrentPhotoIndex(parts[parts.count-1].toUInt()!)
                self.AreNeedKeep = true
                self.navigationController?.pushViewController(browser, animated: true)
            }
            
        }
        return false
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        //htmlHeight = [webView stringByEvaluatingJavaScriptFromString"document.body.offsetHeight"]
        if AreFirst{
            HtmlHight = CGFloat( webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight")!.toFloat()!)
            self.table.reloadData()
            AreFirst = false
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
    
    @IBAction func changeToLeft(sender: AnyObject) {
        showLeftAng()
        shareBut.alpha = 1
        shareBut.enabled = true
        AreLeft = true
        if AreBound{
            hideTwo()
            loadTwo()
        }
    }
    
    @IBAction func changeToRight(sender: AnyObject) {
        AreLeft = false
        if AreBound{
            shareBut.alpha = 0
            shareBut.enabled = false
            showRigtAng()
            hideTwo()
        }else{
           showRigtAng()
        }
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
             scrollView.contentOffset.y = 0
        }
    }

    
    //评论的标题
    func CommentTitleCell()->UITableViewCell{
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.whiteColor()
        let tip = UILabel(frame: CGRect(x: 16, y: 4, width: nowFrame.width - 32, height: titleHigh))
        tip.numberOfLines = 0
        tip.text = CommentTitle
        
        cell.addSubview(tip)
        return cell
    }
    //评论柱图
    func CommentCell()->UITableViewCell{
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.whiteColor()
        var backimage = UIImageView(frame: CGRect(x: 16, y: 8, width: nowFrame.width - 26, height: (nowFrame.width - 32)*78/109))
        backimage.image = UIImage(named: "投票结果底")
        
        //分成两种类别
        allNum = 0
        for one in CommentPeopleNum{
            allNum += CGFloat(one)
        }
        if allNum <= 0{
            allNum = 0.001
        }
        let MaxNum = CommentPeopleNum.maxElement()!
        let explainLable = UILabel(frame: CGRect(x: 16  , y: ((nowFrame.width - 32)*78/109) + 16, width: nowFrame.width - 16 , height: 40))
        explainLable.numberOfLines = 0
        explainLable.text = "点击下列任意选项即可对话题进行实名投票，再次点击可取消投票。"
        explainLable.textColor = UIColor.lightGrayColor()
        explainLable.font = UIFont.systemFontOfSize(15)
        if CGFloat(MaxNum)/(allNum) > 0.50{
            HalfProcess(&backimage)
        }else{
            AllProcess(&backimage)
        }
        let onebackProcessHight = nowFrame.width/41*5
        for i in 0...CommentTypeNum-1{
            let ii = CGFloat(i)
            //背景
            let backProcess = UILabel(frame: CGRect(x: 16, y: ((nowFrame.width - 32)*78/109) + 64 + ii*(onebackProcessHight+8) , width: nowFrame.width - 26, height: onebackProcessHight))
            backProcess.backgroundColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1)
            backProcess.layer.masksToBounds = true
            backProcess.layer.cornerRadius = 4
            cell.addSubview(backProcess)
            //进度条
            let LettreLable = UILabel()
            LettreLable.layer.masksToBounds = true
            LettreLable.layer.cornerRadius = 4
            
            let LettterPart = ["A","B","C","D","E"]
            let TypeLable = UILabel(frame: CGRect(x: 20, y: ((nowFrame.width - 32)*78/109) + 64 + ii*(onebackProcessHight+8), width: onebackProcessHight, height: onebackProcessHight))
            TypeLable.font = UIFont.boldSystemFontOfSize(22)
            TypeLable.text = LettterPart[i]
            TypeLable.textAlignment = .Center
            TypeLable.textColor = UIColor.darkGrayColor()
            
            let TypeLablePro = UILabel(frame: CGRect(x: nowFrame.width - 54, y: ((nowFrame.width - 32)*78/109) + 64 + ii*(onebackProcessHight+8), width: onebackProcessHight, height: onebackProcessHight))
            TypeLablePro.font = UIFont.boldSystemFontOfSize(15)
            TypeLablePro.textAlignment = .Center
            TypeLablePro.textColor = UIColor.darkGrayColor()
            
            
            TypeLablePro.text =  "\(Int(CGFloat(CommentPeopleNum[i])/allNum*100))%"
            

            
            let expLable = UILabel(frame: CGRect(x: onebackProcessHight + 20, y: ((nowFrame.width - 32)*78/109) + 64 + ii*(onebackProcessHight+8), width: nowFrame.width - 70 - onebackProcessHight , height: onebackProcessHight))
            expLable.text = CommentText[i]
            expLable.textColor = UIColor.darkGrayColor()
            expLable.numberOfLines = 2
            expLable.font = UIFont.systemFontOfSize(15)
            switch i{
            case CommentTypeNum - 1:
                LettreLable.backgroundColor = coler5
            case 0 :
                LettreLable.backgroundColor = coler1
            case 1 :
                LettreLable.backgroundColor = coler2
            case 2 :
                LettreLable.backgroundColor = coler3
            case 3 :
                LettreLable.backgroundColor = coler4
            default:break
            }
            let choiceBut = UIButton()
            choiceBut.frame = backProcess.frame
            choiceBut.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
            choiceBut.setTitle("\(i)", forState: UIControlState.Normal)
            choiceBut.addTarget(self, action: "choiceMyConmment:", forControlEvents: UIControlEvents.TouchUpInside)
            if AreAlreadyChoice{
                choiceBut.enabled = false
                if ChoicedNum != i{
                    LettreLable.alpha = 0.3
                    TypeLablePro.alpha = 0.5
                }else{
                    LettreLable.alpha = 1
                    TypeLablePro.alpha = 1
                    choiceBut.enabled = true
                }
                LettreLable.frame =  CGRect(x: 16, y: ((nowFrame.width - 32)*78/109) + 64 + ii*(onebackProcessHight+8), width: 0, height: onebackProcessHight)
                UILabel.animateWithDuration(1, animations: { () -> Void in
                    LettreLable.frame = CGRect(x: 16, y: ((self.nowFrame.width - 32)*78/109) + 64 + ii*(onebackProcessHight+8), width: (CGFloat(self.CommentPeopleNum[i])/self.allNum)*(self.nowFrame.width - 26), height: onebackProcessHight)
                })
                
            }else{
                LettreLable.alpha = 1
                LettreLable.frame = CGRect(x: 16, y: ((self.nowFrame.width - 32)*78/109) + 64 + ii*(onebackProcessHight+8), width: (CGFloat(self.CommentPeopleNum[i])/self.allNum)*(self.nowFrame.width - 26), height: onebackProcessHight)
                
                UILabel.animateWithDuration(100, animations: { () -> Void in
                    LettreLable.frame = CGRect(x: 16, y: ((self.nowFrame.width - 32)*78/109) + 64 + ii*(onebackProcessHight+8), width: 0, height: onebackProcessHight)
                })
                
                
                TypeLablePro.alpha = 0
            }
            
            cell.addSubview(LettreLable)
            cell.addSubview(TypeLable)
            cell.addSubview(expLable)
            cell.addSubview(choiceBut)
            cell.addSubview(TypeLablePro)
        }
        
        cell.addSubview(backimage)
        cell.addSubview(explainLable)
        return cell
    }
    func choiceMyConmment(sender:UIButton){
        print(sender.titleLabel!.text!)
        
        checkLogin { (res) -> Void in
            if res{
                let row = Int(sender.titleLabel!.text!)!
                if self.AreAlreadyChoice{
                    self.AreAlreadyChoice = false
                    self.CommentPeopleNum[row]--
                    FeedbaseData.saveChoicedId(self.IdOfFeed, comment: "0")
                }else{
                    self.AreAlreadyChoice = true
                    self.CommentPeopleNum[row]++
                    FeedbaseData.saveChoicedId(self.IdOfFeed, comment: "\(self.CommenIds[row])")
                }
                self.ChoicedNum = row
                self.table.reloadData()
                APIPOST.TouPiaofeed(self.IdOfFeed, voteid: self.CommenIds[row]) { (res) -> Void in
                    print(res)
                    if res["success"].stringValue == "true"{
                        MobClick.event("ContentVoteClicked")
                    }else{
                        self.errorMessage("提示", info: "已经投票过了")
                        self.updateSubfeedData()
                    }
                    
                    
                }
            }
        }
        
        
        
        
    }
    //超过 50%
    func HalfProcess(inout backimage:UIImageView){
        let allHigh = (nowFrame.width - 32)*78/109*32/60
        
        let beginhigh = (nowFrame.width - 32)*117/1090
        let partHigh = (nowFrame.width - 32)*208/2725
        //
        let toubeginhigh = beginhigh + (nowFrame.width - 32)*13/1090
        let allWidth = (nowFrame.width - 26)*606/784
        var beginWidth = (nowFrame.width - 26)*145/838
        var partWidth = allWidth/CGFloat(CommentTypeNum)
        
        if CommentText.count == 2{
            beginWidth = (nowFrame.width - 26)*245/838
            partWidth = allWidth/CGFloat(2)
        }
        
        let onePartWidth = allWidth/5
        let LettterPart = ["A","B","C","D","E"]
        let imges = ["刻度栏11","刻度栏9","刻度栏7","刻度栏5","刻度栏3","刻度栏1"]
        for i in 0...5{
            let ii = CGFloat(i)
            let oneImage = UIImageView(frame: CGRect(x: 0, y: beginhigh + ii*partHigh , width: (nowFrame.width - 26)*0.12, height: (nowFrame.width - 32)*13/545))
            oneImage.image = UIImage(named: imges[i])
            backimage.addSubview(oneImage)
        }
        
        for i in 0...CommentTypeNum - 1{
            let ii = CGFloat(i)
            let onehigh = allHigh*CGFloat(CommentPeopleNum[i])/(allNum) + 2
            let oneImage = UIImageView(frame: CGRect(x: beginWidth + ii*partWidth , y: toubeginhigh + allHigh , width: onePartWidth - 16   , height: 0))
            let onelabel = UILabel(frame: CGRect(x: beginWidth + ii*partWidth , y: toubeginhigh + allHigh - 24 , width: onePartWidth - 16   , height: 20))
            let Prelable =  UILabel(frame: CGRect(x: beginWidth + ii*partWidth - 8  , y: toubeginhigh + allHigh + onePartWidth/2 + 4, width: onePartWidth   , height: 20))
            UIImageView.animateWithDuration(1) { () -> Void in
                oneImage.frame = CGRect(x: beginWidth + ii*partWidth , y: toubeginhigh + allHigh - onehigh , width: onePartWidth - 16   , height: onehigh)
            }
            UILabel.animateWithDuration(1) { () -> Void in
                onelabel.frame = CGRect(x: beginWidth + ii*partWidth , y: toubeginhigh + allHigh - onehigh - 24 , width: onePartWidth - 16   , height: 20)
            }
            onelabel.textAlignment = .Center
            onelabel.text = LettterPart[i]
            onelabel.textColor = UIColor.darkGrayColor()
            Prelable.textAlignment = .Center
            Prelable.textColor = UIColor.darkGrayColor()
            
            Prelable.text =  "\(Int(CGFloat(CommentPeopleNum[i])/allNum*100))%"
            
            let xPoint:CGFloat = beginWidth + (onePartWidth-16)/4 + ii*partWidth
            let dotImage = UIImageView(frame: CGRect(x:  xPoint, y: toubeginhigh + allHigh + 8 , width: (onePartWidth-16)/2   , height: (onePartWidth-16)/2))
            dotImage.layer.cornerRadius = (onePartWidth-16)/4
            dotImage.layer.borderWidth = (onePartWidth-16)/6
            switch i{
            case CommentTypeNum - 1:
                oneImage.backgroundColor = coler5
                dotImage.layer.borderColor = coler5.CGColor
            case 0 :
                oneImage.backgroundColor = coler1
                dotImage.layer.borderColor = coler1.CGColor
            case 1 :
                oneImage.backgroundColor = coler2
                dotImage.layer.borderColor = coler2.CGColor
            case 2 :
                oneImage.backgroundColor = coler3
                dotImage.layer.borderColor = coler3.CGColor
            case 3 :
                oneImage.backgroundColor = coler4
                dotImage.layer.borderColor = coler4.CGColor
            default:break
            }
            oneImage.layer.cornerRadius = 4
            oneImage.layer.cornerRadius = 4
//            oneImage.layer.shadowColor = UIColor.darkGrayColor().CGColor
//            oneImage.layer.shadowOffset = CGSizeMake(4, 4)
//            oneImage.layer.shadowOpacity = 0.5
//            oneImage.layer.shadowRadius = 2
            
            backimage.addSubview(onelabel)
            backimage.addSubview(oneImage)
            backimage.addSubview(dotImage)
            backimage.addSubview(Prelable)
        }

    }
    //未超过50%
    func AllProcess(inout backimage:UIImageView){
        let allHigh = (nowFrame.width - 32)*78/109*32/60
        
        let beginhigh = (nowFrame.width - 32)*117/1090
        let partHigh = (nowFrame.width - 32)*208/2725
        //
        let toubeginhigh = beginhigh + (nowFrame.width - 32)*13/1090
        let allWidth = (nowFrame.width - 26)*606/784
        let beginWidth = (nowFrame.width - 26)*145/838
        let partWidth = allWidth/CGFloat(CommentTypeNum)
        let onePartWidth = allWidth/5
        
        
        let LettterPart = ["A","B","C","D","E"]
        let imges = ["刻度栏6","刻度栏5","刻度栏4","刻度栏3","刻度栏2","刻度栏1"]
        for i in 0...5{
            let ii = CGFloat(i)
            let oneImage = UIImageView(frame: CGRect(x: 0, y: beginhigh + ii*partHigh , width: (nowFrame.width - 26)*0.12, height: (nowFrame.width - 32)*13/545))
            oneImage.image = UIImage(named: imges[i])
            backimage.addSubview(oneImage)
        }
        for i in 0...CommentTypeNum - 1{
            let ii = CGFloat(i)
            let onehigh = allHigh*CGFloat(CommentPeopleNum[i])/(allNum)*2 + 2
            let oneImage = UIImageView(frame: CGRect(x: beginWidth + ii*partWidth , y: toubeginhigh + allHigh , width: onePartWidth - 16   , height: 0))
            let onelabel = UILabel(frame: CGRect(x: beginWidth + ii*partWidth , y: toubeginhigh + allHigh - 24 , width: partWidth - 16   , height: 20))
            let xPoint:CGFloat = beginWidth + (onePartWidth-16)/4 + ii*partWidth
            let dotImage = UIImageView(frame: CGRect(x: xPoint , y: toubeginhigh + allHigh + 8 , width: (onePartWidth-16)/2   , height: (onePartWidth-16)/2))
            let Prelable =  UILabel(frame: CGRect(x: beginWidth + ii*partWidth - 8  , y: toubeginhigh + allHigh + onePartWidth/2 + 4, width: onePartWidth   , height: 20))
            UIImageView.animateWithDuration(1) { () -> Void in
                oneImage.frame = CGRect(x: beginWidth + ii*partWidth , y: toubeginhigh + allHigh - onehigh , width: onePartWidth - 16   , height: onehigh)
            }
            UILabel.animateWithDuration(1) { () -> Void in
                onelabel.frame = CGRect(x: beginWidth + ii*partWidth , y: toubeginhigh + allHigh - onehigh - 24 , width: onePartWidth - 16   , height: 20)
            }
            onelabel.textAlignment = .Center
            onelabel.text = LettterPart[i]
            onelabel.textColor = UIColor.darkGrayColor()
            dotImage.layer.cornerRadius = (onePartWidth-16)/4
            dotImage.layer.borderWidth = (onePartWidth-16)/6
            Prelable.textAlignment = .Center
            Prelable.textColor = UIColor.darkGrayColor()
            
            Prelable.text =  "\(Int(CGFloat(CommentPeopleNum[i])/allNum*100))%"
            
            switch i{
            case CommentTypeNum - 1:
                oneImage.backgroundColor = coler5
                dotImage.layer.borderColor = coler5.CGColor
            case 0 :
                oneImage.backgroundColor = coler1
                dotImage.layer.borderColor = coler1.CGColor
            case 1 :
                oneImage.backgroundColor = coler2
                dotImage.layer.borderColor = coler2.CGColor
            case 2 :
                oneImage.backgroundColor = coler3
                dotImage.layer.borderColor = coler3.CGColor
            case 3 :
                oneImage.backgroundColor = coler4
                dotImage.layer.borderColor = coler4.CGColor
            default:break
            }
            oneImage.layer.cornerRadius = 4
//            oneImage.layer.shadowColor = UIColor.darkGrayColor().CGColor
//            oneImage.layer.shadowOffset = CGSizeMake(4, 4)
//            oneImage.layer.shadowOpacity = 0.5
//            oneImage.layer.shadowRadius = 2
            //说明文字
            backimage.addSubview(onelabel)
            backimage.addSubview(oneImage)
            backimage.addSubview(dotImage)
            backimage.addSubview(Prelable)
        }
    }
    
    func CountHight(size:CGFloat,width:CGFloat,Source:String)->CGFloat{
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(size)
        let NSone:NSString = NSString(string: Source)
        let oneFrame = NSone.sizeWithAttributes([NSFontAttributeName:label.font])
        let line = oneFrame.width/width
        let hight = oneFrame.height * line
        return hight
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func loadTwo(){
        zanBut.frame = CGRect(x: nowFrame.width * 0.66, y: nowFrame.height - nowFrame.width*0.16 + 20, width: nowFrame.width*0.14 - 8, height: nowFrame.width*0.14 - 8)
        if Arezan{
            zanBut.setBackgroundImage(UIImage(named: "点赞(已赞)图标"), forState: UIControlState.Normal)
        }else{
            zanBut.setBackgroundImage(UIImage(named: "点赞(未赞)图标"), forState: UIControlState.Normal)
        }
        
        zanBut.addTarget(self, action: "dianzanfeed", forControlEvents: UIControlEvents.TouchUpInside)
        
        CommentBut.frame = CGRect(x: nowFrame.width * 0.82, y: nowFrame.height - nowFrame.width*0.16 + 20, width: nowFrame.width*0.14 - 8, height: nowFrame.width*0.14 - 8)
        CommentBut.setBackgroundImage(UIImage(named: "评论图标"), forState: UIControlState.Normal)
        CommentBut.addTarget(self, action: "gotoComment", forControlEvents: UIControlEvents.TouchUpInside)
        zanNum = NumberLable(frame: CGRect(x: nowFrame.width * 0.8 - 16, y: nowFrame.height - nowFrame.width*0.16 + 12, width: 16, height: 16))
        zanNum.text = "\(AllZanNum)"
        Comnum = NumberLable(frame: CGRect(x: nowFrame.width * 0.96 - 16, y: nowFrame.height - nowFrame.width*0.16 + 12, width: 16, height: 16))
        Comnum.text = "\(AllComment)"
        
        
        self.view.addSubview(zanBut)
        self.view.addSubview(CommentBut)
        if AllZanNum != 0{
            self.view.addSubview(zanNum)
            if AllZanNum > 99{
                zanNum.text = "..."
            }
        }
        
        if AllComment != 0{
            self.view.addSubview(Comnum)
            if AllComment > 99{
                Comnum.text = "..."
            }
        }
    }
    func hideTwo(){
        zanBut.removeFromSuperview()
        CommentBut.removeFromSuperview()
        zanNum.removeFromSuperview()
        Comnum.removeFromSuperview()
    }
    
    func dianzanfeed(){
        checkLogin { (res) -> Void in
            if res{
                if self.Arezan{
                    self.AllZanNum--
                    self.Arezan = false
                }else{
                    self.AllZanNum++
                    self.Arezan = true
                    
                }
                
                self.hideTwo()
                self.loadTwo()
                self.AreNeedLoad = false
                APIPOST.Zanfeed(self.IdOfFeed) { (res) -> Void in
                    print(res)
                    self.updateSubfeedData()
                    MobClick.event("LikeBtnClicked")
                }
            }
        }
        
    }
    
    func gotoComment(){
        self.AreNeedLoad = false
        let story = UIStoryboard(name: "Main", bundle: nil)//获取故事版
        let filte = story.instantiateViewControllerWithIdentifier("Comment") as! Comment//定位视图
        filte.AreChoiced = self.AreAlreadyChoice
        filte.ChoicedLine = ChoicedNum
        filte.feedId = IdOfFeed
        filte.CommentTexts = self.CommentText
        filte.CommentIDS = CommenIds
        
        filte.AreNeedJumpToCell = AreNeedJunp
        //push视图
        self.AreNeedJunp = false
        MobClick.event("CommentBtnClicked")
        self.navigationController?.pushViewController(filte, animated: true)


    }
    
    
    func updateSubfeedData(){
        
        APIPOST.UpdateSubfeed(IdOfFeed) { (res) -> Void in
            print(res)
            self.boundFeeds = [subFeed]()
            let Jres = res["data"]
            
            
            
            
            self.Arezan = Jres["ifzan"].stringValue == "yes"
            if self.AreBound && !self.AreLeft{
                
            }else{
                self.hideTwo()
                self.loadTwo()
            }
            self.AllZanNum = Jres["care_num"].intValue
            self.zanNum.text = Jres["care_num"].stringValue
            self.Comnum.text = Jres["comment_num"].stringValue
            let NewcommentList = Jres["votegroup"]["vote_contain"].arrayValue
            let commentTip = Jres["votegroup"]["title"].stringValue
            self.CommentTitle = commentTip
            self.CommentTypeNum = NewcommentList.count //投票类型数
            var CommentPeopleNumx = [Int]() //各个投票的数量
            var CommenIdsx = [String]()
            var CommentTextx = [String]()
            for i in 0...NewcommentList.count-1{
                CommentPeopleNumx.append(NewcommentList[i]["vote_num"].intValue)
                CommenIdsx.append(NewcommentList[i]["vote_id"].stringValue)
                CommentTextx.append(NewcommentList[i]["contain"].stringValue)
            }
            self.CommentPeopleNum = CommentPeopleNumx
            self.CommenIds = CommenIdsx
            if Jres["ifvote"].stringValue != ""{
                FeedbaseData.saveChoicedId(self.IdOfFeed, comment: Jres["ifvote"].stringValue)
                self.AreAlreadyChoice = true
                for i in 0...self.CommenIds.count-1{
                    if self.CommenIds[i] == Jres["ifvote"].stringValue{
                        self.ChoicedNum = i
                        break
                    }
                }
                
            }else{
                self.AreAlreadyChoice = false
                FeedbaseData.saveChoicedId(self.IdOfFeed, comment: "0")
            }
            
            self.CommentText = CommentTextx
            if self.AreNeedLoad{
                self.table.reloadData()
            }else{
                self.AreNeedLoad = true
            }
            if self.AreBound{
                let datas = Jres["matchpoints"].arrayValue
                self.boundNum = datas.count
                for one in datas{
                    let newSub = subFeed()
                    newSub.MainTitle = one["title"].stringValue
                    newSub.MainPic = one["feed_bg"].stringValue
                    newSub.senderName = one["author"].stringValue
                    newSub.senderPIc = one["avatar"].stringValue
                    newSub.senderUrl = one["pointurl"].stringValue
                    newSub.sendTime = one["time"].stringValue
                    self.boundFeeds.append(newSub)
                    if !self.AreLeft{
                        self.table.reloadData()
                    }
                }
            }
            if self.AreNeedJunp{
                self.gotoComment()
            }
        }
    }
    
    
    func gotoSubLong(sender: UIButton){
        let row = Int(sender.titleLabel!.text!)!
        let story = UIStoryboard(name: "Main", bundle: nil)//获取故事版
        let filte = story.instantiateViewControllerWithIdentifier("TwoChange") as! TwoChange//定位视图
        filte.AreLeft = true
        filte.IdOfFeed = IdOfFeed
        
        /*******************************************/
        filte.url = boundFeeds[row].senderUrl
        filte.RightUrl = boundFeeds[row].senderUrl
        filte.PicOfFeed = boundFeeds[row].MainPic //feed背景图(用于分享)
        filte.MainTitle = boundFeeds[row].MainTitle//用于分享
        print(boundFeeds[row].senderUrl)
        //继承评论和投票
        filte.CommentTitle = CommentTitle
        filte.CommentTypeNum = CommentTypeNum//投票类型数
        filte.CommentPeopleNum = CommentPeopleNum //各个投票的数量
        filte.CommentText = CommentText //各个投票的标题
        filte.AllZanNum = AllZanNum //被赞过的次数
        filte.AllComment = self.AllComment //评论数
        filte.AreAlreadyChoice = AreAlreadyChoice
        filte.ChoicedNum = ChoicedNum
        filte.AllComment = AllComment
        filte.Arezan = Arezan
        filte.CommenIds = self.CommenIds
        filte.AreTwoType = false
        filte.AreLeft = false
        filte.AreFirst = true
        self.navigationController?.pushViewController(filte, animated: true)
    }

    
    @IBAction func back(sender: AnyObject) {
        LocalData.CanJump = true
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func share(sender: AnyObject) {
        
        if LocalData.CanShowShare{
            LocalData.CanShowShare = false
            share = ShareView(frame: CGRect(x: 0, y: nowFrame.width*0.7, width: nowFrame.width, height: nowFrame.height + 20))
            share.SharePic = PicOfFeed
            share.ShareTitle = MainTitle
            share.ShareUrl = url + "&feedid=\(IdOfFeed)"
            
            self.view.addSubview(share)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.share.frame = CGRect(x: 0, y: 0, width: self.nowFrame.width, height: self.nowFrame.height + 20)
                }) { (bool) -> Void in
                    LocalData.CanShowShare = true
                    //share.allback.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
            }
        }
    }
    
    func swipeback(){
        LocalData.CanJump = true
        self.navigationController?.popViewControllerAnimated(true)
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func hideshare(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.share.frame = CGRect(x: 0, y: self.nowFrame.width*0.7, width: self.nowFrame.width, height: self.nowFrame.height + 20)
            }) { (bool) -> Void in
                LocalData.CanShowShare = true
                self.share.removeFromSuperview()
                //share.allback.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
        }
    }

}
