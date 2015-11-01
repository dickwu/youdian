//
//  LocalData.swift
//  Udian
//
//  Created by farmerwu_pc on 15/7/11.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import Foundation

class Connect {
    static let domain = "http://139.196.35.146:9090/Handler/"
    //static let domain = "http://192.168.1.105/VoteU/Handler/"
    static let picMain = "http://7xlm0o.com1.z0.glb.clouddn.com/"
    static let pic200 = "?imageView2/1/w/200/h/200"
    static let pic50 = "?imageView2/1/w/50/h/50"
    static let pic400 = "?imageView2/1/w/400/h/400"
}

class SystemInfo{
    private let nowFrame = UIScreen.mainScreen().applicationFrame
    var infoid = String()
    var fromUid = String()
    var feedId = String()
    var otherhidename = String()
    var Message = String()
    var Times = String()
    var ReadTime = String()
    var cellHight = CGFloat()
    var Commentid = String()
    func countHight(){
        let NSone:NSString = NSString(string: Message)
        let oneFrame = NSone.sizeWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(15)])
        cellHight = 25 + (oneFrame.width + nowFrame.width - 60)/(nowFrame.width - 60) * oneFrame.height
    }
}

class LocalData {
    static let users = NSUserDefaults.standardUserDefaults()
    //帐号
    //用户名
    static var userid:String{
        get{
        if let keep = users.valueForKey("UserID") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "UserID")
        }
    }
    //注册用户id
    static var KeepUserid:String{
        get{
        if let keep = users.valueForKey("KeepUserid") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "KeepUserid")
        }
    }
    //注册密码
    static var KeepPass:String{
        get{
        if let keep = users.valueForKey("KeepPass") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "KeepPass")
        }
    }
    
    //uid
    static var uid:String{
        get{
        if let keep = users.valueForKey("uid") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "uid")
        }
    }
    //密码
    static var userPWD:String{
        get{
        if let keep = users.valueForKey("UserPWD") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "UserPWD")
        }
    }
    //加密后的密码
    static var SuserPWD:String{
        get{
        if let keep = users.valueForKey("SuserPWD") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "SuserPWD")
        }
    }
    //密码验证过期时间
    static var CanPassTime:NSDate{
        get{
        if let keep = users.valueForKey("CanPassTime") as? NSDate{
        return keep
    }else{
        return NSDate().addHours(-1)
        }
        }set(keep){
            users.setValue(keep, forKey: "CanPassTime")
        }
    }
    //头像
    static var userPic:String{
        get{
        if let keep = users.valueForKey("UserPic") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "UserPic")
        }
    }
    //保存的头像
    static var KeepuserPic:String{
        get{
        if let keep = users.valueForKey("KeepuserPic") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "KeepuserPic")
        }
    }
    //昵称
    static var userNick:String{
        get{
        if let keep = users.valueForKey("userNick") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "userNick")
        }
    }
    //性别
    static var userSex:String{
        get{
        if let keep = users.valueForKey("userSex") as? String{
        return keep
    }else{
        return "男"
        }
        }set(keep){
            users.setValue(keep, forKey: "userSex")
        }
    }
    //生日
    static var userBirth:String{
        get{
        if let keep = users.valueForKey("userBirth") as? String{
        return keep
    }else{
        return "1990/1/1"
        }
        }set(keep){
            users.setValue(keep, forKey: "userBirth")
        }
    }
    //城市
    static var City:String{
        get{
        if let keep = users.valueForKey("City") as? String{
        return keep
    }else{
        return "未知"
        }
        }set(keep){
            users.setValue(keep, forKey: "City")
        }
    }
    //系统消息
    static var sysInfo = [SystemInfo]()

    
    
    
    
    //= [SystemInfo]()

    //绑定账户
    //QQ
    static var userQQ:String{
        get{
        if let keep = users.valueForKey("userQQ") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "userQQ")
        }
    }
    //微信
    static var userWeChat:String{
        get{
        if let keep = users.valueForKey("userWeChat") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "userWeChat")
        }
    }
    //微博
    static var userWeibo:String{
        get{
        if let keep = users.valueForKey("userWeibo") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "userWeibo")
        }
    }
    //邮箱
    static var userMail:String{
        get{
        if let keep = users.valueForKey("userMail") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "userMail")
        }
    }
    //签名
    static var userIntro:String{
        get{
        if let keep = users.valueForKey("userIntro") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "userIntro")
        }
    }
    
    //未读信息数
    static var UnreadNum:Int{
        get{
        if let keep = users.valueForKey("UnreadNum") as? Int{
        return keep
    }else{
        return 0
        }
        }set(keep){
            users.setValue(keep, forKey: "UnreadNum")
        }
    }
    
    //是否打开声音
    static var AreOpenSound:Bool{
        get{
        if let keep = users.valueForKey("AreOpenSound") as? Bool{
        return keep
    }else{
        return true
        }
        }set(keep){
            users.setValue(keep, forKey: "AreOpenSound")
        }
    }
    //引导页的版本号
    static var leadVersion:Int{
        get{
        if let keep = users.valueForKey("leadVersion") as? Int{
        return keep
    }else{
        return 0
        }
        }set(keep){
            users.setValue(keep, forKey: "leadVersion")
        }
    }
    //keepRow
    static var keepRow:Int{
        get{
        if let keep = users.valueForKey("keepRow") as? Int{
        return keep
    }else{
        return 0
        }
        }set(keep){
            users.setValue(keep, forKey: "keepRow")
        }
    }
    //是否可以跳转
    static var CanJump:Bool{
        get{
        if let keep = users.valueForKey("CanJump") as? Bool{
        return keep
    }else{
        return true
        }
        }set(keep){
            users.setValue(keep, forKey: "CanJump")
        }
    }
    //是否可以跳转
    static var CanLoad:Bool{
        get{
        if let keep = users.valueForKey("CanLoad") as? Bool{
        return keep
    }else{
        return true
        }
        }set(keep){
            users.setValue(keep, forKey: "CanLoad")
        }
    }
    //是否可以跳转
    static var CanReload:Bool{
        get{
        if let keep = users.valueForKey("CanReload") as? Bool{
        return keep
    }else{
        return true
        }
        }set(keep){
            users.setValue(keep, forKey: "CanReload")
        }
    }
    //是否可以唤起分享动画
    static var CanShowShare:Bool{
        get{
        if let keep = users.valueForKey("CanShowShare") as? Bool{
        return keep
    }else{
        return true
        }
        }set(keep){
            users.setValue(keep, forKey: "CanShowShare")
        }
    }
    //跳转的feed
    static var PushFeedId:String{
        get{
        if let keep = users.valueForKey("PushFeedId") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "PushFeedId")
        }
    }
    //跳转的uid
    static var PushUid:String{
        get{
        if let keep = users.valueForKey("PushUid") as? String{
        return keep
    }else{
        return ""
        }
        }set(keep){
            users.setValue(keep, forKey: "PushUid")
        }
    }

    
    //sqllite是否建立对应表
    static var sqLiteVersion:Int{
        get{
        if let keep = users.valueForKey("sqLiteVersion") as? Int{
        return keep
    }else{
        return 0
        }
        }set(keep){
            users.setValue(keep, forKey: "sqLiteVersion")
        }
    }
    //分享图片
    static var shareSavePic:UIImage? = UIImage()
    
    static func SaveUserInfo(one:JSON){
        print(one)
        LocalData.uid = one["uid"].stringValue
        LocalData.userPic = one["u_pic"].stringValue
        LocalData.userNick = one["nick_name"].stringValue
        LocalData.userSex = one["gender"].stringValue
        LocalData.userBirth = one["birthday"].stringValue
        
        LocalData.userQQ = one["qq"].stringValue
        LocalData.userWeChat = one["wchat"].stringValue
        LocalData.userWeibo = one["weibo"].stringValue
        LocalData.userMail = one["mail"].stringValue
        LocalData.userIntro = one["sign"].stringValue
        
        
    }

}