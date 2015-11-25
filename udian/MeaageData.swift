//
//  MeaageData.swift
//  Udian
//
//  Created by farmerwu_pc on 15/8/17.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit
class MeaageData:NSObject,UITableViewDataSource,UITableViewDelegate{
    let nowFrame = UIScreen.mainScreen().applicationFrame

    // MARK: - Table view data source
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print(LocalData.sysInfo.count)
        
        return LocalData.sysInfo.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return LocalData.sysInfo[indexPath.row].cellHight
        
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: nowFrame.width-16, height: 50))
        
            let MianTitle = UILabel(frame: CGRect(x:nowFrame.width/2 - 58 , y: 12 , width: 100, height: 24))
            MianTitle.text = "提醒通知"
            MianTitle.textAlignment = .Center
            MianTitle.textColor = UIColor.darkGrayColor()
            MianTitle.font = UIFont.boldSystemFontOfSize(22)
            titleview.addSubview(MianTitle)
           return titleview
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "    "
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let row = indexPath.row
        for one in cell.subviews{
            one.removeFromSuperview()
        }
        
        let typeImage = UIImageView(frame: CGRect(x: 8, y: LocalData.sysInfo[row].cellHight/2 - 17, width: 34, height: 34))
        
        let textLable = UILabel(frame: CGRect(x: 46, y: 0, width: nowFrame.width - 62, height: LocalData.sysInfo[row].cellHight - 16))
        
        let timeLable = UILabel(frame: CGRect(x: 46, y: LocalData.sysInfo[row].cellHight - 20, width: nowFrame.width - 70, height: 16))
        
        textLable.numberOfLines = 0
        textLable.font = UIFont.systemFontOfSize(16)
        
        timeLable.textColor = UIColor.lightGrayColor()
        timeLable.font = UIFont.systemFontOfSize(13)
        timeLable.textAlignment = .Left
        let timeDate = LocalData.sysInfo[row].Times
        let date = timeDate.toDateTime("yyyy-MM-dd HH:mm:ss")!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm yyyy/MM/dd"
        let text = dateFormatter.stringFromDate(date)
        timeLable.text = text
        
        if LocalData.sysInfo[row].otherhidename == ""{
            APIPOST.CommentUserInfo(LocalData.sysInfo[row].fromUid, com: { (res) -> Void in
                let Jres = res["data"]
                textLable.text = Jres["nickname"].stringValue + LocalData.sysInfo[row].Message
                
                
            })
        }else{
            textLable.text = LocalData.sysInfo[row].otherhidename + LocalData.sysInfo[row].Message
        }
        let goBut = UIButton(frame: textLable.frame)
        goBut.setTitle("\(row)", forState: UIControlState.Normal)
        goBut.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        goBut.addTarget(self, action: "GotoFeed:", forControlEvents: UIControlEvents.TouchUpInside)
        goBut.addTarget(self, action: "DownCanGo", forControlEvents: UIControlEvents.TouchDragInside)
        goBut.addTarget(self, action: "BackCanTouch", forControlEvents: UIControlEvents.TouchDown)
        
        
        
        //删除部分
        let deleback = UILabel(frame: CGRect(x: nowFrame.width - 16, y: 0, width: nowFrame.width, height: LocalData.sysInfo[row].cellHight))
        deleback.backgroundColor = UIColor.whiteColor()
        let deleBut = UIButton(frame: CGRect(x: nowFrame.width - 16, y: 0, width: 50, height: LocalData.sysInfo[row].cellHight))
        let deleImage = UIImageView(frame: CGRect(x: nowFrame.width - 8, y: LocalData.sysInfo[row].cellHight/2 - 17 , width: 34, height: 34))
        deleImage.image = UIImage(named: "删除图标")
        deleBut.backgroundColor = UIColor(red: 134/255, green: 135/255, blue: 136/255, alpha: 1)
        deleBut.layer.masksToBounds = true
        deleBut.layer.cornerRadius = 6
        
        //添加subcell
        cell.addSubview(typeImage)
        cell.addSubview(textLable)
        cell.addSubview(timeLable)
        cell.addSubview(goBut)
        cell.addSubview(deleback)
        cell.addSubview(deleBut)
        cell.addSubview(deleImage)
        if LocalData.sysInfo[row].fromUid == "0"{
            //系统消息
            typeImage.image = UIImage(named: "消息类型2")
            
        }else{
            //@信息
            typeImage.image = UIImage(named: "消息类型1") 
            
        }
        // Configure the cell...
        APIPOST.ReadSysrtemInfo(LocalData.sysInfo[row].infoid, com: { (res) -> Void in
            //print(res)
        })
        return cell
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        
        //系统消息是可以删除的只是后台没有处理接口
        return true
    }
    func GotoFeed(sender:UIButton){
        let row = Int(sender.titleLabel!.text!.toUInt()!)
        LocalData.keepRow = row
        print(row)
        FeedbaseData.saveFeedinfo(LocalData.sysInfo[row].feedId, comment: LocalData.sysInfo[row].Commentid)
        if LocalData.sysInfo[row].feedId != "0"{
            NSNotificationCenter.defaultCenter().postNotificationName("gotoFeedDetil", object: nil)
        }
        
    }
    
    func BackCanTouch(){
        //LocalData.CanJump = true
    }
    func DownCanGo(){
        LocalData.CanJump = false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //print("删除")
            let row = indexPath.row
            APIPOST.DeletSysrtemInfo(LocalData.sysInfo[row].infoid, com: { (res) -> Void in
                print(res)
            })
            NSNotificationCenter.defaultCenter().postNotificationName("NeedReload", object: nil)
            LocalData.sysInfo.removeAtIndex(row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            //需要删除信息的函数
            
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

}