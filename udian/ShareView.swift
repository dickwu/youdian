//
//  ShareView.swift
//  Udian
//
//  Created by farmerwu_pc on 9/2/15.
//  Copyright © 2015 qiuqian. All rights reserved.
//

import UIKit

class ShareView: UIView {

    
    var ShareTitle = String()
    var ShareUrl = String()
    var SharePic = String()
    var ShareTYpe = 0
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    let nowFrame = UIScreen.mainScreen().applicationFrame
    let allback = UIButton()
    let backGround = UILabel()


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        allback.frame = CGRect(x: 0, y: -nowFrame.width*0.8, width: nowFrame.width, height: nowFrame.height + 40 + nowFrame.width*0.8)
        allback.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
        let backHeight = nowFrame.width*0.5
        self.backGround.frame = CGRect(x: 0, y: nowFrame.height + 20 - backHeight, width: nowFrame.width, height: backHeight)
        backGround.backgroundColor = UIColor.whiteColor()
        allback.addTarget(self, action: "Hide", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(allback)
        self.addSubview(backGround)
        loadShareButs(backHeight)
        
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activity.startAnimating()
        activity.stopAnimating()
        
    }

    func loadShareButs(backHeight:CGFloat){
        //firstLine
        let oneWidth:CGFloat = (nowFrame.width - 32)/4
        let firstImage = ["分享触发按钮1","分享触发按钮2","分享触发按钮3","分享触发按钮4"]
        let exLetters = ["微信好友","朋友圈","新浪微博","QQ好友"]
        
        for i in 0...3{
            let ii = CGFloat(i)
            
            let oneBut = UIButton(frame: CGRect(x: 32 + oneWidth * 0.02 + oneWidth*ii, y: nowFrame.height + 40 - backHeight, width: oneWidth*0.6, height: oneWidth*0.6))
            oneBut.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
            oneBut.setTitle("\(i)", forState: UIControlState.Normal)
            oneBut.addTarget(self, action: "shareOut:", forControlEvents: UIControlEvents.TouchUpInside)
            oneBut.setBackgroundImage(UIImage(named: firstImage[i]), forState: UIControlState.Normal)
            let explainLable = UILabel(frame: CGRect(x: 24 + oneWidth * 0.02 + oneWidth*ii, y: nowFrame.height + 46 - backHeight + oneWidth*0.6, width: oneWidth*0.6 + 16, height: 20))
            explainLable.text = exLetters[i]
            explainLable.textAlignment = .Center
            explainLable.font = UIFont.systemFontOfSize(13)
            explainLable.textColor = UIColor.darkGrayColor()
            self.addSubview(oneBut)
            self.addSubview(explainLable)
        }
//        let oneBut = UIButton(frame: CGRect(x: 32 + oneWidth * 0.02, y: nowFrame.height + 72 - backHeight + oneWidth*0.6, width: oneWidth*0.6, height: oneWidth*0.6))
//        oneBut.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
//        oneBut.setTitle("\(3)", forState: UIControlState.Normal)
//        oneBut.addTarget(self, action: "shareOut:", forControlEvents: UIControlEvents.TouchUpInside)
//        oneBut.setBackgroundImage(UIImage(named: firstImage[3]), forState: UIControlState.Normal)
//        let explainLable = UILabel(frame: CGRect(x: 24 + oneWidth * 0.02, y: nowFrame.height + 78 - backHeight + oneWidth*1.2, width: oneWidth*0.6 + 16, height: 20))
//        explainLable.text = exLetters[3]
//        explainLable.textAlignment = .Center
//        explainLable.textColor = UIColor.darkGrayColor()
//        self.addSubview(oneBut)
//        self.addSubview(explainLable)
        
        let cancleBack = UILabel(frame: CGRect(x: 0, y: nowFrame.height + 20 - 60, width: nowFrame.width, height: 60))
        cancleBack.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        let cancleBut = UIButton(frame: CGRect(x: 0, y: nowFrame.height + 20 - 60, width: nowFrame.width, height: 60))
        let cancleIamge = UIImageView(frame: CGRect(x: nowFrame.width/2 - 20, y: nowFrame.height + 20 - 50, width: 40, height: 40))
        cancleIamge.image = UIImage(named: "取消触发按钮")
        cancleBut.addTarget(self, action: "Hide", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(cancleBack)
        self.addSubview(cancleIamge)
        self.addSubview(cancleBut)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func shareOut(sender:UIButton){
        let row = sender.titleLabel!.text!
        var typeOfShare = SSDKPlatformType.TypeUnknown
        let shareParames = NSMutableDictionary()
        
        switch row{
            case "0":
            typeOfShare = .SubTypeWechatSession
            shareParames.SSDKSetupShareParamsByText("大家快来看 \(ShareTitle)",
                images :SharePic,
                url : NSURL(string:ShareUrl),
                title : ShareTitle,
                type : SSDKContentType.Auto)
            if ShareTYpe == 1{
                MobClick.event("AllCommentWechatShare")
            }
            if ShareTYpe == 2{
                MobClick.event("LongOpinionWechatShare")
            }
            case "1":
                typeOfShare = .SubTypeWechatTimeline
                shareParames.SSDKSetupShareParamsByText("大家快来看 \(ShareTitle)",
                    images :SharePic,
                    url : NSURL(string:ShareUrl),
                    title : ShareTitle,
                    type : SSDKContentType.Auto)
            
            if ShareTYpe == 1{
                MobClick.event("AllCommentMomentsShare")
            }
            if ShareTYpe == 2{
                MobClick.event("LongOpinionMomentsShare")
            }
            case "2":
            typeOfShare = .TypeSinaWeibo
            
            shareParames.SSDKSetupShareParamsByText("大家快来看 \(ShareTitle)  \(ShareUrl)" ,
                images :UIImage(named: "LOGO-1"),
                url : NSURL(string:ShareUrl),
                title : ShareTitle,
                type : SSDKContentType.Image)
            if ShareTYpe == 1{
                MobClick.event("AllCommentWeiboShare")
            }
            if ShareTYpe == 2{
                MobClick.event("LongOpinionWeiboShare")
            }
            case "3":
                shareParames.SSDKSetupShareParamsByText("大家快来看 \(ShareTitle)",
                    images :SharePic,
                    url : NSURL(string:ShareUrl),
                    title : ShareTitle,
                    type : SSDKContentType.Auto)
            typeOfShare = .TypeQQ
            if ShareTYpe == 1{
                MobClick.event("AllCommentQQShare")
            }
            if ShareTYpe == 2{
                MobClick.event("LongOpinionQQShare")
            }
        default:break
        }
        
        
        
        
        //2.进行分享
//        ShareSDK.showShareEditor(typeOfShare, otherPlatformTypes: nil, shareParams: shareParames) { (state : SSDKResponseState, _, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!, Bool) -> Void in
//            self.Hide()
//            switch state{
//                
//            case SSDKResponseState.Success:
//                self.Hide()
//                //let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "取消")
//                //alert.show()
//            case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
//                
//            case SSDKResponseState.Cancel:  print("分享取消")
//                
//            default:
//                break
//            }
//        }
        //没有编辑框
        ShareSDK.share(typeOfShare, parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
            self.Hide()
            switch state{
                
            case SSDKResponseState.Success:
                self.Hide()
                //let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "取消")
                //alert.show()
            case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
                
            case SSDKResponseState.Cancel:  print("分享取消")
                
            default:
                break
            }

        }
        
        /*
        ShareSDK.share(typeOfShare, parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
            
        }
*/
        
        
    }
    func Hide(){
        NSNotificationCenter.defaultCenter().postNotificationName("hideShare", object: nil)
        //self.removeFromSuperview()
    }
    
}
