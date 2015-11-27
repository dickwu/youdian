//
//  Post.swift
//  Udian
//
//  Created by farmerwu_pc on 15/6/22.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import Foundation
import Alamofire

class APIPOST {
    
    //获取地理位子
    static func getCity(com:((city:String)->Void)){
        Alamofire.request(.GET, "http://ip.taobao.com/service/getIpInfo2.php?ip=myip", parameters: nil).responseJSON { (response) -> Void in
            
            if response.result.value != nil{
                let Jres = JSON(response.result.value!)
                //print(Jres)
                let ip = Jres["data"]["ip"].stringValue
                let parame = ["coor":"bd09ll","output":"json","ak":"Q55T7roT63eXRPsKtbGraUcI","ip":ip]
                
                Alamofire.request(.GET, "http://api.map.baidu.com/location/ip", parameters: parame).responseJSON { (response) -> Void in
                    if response.result.value != nil{
                        let city = JSON(response.result.value!)
                        //print(city)
                        if city["status"].stringValue == "0"{
                            let cityName = city["content"]["address"].stringValue
                            //print(cityName)
                            com(city: cityName)
                        }else{
                            //print("国外")
                            com(city: "国外")
                        }
                    }
                }
                
            }
        }
        
    }
    
    
    //短信验证
    static func SMSCheak(PhoneNum:String,code:String,com:((res:String?)->Void)){
        
        let parame = ["account":"qqxxkj_fqxx","pswd":"Fqxx16888","mobile":PhoneNum,"msg":"注册验证码为：\(code) 请完成注册","needstatus":"true"]
        Alamofire.request(.GET, "http://222.73.117.158/msg/HttpBatchSendSM", parameters: parame,encoding: ParameterEncoding.URL).response { (NSURLRequest, NSHTTPURLResponse, Object, Error) -> Void in
            //print(AnyObject)
            MobClick.event("AuthCodeBtnClicked")
            let data = Object! as NSData
            let test = NSString(data: data, encoding: NSUTF8StringEncoding)
            //let error = NSString(string: (Error?.description)!)
            //print(test)
            if let res = test as? String{
                //print(res)
                let ress = NSString(string: res)
                //let time = ress.substringToIndex(14)
                let state : NSString = ress.substringFromIndex(15)
                //print( state.substringToIndex(1))
                //print(time)
                com(res: state.substringToIndex(1))
                
            }else{
                com(res: nil)
            }
        }
        
    }
    
    //用户是否存在
    static func checkAreAready(userID:String,com:((res:Bool)->Void),Error:((res:String?)->Void)){
        let url = Connect.domain + "LoginInterfaceHandler.ashx?msg=TestUserNameExist"
        let parame = ["phone":userID]
        PostData(url, parame: parame) { (Jres, err) -> Void in
            if Jres == nil{
                Error(res: err)
            }else{
                if Jres!["Success"].stringValue == "true"{
                    Error(res: nil)
                    com(res: Jres!["ResultData"]["isExist"].stringValue == "true")
                }else{
                    Error(res: Jres!["Message"].stringValue)
                }
            }
        }

        
        
        
    }
    //检查昵称是否重复
    static func checkNick(nickName:String,com:((res:Bool)->Void),Error:((res:String?)->Void)){
        let url = Connect.domain + "LoginInterfaceHandler.ashx?msg=TestNickNameExist"
        let parame = ["NickName":nickName]
        PostData(url, parame: parame) { (Jres, err) -> Void in
            if Jres == nil{
                Error(res: err)
            }else{
                if Jres!["Success"].stringValue == "true"{
                    Error(res: nil)
                    com(res: Jres!["ResultData"]["isExist"].stringValue == "true")
                }else{
                    Error(res: Jres!["Message"].stringValue)
                }

            }
        }
        
        
    }
    
    
    //密码修改
    static func ChangePass(passWord:String,com:((res:JSON)->Void)){
        //Order/dz_order.html
        let url = Connect.domain + "PersonalCenterHandler.ashx?msg=ChangePassword"
        print(url)
        let dataDic = ["phone":LocalData.userid,"pwd":passWord]
        let data = JSON(dataDic).description
        let key = self.getCode()
        print(data)
        let AesData = secret.AesEncrypt(key.md5().uppercaseString, data: data)
        let parame = ["UserID":key,"Data":AesData]
        print(parame)
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
        
    }
    
