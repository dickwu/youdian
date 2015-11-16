//
//  ViewController.swift
//  Udian
//
//  Created by farmerwu_pc on 15/6/22.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class Onefeed {
    var IDs = String()//feedId
    var AreAtTitle = Bool()
    var Tips = String()//标题
    var backImag = String()//背景图
    var tipPic = String()//左上角的分类pic
    var feedlei = [String]()//feed流引入的平台
    
    var boundLong = Int()//绑定长观点的数量
    var quanMinUrl = String()//全民点评
    var changGuandianUrl = String()//长观点
    //投票
    var commentTitle = String()
    var commentNums = [Int]()
    var commentTips = [String]()
    var CommentIDS = [String]()
    //最下面的3个数量
    var lookNum = String()
    var comments = String()
    var Likes = String()
}

class SearchOne {
    var feedid = String()
    var Tips = String()
    var tipPic = String()
    var backImag = String()//背景图
    
    //最下面的3个数量
    var lookNum = String()
    var comments = String()
    var Likes = String()
    
}
class SearchTwo {
    var feedid = String()
    var MainPic = String()//文章图片
    var Tips = String()//文章标题
    var tipCount = String()//文章摘要
    var tipName = String()
    var tipImag = String()
    var time = String()//文章时间
    
    //最下面的3个数量
    var lookNum = String()
    var comments = String()
    var Likes = String()
}






class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,UISearchBarDelegate{
    
    
    @IBOutlet weak var backLable: UILabel!
    
    @IBOutlet weak var search: UISearchBar!
    
    @IBOutlet weak var messageNumLabel: UILabel!
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var SystemType: UIButton!
    
    let nowFrame = UIScreen.mainScreen().applicationFrame
    
    var searchback = UIView()
    //下拉刷新
    var refreshControl = UIRefreshControl()
    //let refresh = RefreshView()
    
    
    
    //搜索需要参数------------------------------------
    //是否是搜索
    var AreNotAtSearch = true
    var SearchResType = 0
    var SearchResTitleNum = 0
    var SearchResCountNum = 0
    var SearchTitles = [SearchOne]()
    var SearchCounts = [SearchTwo]()
    
    
    //--------------------------------------
    //消息
    let Mes = UITableView()
    let mesback = UIButton()
    let data = MeaageData()
    //-------------------------
    
    
    var len = 0
    var feedlen = 0
    var AreNeedMore = false
    let Moreactivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    //feed流数据
    
    //搜索背景
    let SearchEmptyBack = UIButton()


