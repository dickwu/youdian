//
//  Picture.swift
//  AllGO
//
//  Created by farmerwu_pc on 15/5/28.
//  Copyright (c) 2015年 qiuqian. All rights reserved.
//
import Alamofire
import Foundation
import UIKit
class SPic{
    static func dowmloadPic(url:String , proce:((pro:CGFloat)->Void),com:(img:UIImage?)->Void){
        let manager = SDWebImageManager()
        manager.downloadImageWithURL(NSURL(string:url), options: SDWebImageOptions.HighPriority, progress: { (a, b) -> Void in
            let process = Double(a)/Double(b)
            proce(pro: CGFloat(process))
            }) { (Image, Error, SDImageCacheType, Bool, NSURL) -> Void in
                if Error == nil{
                    com(img: Image)
                }else{
                    com(img: nil)
                }
                
        }
        
    }
    //上传照片不带进度
    static func uploadPic(name:String,Pic:UIImage,com:(succsess:Bool,res:String?)->Void){
        let url = Connect.domain + "LoginInterfaceHandler.ashx?msg=GetToken"
        let upmanage = QNUploadManager()
        let png = UIImagePNGRepresentation(Pic)
        let params = ["":""]
        Alamofire.request(.POST, url, parameters: params).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                //println(getData)
                let json = JSON(getData)
                let token = json["ResultData"]["Token"].stringValue
                upmanage.putData(png, key: name + ".png", token: token, complete: { (QNResponseInfo, Str, _: [NSObject : AnyObject]!) -> Void in
                    if QNResponseInfo.error == nil{
                        com(succsess: true,res: nil)
                    }else{
                        com(succsess: false,res:String(_cocoaString: QNResponseInfo.error!))
                    }
                    
                    print(QNResponseInfo.error)
                    }, option: nil)
            }
            
        }
    }
    
    //上传图片带进度
    static func uploadPicWithPro(name:String,Pic:UIImage,com:(succsess:Bool,res:String?)->Void,processd:((pro:CGFloat)->Void)){
        let url = Connect.domain + "LoginInterfaceHandler.ashx?msg=GetToken"
        let upmanage = QNUploadManager()
        let png = UIImagePNGRepresentation(Pic)
        let params = ["OldPictureUrl":LocalData.KeepuserPic]
        Alamofire.request(.POST, url, parameters: params).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                let json = JSON(getData)
                //print(json)
                let token = json["ResultData"]["Token"].stringValue
                let process = QNUploadOption(progessHandler: { (info, part) -> Void in
                    let parts:CGFloat = CGFloat(part)
                    processd(pro: parts)
                })
                upmanage.putData(png, key: name + ".png", token: token, complete: { (QNResponseInfo, Str, _: [NSObject : AnyObject]!) -> Void in
                    if QNResponseInfo.error == nil{
                        com(succsess: true,res: nil)
                    }else{
                        com(succsess: false,res:String(_cocoaString: QNResponseInfo.error!))
                    }
                }, option: process)
                
            }
            
        }

    }
}