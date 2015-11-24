//
//  ExMainView.swift
//  Udian
//
//  Created by farmerwu_pc on 15/9/12.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import Foundation
extension ViewController{
    
    
    
    func loadNotSearchCell(indexPath:NSIndexPath)->UITableViewCell{
        var cell = UITableViewCell()
        let row = indexPath.row
        Moreactivity.removeFromSuperview()
        if AreNeedMore && indexPath.row == feedLists.count{
            
            Moreactivity.center = CGPoint(x: nowFrame.width/2, y: 30)
            cell.addSubview(Moreactivity)
            Moreactivity.startAnimating()
            loadmoreFeed()
            
        }else{
            if feedLists[row].AreAtTitle{
                if row == 0 && feedLists[row].commentTitle == "" {
                    return cell
                }else{
                    cell.backgroundColor = UIColor.whiteColor()
                    let extitle = PartTitleView(frame: CGRect(x: 0, y: 0, width: table.frame.width, height: 60))
                    extitle.textMain.text = feedLists[row].commentTitle
                    extitle.tag = 900
                    
                    cell.addSubview(extitle)
                }
            }else{
                cell = self.table.dequeueReusableCellWithIdentifier("ones")!
                for one in cell.subviews{
                    if one.tag > 100{
                        one.removeFromSuperview()
                    }
                }
                
                let backImage = cell.viewWithTag(10) as! UIImageView
                let tippic = cell.viewWithTag(11) as! UIImageView
                let tip = cell.viewWithTag(12) as! UILabel
                let commenNum = cell.viewWithTag(13) as! UILabel
                let lookNum = cell.viewWithTag(14) as! UILabel
                let likeNum = cell.viewWithTag(15) as! UILabel
                

                
                commenNum.text = feedLists[row].comments
                lookNum.text = feedLists[row].lookNum
                likeNum.text = feedLists[row].Likes
                
                backImage.layer.masksToBounds = true
                backImage.layer.cornerRadius = 4
                
                //tip.layer.shadowOpacity = 1
                tip.shadowColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.6)
                tip.shadowOffset = CGSize(width: 1.25, height: 1.25)
                
                //tip.layer.shadowOffset = CGSizeMake(2.5, 2.0)
                if nowFrame.width > 375{
                    tip.font = UIFont.boldSystemFontOfSize(22)
                }else{
                    if nowFrame.width < 350{
                        tip.font = UIFont.boldSystemFontOfSize(17)
                    }else{
                        tip.font = UIFont.boldSystemFontOfSize(20)
                    }
                }
                
                backImage.yy_setImageWithURL(NSURL(string:feedLists[row].backImag)!, options: [YYWebImageOptions.ProgressiveBlur , YYWebImageOptions.SetImageWithFadeAnimation])
                
                
                SPic.dowmloadPic(feedLists[row].tipPic, proce: { (pro) -> Void in
                    
                    }) { (img) -> Void in
                        tippic.image = img
                }
                if feedLists[row].feedlei.count != 0{
                    if feedLists[row].feedlei.count <= 4{
                        let num = CGFloat(feedLists[row].feedlei.count)
                        let firstline = num*30
                        let linewidth = (nowFrame.width - firstline)/2
                        
                        for i in 0...feedLists[row].feedlei.count-1{
                            let ii = CGFloat(i)
                            let leipic = UIImageView(frame: CGRect(x: (nowFrame.width - firstline)/2 + ii*35  , y: nowFrame.width/1200*750/2 + 8, width: 33.8, height: 20))
                            leipic.tag = 500 + i
                            leipic.image = UIImage(named: feedLists[row].feedlei[i])
                            cell.addSubview(leipic)
                            if feedLists[row].feedlei.count != 1 && i != feedLists[row].feedlei.count-1{
                                let line = UILabel(frame: CGRect(x: linewidth - 2 + ((ii+1)*35), y: nowFrame.width/1200*750/2 + 9, width: 1, height: 17))
                                line.backgroundColor = UIColor.whiteColor()
                                line.tag = 600 + i
                                cell.addSubview(line)
                            }
                        }
                    }else{
                        
                        let firstline:CGFloat = 4*30
                        let linewidth = (nowFrame.width - firstline)/2
                        for i in 0...3{
                            let ii = CGFloat(i)
                            let leipic = UIImageView(frame: CGRect(x: (nowFrame.width - firstline)/2 + ii*35  , y: nowFrame.width/1200*750/2 + 8, width: 33.8, height: 20))
                            leipic.tag = 700 + i
                            leipic.image = UIImage(named: feedLists[row].feedlei[i])
                            cell.addSubview(leipic)
                            if i != 3{
                                let line = UILabel(frame: CGRect(x: linewidth - 2 + ((ii+1)*35), y: nowFrame.width/1200*750/2 + 9, width: 1, height: 17))
                                line.backgroundColor = UIColor.whiteColor()
                                line.tag = 800 + i
                                cell.addSubview(line)
                            }
                        }
                        let num = CGFloat(feedLists[row].feedlei.count-4)
                        
                        let Twoline = num*26
                        let Twowidth = (nowFrame.width - Twoline )/2
                        for i in 4...feedLists[row].feedlei.count-1{
                            let ii = CGFloat(i-4)
                            let leipic = UIImageView(frame: CGRect(x: (nowFrame.width - Twoline)/2 + ii*35  , y: nowFrame.width/1200*750/2 + 40, width: 33.8, height: 20))
                            leipic.tag = 550 + i
                            leipic.image = UIImage(named: feedLists[row].feedlei[i])
                            cell.addSubview(leipic)
                            if feedLists[row].feedlei.count != 1 && i != feedLists[row].feedlei.count-1{
                                let line = UILabel(frame: CGRect(x: Twowidth - 2 + ((ii+1)*36), y: nowFrame.width/1200*750/2 + 43, width: 1, height: 17))
                                line.backgroundColor = UIColor.whiteColor()
                                line.tag = 650 + i
                                cell.addSubview(line)
                            }
                        }
                        
                        
                    }
                    
                }
                tip.text = feedLists[row].Tips
                let goBut = UIButton(frame: CGRect(x: 0, y: 0, width: nowFrame.width, height: nowFrame.width/1200*750))
                goBut.setTitle("\(row)", forState: UIControlState.Normal)
                goBut.tag = 200
                goBut.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
                goBut.addTarget(self, action: "gotoDetil:", forControlEvents: UIControlEvents.TouchUpInside)
                cell.addSubview(goBut)
            }
        }
        return cell
    }
    
    
    func loadData(){
        self.feedlen = 0
        //finishFresh
        if AreNotAtSearch{
            
            APIPOST.MainfeedList({ (res) -> Void in
                self.feedLists  = [Onefeed]()
                self.finishFresh()
                self.AreNeedMore = res["data"]["length"].intValue > 0
                let Jres = res["data"]["data"].arrayValue
                //print(res)
//                self.refresh.frame = CGRect(x: 0, y: -200, width: self.table.frame.width, height: 200)
//                self.table.addSubview(self.refresh)
//                self.table.sendSubviewToBack(self.refresh)
                
                self.feedlen = Jres.count
                for one in Jres{
                    let TitleFee = Onefeed()
                    TitleFee.AreAtTitle = true
                    TitleFee.commentTitle = one["extitle"].stringValue
                    if self.feedLists.count == 0{
                        self.feedLists.append(TitleFee)
                        self.len = 0
                    }else{
                        if self.feedLists[self.len].commentTitle != one["extitle"].stringValue{
                            self.feedLists.append(TitleFee)
                            self.len = self.feedLists.count - 1
                        }else{
                            
                        }
                        
                    }
                    
                    let onefee = Onefeed()
                    onefee.AreAtTitle = false
                    onefee.IDs = one["feed_id"].stringValue
                    onefee.Tips = one["title"].stringValue
                    onefee.backImag = one["feed_bg"].stringValue
                    onefee.tipPic = one["leimu"].stringValue
                    let fenlei = one["fenlei"].arrayValue
                    
                    var leiKeep = [String]()
                    for o in fenlei{
                        leiKeep.append(o.stringValue)
                    }
                    onefee.feedlei = leiKeep
                    
                    onefee.boundLong = one["match_points"].intValue
                    onefee.quanMinUrl = one["commndurl"].stringValue
                    onefee.changGuandianUrl = one["lpointurl"].stringValue
                    //投票
                    onefee.commentTitle = one["votegroup"]["title"].stringValue
                    let toupiaos = one["votegroup"]["vote_contain"].arrayValue
                    for tou in toupiaos{
                        onefee.commentNums.append(tou["vote_num"].intValue)
                        onefee.CommentIDS.append(tou["vote_id"].stringValue)
                        onefee.commentTips.append(tou["contain"].stringValue)
                    }
                    
                    onefee.lookNum = one["votenumber"].stringValue
                    onefee.comments = one["comment_num"].stringValue
                    onefee.Likes = one["care_num"].stringValue
                    
                    self.feedLists.append(onefee)
                    
                    
                }
                self.table.reloadData()
                
            })
        }else{
            //搜索
            searchOne()
        }
        
    }
    func loadmoreFeed(){
        APIPOST.MorefeedList("\(feedlen)") { (res) -> Void in
            
            self.AreNeedMore = res["data"]["length"].intValue > 0
            let Jres = res["data"]["data"].arrayValue
            self.feedlen += Jres.count
            print(res)
            for one in Jres{
                let TitleFee = Onefeed()
                TitleFee.AreAtTitle = true
                TitleFee.commentTitle = one["extitle"].stringValue
                if self.feedLists.count == 0{
                    self.feedLists.append(TitleFee)
                    self.len = 0
                }else{
                    if self.feedLists[self.len].commentTitle != one["extitle"].stringValue{
                        self.feedLists.append(TitleFee)
                        self.len = self.feedLists.count - 1
                    }else{
                        
                    }
                    
                }
                
                let onefee = Onefeed()
                onefee.AreAtTitle = false
                onefee.IDs = one["feed_id"].stringValue
                onefee.Tips = one["title"].stringValue
                onefee.backImag = one["feed_bg"].stringValue
                onefee.tipPic = one["leimu"].stringValue
                let fenlei = one["fenlei"].arrayValue
                
                var leiKeep = [String]()
                for o in fenlei{
                    leiKeep.append(o.stringValue)
                }
                onefee.feedlei = leiKeep
                
                onefee.boundLong = one["match_points"].intValue
                onefee.quanMinUrl = one["commndurl"].stringValue
                onefee.changGuandianUrl = one["lpointurl"].stringValue
                //投票
                onefee.commentTitle = one["votegroup"]["title"].stringValue
                let toupiaos = one["votegroup"]["vote_contain"].arrayValue
                for tou in toupiaos{
                    onefee.commentNums.append(tou["vote_num"].intValue)
                    onefee.CommentIDS.append(tou["vote_id"].stringValue)
                    onefee.commentTips.append(tou["contain"].stringValue)
                }
                
                onefee.lookNum = one["votenumber"].stringValue
                onefee.comments = one["comment_num"].stringValue
                onefee.Likes = one["care_num"].stringValue
                
                self.feedLists.append(onefee)
                
                
            }
            self.table.reloadData()

        }
        
        
    }
    
    
    
    
    
    func searchOne(){
        SearchResType = 0
        SearchTitles = [SearchOne]()
        SearchCounts = [SearchTwo]()
        self.table.reloadData()
        APIPOST.SearchInfo(search.text!, com: { (res) -> Void in
            //print(res)
            let OneData = res["feedlist"].arrayValue
            self.SearchResTitleNum = OneData.count
            for one in OneData{
                let OneSer = SearchOne()
                OneSer.feedid = one["feed_id"].stringValue
                OneSer.backImag = one["feed_bg"].stringValue
                OneSer.Tips = one["title"].stringValue
                OneSer.tipPic = one["leimu"].stringValue
                OneSer.comments = one["comment_num"].stringValue
                OneSer.lookNum = one["votenum"].stringValue
                OneSer.Likes = one["care_num"].stringValue
                self.SearchTitles.append(OneSer)
            }
            
            let TwoData = res["articlelist"].arrayValue
            
            for one in TwoData{
                let OneSer = SearchTwo()
                OneSer.feedid = one["feed_id"].stringValue
                if one["feed_id"] == nil{
                    continue
                }
                OneSer.MainPic = one["feed_bg"].stringValue
                OneSer.tipImag = one["userpic"].stringValue
                OneSer.Tips = one["art_title"].stringValue
                OneSer.tipCount = one["art_abt"].stringValue
                OneSer.tipName = one["username"].stringValue
                OneSer.time = one["time"].stringValue
                
                OneSer.comments = one["comment_num"].stringValue
                OneSer.lookNum = one["votenum"].stringValue
                OneSer.Likes = one["care_num"].stringValue
                self.SearchCounts.append(OneSer)
            }
            self.SearchResCountNum = self.SearchCounts.count
            
            
            
            if self.SearchResCountNum == 0 && self.SearchResTitleNum == 0 {
                self.SearchResType = 0
                self.showSearchEmpty()
            }else{
                if self.SearchResCountNum != 0 && self.SearchResTitleNum != 0 {
                    self.SearchResType = 2
                }else{
                    self.SearchResType = 1
                }
                self.searchback.removeFromSuperview()
                self.SearchEmptyBack.removeFromSuperview()
            }
            
            
            
            self.table.reloadData()
            
            
            
        })

    }
    func showSearchEmpty(){
        SearchEmptyBack.frame = self.table.frame
        SearchEmptyBack.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        SearchEmptyBack.addTarget(self, action: "hideSearchEmpty", forControlEvents: UIControlEvents.TouchUpInside)
        let EmptyPic = UIImageView(frame: CGRect(x: self.table.frame.width/2 - 50, y: 120, width: 100, height: 100))
        EmptyPic.image = UIImage(named: "emptyBack")
        let EmptyText = UILabel(frame: CGRect(x: self.table.frame.width/2 - 150, y: 240, width: 300, height: 40))
        EmptyText.text = "抱歉，没有找到你搜索的内容"
        EmptyText.textAlignment = .Center
        EmptyText.textColor = UIColor.lightGrayColor()
        SearchEmptyBack.addSubview(EmptyPic)
        SearchEmptyBack.addSubview(EmptyText)
        self.view.addSubview(SearchEmptyBack)
        
    }
    func hideSearchEmpty(){
        searchback.removeFromSuperview()
        SearchEmptyBack.removeFromSuperview()
        search.becomeFirstResponder()
       
    }
    func loadSearchTitle(row:Int) -> UITableViewCell{
        let cell = self.table.dequeueReusableCellWithIdentifier("sone")!
        let backImage = cell.viewWithTag(10) as! UIImageView
        //let tippic = cell.viewWithTag(11) as! UIImageView
        let tip = cell.viewWithTag(12) as! UILabel
        
        let commenNum = cell.viewWithTag(13) as! UILabel
        let lookNum = cell.viewWithTag(14) as! UILabel
        let likeNum = cell.viewWithTag(15) as! UILabel
        let goBut = cell.viewWithTag(16) as! UIButton
        let leiPic = cell.viewWithTag(30) as! UIImageView
        
        tip.shadowColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.6)
        tip.shadowOffset = CGSize(width: 1.25, height: 1.25)
        
        backImage.layer.masksToBounds = true
        backImage.layer.cornerRadius = 6
        backImage.yy_setImageWithURL(NSURL(string:SearchTitles[row].backImag)!, options: [YYWebImageOptions.ProgressiveBlur , YYWebImageOptions.SetImageWithFadeAnimation])

        
        let MainTitle:NSString = SearchTitles[row].Tips
        let attri = NSMutableAttributedString(string: MainTitle as String)
        let attributesForRed:[String:AnyObject] = [
            //  设置字号为60
            NSFontAttributeName:UIFont.boldSystemFontOfSize(20),
            //  设置文本颜色为黄色
            NSForegroundColorAttributeName:UIColor(red: 44/255, green: 150/255, blue: 200/255, alpha: 1)
        ]
        attri.setAttributes(attributesForRed, range: MainTitle.rangeOfString("\(search.text!)"))
        tip.attributedText = attri
        
        commenNum.text = SearchTitles[row].comments
        lookNum.text = SearchTitles[row].lookNum
        likeNum.text = SearchTitles[row].Likes
        
        SPic.dowmloadPic(SearchTitles[row].tipPic, proce: { (pro) -> Void in
            
            }) { (img) -> Void in
                leiPic.image = img
        }
        
        
        goBut.setTitle("\(row)", forState: UIControlState.Normal)
        goBut.addTarget(self, action: "OneGoToDetiel:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        return cell
    }
    func loadSearchCount(row:Int) -> UITableViewCell{
        let cell = self.table.dequeueReusableCellWithIdentifier("stwo")!
        let mainPic = cell.viewWithTag(10) as! UIImageView
        let tip = cell.viewWithTag(11) as! UILabel
        let tipCount = cell.viewWithTag(12) as! UILabel
        let tipPic = cell.viewWithTag(13) as! UIImageView
        let tipName = cell.viewWithTag(14) as! UILabel
        let tipTime = cell.viewWithTag(25) as! UILabel
        
        mainPic.layer.masksToBounds = true
        let back = cell.viewWithTag(20) as! UILabel

        tipPic.layer.masksToBounds = true
        tipPic.layer.cornerRadius = 10
        
        back.layer.masksToBounds = true
        back.layer.cornerRadius = 6
        back.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
        back.layer.borderWidth = 1
        
        let timeDate = SearchCounts[row].time
        let date = timeDate.toDateTime("yyyy-MM-dd HH:mm:ss")!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm yyyy-MM-dd"
        let text = dateFormatter.stringFromDate(date)
        tipTime.text = text
            
        SPic.dowmloadPic(SearchCounts[row].MainPic, proce: { (pro) -> Void in
            
            }) { (img) -> Void in
                mainPic.image = img
        }
        let MainTitle:NSString = SearchCounts[row].Tips
        
        let attri = NSMutableAttributedString(string: MainTitle as String)
        let attributesForTitle:[String:AnyObject] = [
            NSFontAttributeName:UIFont.boldSystemFontOfSize(18),
            NSForegroundColorAttributeName:UIColor(red: 44/255, green: 150/255, blue: 200/255, alpha: 1)
        ]
        
        
        attri.setAttributes(attributesForTitle, range: MainTitle.rangeOfString("\(search.text!)"))
        tip.attributedText = attri
        
        
        let TipCountS:NSString = SearchCounts[row].tipCount
        let attri2 = NSMutableAttributedString(string: TipCountS as String)
        let attributesForCount:[String:AnyObject] = [
            NSFontAttributeName:UIFont.boldSystemFontOfSize(14),
            NSForegroundColorAttributeName:UIColor(red: 44/255, green: 150/255, blue: 200/255, alpha: 1)
        ]
        attri2.setAttributes(attributesForCount, range: TipCountS.rangeOfString("\(search.text!)"))
        tipCount.attributedText = attri2
        
        SPic.dowmloadPic(SearchCounts[row].tipImag, proce: { (pro) -> Void in
            
            }) { (img) -> Void in
                tipPic.image = img
        }
        tipName.text = SearchCounts[row].tipName
        
        
       
        let goBut = cell.viewWithTag(18) as! UIButton
        goBut.setTitle("\(row)", forState: UIControlState.Normal)
        goBut.addTarget(self, action: "OwoGoToDetiel:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        return cell
    }
    
    func OneGoToDetiel(sender:UIButton){
        let row = Int(sender.titleLabel!.text!.toUInt()!)
        SearchgotoFeedDetil(SearchTitles[row].feedid)
        
    }
    func OwoGoToDetiel(sender:UIButton){
        let row = Int(sender.titleLabel!.text!.toUInt()!)
        SearchgotoFeedDetil(SearchCounts[row].feedid)
        
    }
    func SearchgotoFeedDetil(feedid:String) {
        let story = UIStoryboard(name: "Main", bundle: nil)//获取故事版
        let filte = story.instantiateViewControllerWithIdentifier("TwoChange") as! TwoChange//定位视图
        filte.AreLeft = true
        filte.IdOfFeed = feedid
        APIPOST.feedMore(feedid) { (res) -> Void in
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
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if AreNotAtSearch{
            
            return 0
        }else{
            
            return 34
            
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if AreNotAtSearch || SearchResType == 0{
//
//            extitle.textMain.text = PartTitle[section]
            
            return nil
        }else{
            if SearchResType == 2{
                let nowhead = SearchTitle(frame: CGRect(x: 0, y: 0, width: table.frame.width, height: 20))
                if section == 0{
                    nowhead.pic.image = UIImage(named: "分类图标（标题）")
                }else{
                    nowhead.pic.image = UIImage(named: "分类图标（内容）")
                }
                return nowhead
            }else{
                let nowhead = SearchTitle(frame: CGRect(x: 0, y: 0, width: table.frame.width, height: 20))
                if SearchResTitleNum != 0{
                    nowhead.pic.image = UIImage(named: "分类图标（标题）")
                }else{
                    nowhead.pic.image = UIImage(named: "分类图标（内容）")
                }
                return nowhead
            }
        }
        
    }
    
    
    
    
}