    var feedLists  = [Onefeed]()
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        messageNumLabel.layer.masksToBounds = true
        messageNumLabel.layer.cornerRadius = 7
        //去空行
        let tblView =  UIView(frame: CGRect(x: 0, y: 0, width: nowFrame.width + 20, height: 12))
        self.table.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.table.tableFooterView = tblView
        self.table.separatorStyle = UITableViewCellSeparatorStyle.None
        search.layer.masksToBounds = true
        
        
        let back = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = back
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "loadData", userInfo: nil, repeats: false)
        
        //APIPOST.whateatTeast()
        APIPOST.getCity { (city) -> Void in
            LocalData.City = city
        }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SearchCancle", name: "SearchCancle", object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        if LocalData.leadVersion == 1{
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.view.sendSubviewToBack(backLable)
        }else{
            let story = UIStoryboard(name: "Main", bundle: nil)
            let filte = story.instantiateViewControllerWithIdentifier("leadView") as! leadView
            self.navigationController?.pushViewController(filte, animated: false)
        }
        
        
        self.refreshControl.removeFromSuperview()
        refreshControl.addTarget(self, action: Selector("pullDown"), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        self.table.addSubview(self.refreshControl)
        
        self.table.sendSubviewToBack(self.refreshControl)

        
        SystemInfoUpdate()
        NSNotificationCenter.defaultCenter().removeObserver("gotoFeedDetil", name: "gotoFeedDetil", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SystemInfoUpdate", name: "SystemInfoUpdate", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushTofeed", name: "PushJump", object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver("gotoFeedDetil", name: "gotoFeedDetil", object: nil)
    }
    func pullDown(){
        refreshControl.attributedTitle = NSAttributedString(string: "正在加载")
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "finishFresh", userInfo: nil, repeats: false)
        AreNotAtSearch = true
        search.text = nil
        loadData()
        
    }
    func finishFresh(){
        
        refreshControl.endRefreshing()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if AreNotAtSearch{
            if indexPath.row == 0{
                if feedLists[0].commentTitle == ""{
                    return 0
                }else{
                    return 60
                }
            }else{
                if AreNeedMore && indexPath.row == feedLists.count{
                    return 60
                }else{
                    if feedLists[indexPath.row].AreAtTitle{
                        return 60
                    }else{
                        return nowFrame.width/1200*750
                    }

                }
                
            }

        }else{
            if SearchResType == 1{
                if SearchResTitleNum != 0{
                    return nowFrame.width/1200*750
                }else{
                    return 150
                }
            }else{
                if indexPath.section == 0{
                    return nowFrame.width/1200*750
                }else{
                    return 150
                }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if AreNotAtSearch{
            return 1
        }else{
            return SearchResType
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if AreNotAtSearch{
            //print("没有搜索")
            if AreNeedMore{
                return feedLists.count + 1
            }else{
               return feedLists.count
            }
            
            
        }else{
            if SearchResType == 0{
                return 0
            }else{
                if SearchResType == 1{
                    if SearchResTitleNum != 0{
                        return SearchResTitleNum
                    }else{
                        return SearchResCountNum
                    }
                }else{
                    if section == 0{
                        return SearchResTitleNum
                    }else{
                        return SearchResCountNum
                    }
                }
            }
        }
    }
    //删除--------------------------------
    /*
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            print("删除")
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }*/
    //---------------------------------------
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        if AreNotAtSearch{
            if feedLists.count != 0{
                cell = loadNotSearchCell(indexPath)
            }
        }else{
            if SearchResType == 1{
                if SearchResTitleNum != 0{
                    return loadSearchTitle(indexPath.row)
                }else{
                    return loadSearchCount(indexPath.row)
                }
            }else{
                if indexPath.section == 0{
                    return loadSearchTitle(indexPath.row)
                }else{
                    return loadSearchCount(indexPath.row)
                }
            }
        }
        /*
        let deletBut = UIButton(frame: CGRect(x: nowFrame.width + 8, y: 0, width: 200, height: nowFrame.width/1200*750))
        deletBut.backgroundColor = UIColor.lightGrayColor()
        cell.addSubview(deletBut)
        */
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("搜索")
        MobClick.event("ContentSearch")
        MobClick.event("Search")
        search.resignFirstResponder()
        searchOne()
//        if searchBar.text == ""{
//            searchback.removeFromSuperview()
//            self.view.addSubview(searchback)
//        }else{
//            searchback.removeFromSuperview()
//            
//        }
    }
    func SearchCancle(){
        AreNotAtSearch = true
        print("取消搜索")
        SystemType.setImage(UIImage(named: "setup"), forState: UIControlState.Normal)
        search.resignFirstResponder()
        searchback.removeFromSuperview()
        SearchEmptyBack.removeFromSuperview()
        search.text = nil
        
        loadData()
    }
    
    func gotoDetil(sender:UIButton){
        print(sender.titleLabel!.text!)
        let row = Int(sender.titleLabel!.text!)!
        print(feedLists[row].boundLong)
        let story = UIStoryboard(name: "Main", bundle: nil)//获取故事版
        let filte = story.instantiateViewControllerWithIdentifier("TwoChange") as! TwoChange//定位视图
        filte.AreLeft = true
        filte.IdOfFeed = feedLists[row].IDs
        filte.LeftUrl = feedLists[row].quanMinUrl //全民点评
        filte.RightUrl  = feedLists[row].changGuandianUrl
        filte.PicOfFeed = feedLists[row].backImag //feed背景图(用于分享)
        filte.MainTitle = feedLists[row].Tips//用于分享
        filte.CommentTitle = "#\(feedLists[row].commentTitle)"
        filte.CommentTypeNum = feedLists[row].commentTips.count //投票类型数
        filte.CommentPeopleNum = feedLists[row].commentNums //各个投票的数量
        filte.CommentText = feedLists[row].commentTips //各个投票的标题
        filte.AllZanNum = Int(feedLists[row].Likes)! //被赞过的次数
        filte.AllComment = Int(feedLists[row].comments)! //评论数
        filte.CommenIds = feedLists[row].CommentIDS
        if AreNotAtSearch{
            if feedLists[row].boundLong == 0{
                //没有长观点绑定
                if feedLists[row].quanMinUrl != ""{
                    if feedLists[row].changGuandianUrl != ""{
                        filte.AreTwoType = true
                        self.navigationController?.pushViewController(filte, animated: true)
                    }else{
                        filte.AreTwoType = false
                        filte.AreLeft = true
                        self.navigationController?.pushViewController(filte, animated: true)
                    }
                }else{
                    filte.AreTwoType = false
                    filte.AreLeft = false
                    self.navigationController?.pushViewController(filte, animated: true)
                }
            }else{
                if feedLists[row].changGuandianUrl != ""{
                    //有长观点绑定且有全民点评
                    filte.AreBound = true
                    self.navigationController?.pushViewController(filte, animated: true)
                }else{
                    filte.AreTwoType = false
                    filte.AreLeft = false
                }
            }
            
        }else{
            //搜索
        }
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //refresh.position = scrollView.contentOffset.y
        //print(scrollView.contentOffset.y)
    }
    
    
    
    
    
    @IBAction func showMessage(sender: AnyObject) {
        checkLogin { (res) -> Void in
            if res{
                
                self.search.resignFirstResponder()
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
            self.messageNumLabel.alpha = 1
            self.messageNumLabel.text = "\(LocalData.UnreadNum)"
        }else{
            self.messageNumLabel.alpha = 0
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
                self.messageNumLabel.alpha = 1
                self.messageNumLabel.text = "\(LocalData.UnreadNum)"
            }else{
                self.messageNumLabel.alpha = 0
            }
            
        })
    }
    
    
    func hideMessage(){
        SystemInfoUpdate()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "gotoFeedDetil", object: nil)
        mesback.removeFromSuperview()
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        let newback = seachEmpty(frame: self.table.frame)
        newback.searchKeep = searchBar
        searchback = newback
        AreNotAtSearch = false
        self.view.addSubview(searchback)
        self.feedLists = [Onefeed]()
        self.table.reloadData()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉加载全部")
        SystemType.setImage(UIImage(named: "取消触发按钮小"), forState: UIControlState.Normal)
        return true
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        
        
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        AreNotAtSearch = false
        print("正在搜索\(search.text)")
       
        
    }

    
    @IBAction func clean(sender: AnyObject) {
        search.resignFirstResponder()
    }
    
    func getCode()->String{
        let code = "\(arc4random()%10000)"
        if code.characters.count != 4{
            return getCode()
        }else{
            return code
        }
        
    }
    
    @IBAction func GotoSteup(sender: AnyObject) {
        if AreNotAtSearch{
            let story = UIStoryboard(name: "Main", bundle: nil)//获取故事版
            let filte = story.instantiateViewControllerWithIdentifier("settingMain") as! settingMain//定位视图
            self.navigationController?.pushViewController(filte, animated: true)
        }else{
            searchback.removeFromSuperview()
            SystemType.setImage(UIImage(named: "setup"), forState: UIControlState.Normal)
            search.resignFirstResponder()
            SearchEmptyBack.removeFromSuperview()
            search.text = nil
            AreNotAtSearch = true
            
            loadData()
        }
    }
    

}

