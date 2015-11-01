//
//  backLogin.swift
//  Udian
//
//  Created by farmerwu_pc on 15/7/9.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import Foundation
import UIKit
protocol ViewControllerDeleget{
    func disShow()
}
extension UIViewController:ViewControllerDeleget{
    func backtoLogin(){
        let story = UIStoryboard(name: "back", bundle: nil)
        let filte = story.instantiateViewControllerWithIdentifier("login") as UIViewController
        //self.tabBarController?.tabBar.hidden = true
        
        self.presentViewController(filte, animated: true) { () -> Void in
            LocalData.uid = "0"
            LocalData.userPWD = ""
            LocalData.SuserPWD = ""
            LocalData.CanPassTime = NSDate().addHours(-1)
            BPush.unbindChannelWithCompleteHandler({ (AnyObject, error) -> Void in
                
            })
        }
    }
    func disShow() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    public func errorMessage(title:String,info:String){
        let alert = UIAlertView(title: title, message: info, delegate: self, cancelButtonTitle: "确定")
        alert.show()
    }
    /*
    func updateSysteminfo(inout info :UILabel){
        if LocalData.UnreadNum == 0{
            info.textColor = UIColor.clearColor()
            info.backgroundColor = UIColor.clearColor()
        }else{
            info.textColor = UIColor.whiteColor()
            info.backgroundColor = UIColor(red: 214/255, green: 46/255, blue: 53/255, alpha: 1)
        }
    }*/
    func okgologinAction(){
        backtoLogin()
    }
    func cancelgologinAction(){
        
    }
    func checkLogin(com:((res:Bool)->Void)){
        if LocalData.SuserPWD == "" {
            let alertController = UIAlertController(title: "提示", message: "需要登录了咯", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {(actionSheet: UIAlertAction!)in (self.cancelgologinAction())})
            let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler:  {(actionSheet: UIAlertAction!)in (self.okgologinAction())})
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            com(res: false)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }else{
            if LocalData.CanPassTime > NSDate(){
                com(res: true)
                
            }else{
                APIPOST.UserLogin { (res, err) -> Void in
                    com(res: res)
                    if res{
                        LocalData.CanPassTime = NSDate().addDays(1)
                    }
                }
            }
            
            
        }
    }
    func ChangToStopJump(){
        LocalData.CanJump = false
    }
    
    //跳转到对应的feed
    func gotoFeedDetil(){
         print("跳转？？？？？？？？？：\(LocalData.CanJump)")
        if LocalData.CanJump{
            LocalData.CanJump = false
            let row = LocalData.keepRow
            print(LocalData.sysInfo[row].feedId)
            
            let story = UIStoryboard(name: "Main", bundle: nil)//获取故事版
            let filte = story.instantiateViewControllerWithIdentifier("TwoChange") as! TwoChange//定位视图
            filte.AreLeft = true
            if LocalData.sysInfo[row].fromUid == "0"{
                filte.AreNeedJunp = false
            }else{
               filte.AreNeedJunp = true
            }
            
            filte.IdOfFeed = LocalData.sysInfo[row].feedId
            
            APIPOST.feedMore(LocalData.sysInfo[row].feedId) { (res) -> Void in
                print(res)
                let Jres = res["data"]
                let quanMinUrl = Jres["commndurl"].stringValue
                let changGuandianUrl = Jres["lpointurl"].stringValue
                let backImag = Jres["feed_bg"].stringValue
                let boundLong = Jres["match_points"].intValue
                filte.LeftUrl = quanMinUrl //全民点评
                filte.RightUrl  = changGuandianUrl
                filte.PicOfFeed = backImag //feed背景图(用于分享)
                if boundLong == 0{
                    //没有长观点绑定
                    if quanMinUrl != ""{
                        if changGuandianUrl != ""{
                            filte.AreTwoType = true
                            
                        }else{
                            self.errorMessage("提示", info: "对应文章已经被删除")
                            return
                        }
                    }else{
                        filte.AreTwoType = false
                        filte.AreLeft = false
                        
                    }
                }else{
                    if changGuandianUrl != ""{
                        //有长观点绑定且有全民点评
                        filte.AreBound = true
                        
                    }else{
                        filte.AreTwoType = false
                        filte.AreLeft = false
                        
                    }
                }
                
                self.navigationController?.pushViewController(filte, animated: true)
                
            }
            
        }
        
        
        
    }
    
    func pushTofeed(){
        let story = UIStoryboard(name: "Main", bundle: nil)//获取故事版
        let filte = story.instantiateViewControllerWithIdentifier("TwoChange") as! TwoChange//定位视图
        filte.AreLeft = true
        if LocalData.PushUid == "0"{
            filte.AreNeedJunp = false
        }else{
            filte.AreNeedJunp = true
        }
        
        filte.IdOfFeed = LocalData.PushFeedId
        
        APIPOST.feedMore(LocalData.PushFeedId) { (res) -> Void in
            print(res)
            let Jres = res["data"]
            let quanMinUrl = Jres["commndurl"].stringValue
            let changGuandianUrl = Jres["lpointurl"].stringValue
            let backImag = Jres["feed_bg"].stringValue
            let boundLong = Jres["match_points"].intValue
            filte.LeftUrl = quanMinUrl //全民点评
            filte.RightUrl  = changGuandianUrl
            filte.PicOfFeed = backImag //feed背景图(用于分享)
            if boundLong == 0{
                //没有长观点绑定
                if quanMinUrl != ""{
                    if changGuandianUrl != ""{
                        filte.AreTwoType = true
                        
                    }else{
                        self.errorMessage("提示", info: "对应文章已经被删除")
                        return
                    }
                }else{
                    filte.AreTwoType = false
                    filte.AreLeft = false
                    
                }
            }else{
                if changGuandianUrl != ""{
                    //有长观点绑定且有全民点评
                    filte.AreBound = true
                    
                }else{
                    filte.AreTwoType = false
                    filte.AreLeft = false
                    
                }
            }
            self.navigationController?.pushViewController(filte, animated: true)
            
        }
    }
    
    
    
    
    








    
    
    
}