    //注册新用户
    static func addnewone(phone:String,pwd:String,nickname:String,headphoto:String,birthday:String,gender:String,com:((res:Bool,err:String?)->Void)){
        let url = Connect.domain + "LoginInterfaceHandler.ashx?msg=Register"
        let dataDic = ["phone":phone.toUInt()!,"pwd":pwd,"nickname":nickname,"headphoto":headphoto,"birthday":birthday,"gender":gender]
        let data = JSON(dataDic).description
        let key = self.getCode()
        let AesData = secret.AesEncrypt(key.md5().uppercaseString, data: data)
        let parame = ["UserID":key,"Data":AesData]
        PostData(url, parame: parame) { (res, err) -> Void in
            if res == nil{
                com(res: false, err: err)
            }else{
                if res!["Success"].stringValue == "true"{

                    com(res: res!["ResultData"]["isSuccess"].stringValue == "true", err: err)
                    
                }else{
                    com(res: false , err: res!["Message"].stringValue)
                }
            }
        }
        
        
    }
    //用户登录
    static func UserLogin(com:((res:Bool,err:String?)->Void)){
        let url = Connect.domain + "LoginInterfaceHandler.ashx?msg=Login"
        let dataDic = ["phone":LocalData.userid,"pwd":LocalData.userPWD.sha512().uppercaseString]
        let data = JSON(dataDic).description
        let key = self.getCode()
        let AesData = secret.AesEncrypt(key.md5().uppercaseString, data: data)
        let parame = ["UserID":key,"Data":AesData]
        PostData(url, parame: parame) { (res, err) -> Void in
            if res == nil{
                com(res: false, err: err)
            }else{
                if res!["Success"].stringValue == "true"{
                    if res!["ResultData"]["isSuccess"].stringValue == "true"{
                        LocalData.SaveUserInfo(res!["ResultData"]["userInformation"])
                        
                        com(res: true, err: nil)
                        BPush.bindChannelWithCompleteHandler({ (AnyObject,Error) -> Void in
                            print(AnyObject)
                            self.BundBaiduPush({ (res) -> Void in
                                
                            })                        })
                    }else{
                        com(res: false, err: "密码错误")
                    }
                }else{
                    com(res: false, err: res!["Message"].stringValue)
                }
            }
        }
        
    }
    
        
    //用户信息修改
    static func changeUserInfo(InformationType:String,InformationValue:String,com:((res:Bool,err:String?)->Void)){
        let url = Connect.domain + "PersonalCenterHandler.ashx?msg=PersonalInformationSet"
        let dataDic = ["phone":LocalData.userid,"InformationType":InformationType,"InformationValue":InformationValue]
        let data = JSON(dataDic).description
        let key = self.getCode()
        let AesData = secret.AesEncrypt(key.md5().uppercaseString, data: data)
        let parame = ["UserID":key,"Data":AesData]
        PostData(url, parame: parame) { (res, err) -> Void in
            if res == nil{
                com(res: false, err: err)
            }else{
                if res!["Success"].stringValue == "true"{
                    com(res: res!["ResultData"]["isSuccess"].stringValue == "true", err: err)
                    UpdateUserInfo(LocalData.uid, com: { (res) -> Void in
                        
                    })
                }else{
                    com(res: false , err: res!["Message"].stringValue)
                }
            }
        }
        
    }
        
        
    //主feed流
    static func MainfeedList(com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/feedApi.php"
        Alamofire.request(.POST, url, parameters: nil,encoding: ParameterEncoding.JSON).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    //加载更多feed
    static func MorefeedList(index:String, com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/list_morefeedApi.php"
        let parame = ["startindex":index]
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }

    
    //点赞与否
    static func Zanfeed(feedid:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/feedcommentApi.php"
        let parame = ["feedid":feedid,"uid":LocalData.uid]
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }

    //投票feed
    static func TouPiaofeed(feedid:String,voteid:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/feedvoteApi.php"
        let parame = ["feedid":feedid,"uid":LocalData.uid,"voteid":voteid]
        
        print(parame)
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    //浏览feed
    static func Liulanfeed(feedid:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/feedbrowserApi.php"
        let parame = ["feedid":feedid]
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    //查看更新feed数据
    static func UpdateSubfeed(feedid:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/feedidApi.php"
        let parame = ["feedid":feedid,"userid":LocalData.uid]
        print(parame)
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    //feed辅助接口
    static func feedMore(feedid:String,com:((res:JSON)->Void)){
        let url = "http://www.findkey.com.cn/editors/youdian/iosapi/apis/getExtraFeedMsgApi.php"
        let parame = ["feedid":feedid]
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    //评论feed
    /*
    voteid voteselect feedid uid commentlocation fromuid fromvoteselect randavatar randname othercommentid  othername

    commentdetail
    */
    static func Commentfeed(commentdetail:String, voteselect:String, feedid:String ,fromuid:String,othername:String,voteid:String,fromvoteselect:String,othercommentid:String,randname:String,randavatar:String,sendtype:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/uploadcommentApi.php"
        let parame = ["feedid":feedid,"uid":LocalData.uid,"randname":randname,"randavatar":randavatar,"commentlocation":LocalData.City,"commentdetail":commentdetail,"voteselect":voteselect,"fromuid":fromuid,"othername":othername,"voteid":voteid,"fromvoteselect":fromvoteselect,"othercommentid":othercommentid,"sendtype":sendtype]
        print(parame)
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    //评论列表
    static func CommentList(feedid:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/getcommentcacheApi.php"
        let parame = ["feedid":feedid,"userid":LocalData.uid]
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    //评论列表的更多
    static func MoreCommentList(feedid:String,startindex:String,direction:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/listmorecommentApi.php"
        let parame = ["feedid":feedid,"userid":LocalData.uid,"startindex":startindex,"direction":direction]
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    //评论跳转
    static func JumpToCommentList(feedid:String,startindex:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/listgotocommentApi.php"
        let parame = ["feedid":feedid,"userid":LocalData.uid,"startindex":startindex]
        print("跳转： \(parame)")
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    
    //评论的头像昵称
    static func CommentUserInfo(uid:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/getusercacheApi.php"
        let parame = ["uid":uid]
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    //评论点赞
    static func CommentCellZan(feedid:String,commentid:String,position:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/commentzanApi.php"
        let parame = ["feedid":feedid,"commentid":commentid,"uid":LocalData.uid,"position":position]
        print(parame)
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
                print("评论点赞结果\(getData)")
            }
        }
    }
    //匿名返回
    static func CommentNoName(feedid:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/getRandnameApi.php"
        let parame = ["feedid":feedid,"uid":LocalData.uid]
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
                
            }
        }
    }
    
    //更新用户头像的缓存
    static func UpdateUserInfo(uid:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/userinfoApi.php"
        let parame = ["uid":uid]
        Alamofire.request(.POST, url, parameters: parame,encoding: ParameterEncoding.URL).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    
    //百度推送绑定
    static func BundBaiduPush(com:((res:NSDictionary)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/userChannelidApi.php"
        let parame = ["uid":LocalData.uid,"baiduid":BPush.getUserId(),"channelid":BPush.getChannelId()]
        Alamofire.request(.POST, url, parameters: parame).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: getData)
            }
        }
    }
    //系统消息列表
    static func SystemInfoList(com:((res:NSDictionary)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/listSysInfoApi.php"
        let parame = ["fromID":LocalData.uid]
        Alamofire.request(.POST, url, parameters: parame).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: getData)
            }
        }
    }
    //已读系统消息
    static func ReadSysrtemInfo(id:String,com:((res:JSON)->Void)){
        let url = "http://www.findkey.com.cn/editors/youdian/iosapi/apis/readSysinfoApi.php"
        let parame = ["infoid":id]
        print(parame)
        Alamofire.request(.POST, url, parameters: parame).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    //删除评论信息
    static func DeletcommentInfo(commentid:String,feedid:String,position:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/deleteCmtApi.php"
        let parame = ["commentid":commentid,"feedid":feedid,"position":position]
        print(parame)
        Alamofire.request(.POST, url, parameters: parame).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    //删除系统消息
    static func DeletSysrtemInfo(id:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/deletesysInfoApi.php"
        let parame = ["infoid":id]
        print(parame)
        Alamofire.request(.POST, url, parameters: parame).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    
    //搜索接口
    static func SearchInfo(contain:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/searchApi.php"
        let parame = ["contain":contain]
        Alamofire.request(.POST, url, parameters: parame).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    //举报接口
    static func ReportInfo(commentid:String,publishuid:String,reportcontain:String,feedid:String,typecontain:String,com:((res:JSON)->Void)){
        let url = "http://139.196.35.146/editors/youdian/iosapi/apis/savereportApi.php"
        let parame = ["reportuid":LocalData.uid,"commentid":commentid,"publishuid":publishuid,"reportcontain":reportcontain,"feedid":feedid,"typecontain":typecontain]
        Alamofire.request(.POST, url, parameters: parame).responseJSON { (response) -> Void in
            if let getData = response.result.value as? NSDictionary{
                com(res: JSON(getData))
            }
        }
    }
    
    
    
    
    

    
    
    
    
    
   static func PostData(url:String,parame: [String: AnyObject],com:((res:JSON?,err:String?)->Void)){
        Alamofire.request(Method.POST,url, parameters: parame).responseJSON { (response) ->  Void in
            if response.result.value == nil{
                com(res: nil, err: "连接出错")
            }else{
                com(res: JSON(response.result.value!), err: nil)
            }
        }
    }
    
    
    
    
    
    
    static func getCode()->String{
        let code = "\(arc4random()%100000000)"
        if code.characters.count != 8{
            return getCode()
        }else{
            return code
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
}