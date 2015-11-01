//
//  emojiKeyboard.swift
//  Udian
//
//  Created by farmerwu_pc on 15/9/7.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class emojiKeyboard: UIView,UIScrollViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var placeHolder = UILabel()
    var EmojiInputview = UITextView!()
    var FeedId = String()
    let page = UIPageControl()
    override init(frame: CGRect) {
        super.init(frame: frame)
        var keyback = UIScrollView(frame: frame)
        loadEmoji(&keyback)
        keyback.delegate = self
        self.addSubview(keyback)
        page.numberOfPages = 3
        page.frame = CGRect(x: frame.width/2 - 50, y: frame.height - 55, width: 100, height: 20)
        page.tintColor = UIColor.lightGrayColor()
        page.currentPageIndicatorTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        
        let sendBut = UIButton(frame: CGRect(x: frame.width - 65, y: frame.height - 35, width: 50, height: 26))
        sendBut.setBackgroundImage(UIImage(named: "发送按钮"), forState: UIControlState.Normal)
        //sendBut.layer.borderWidth = 1
        sendBut.layer.cornerRadius = 4
        sendBut.layer.masksToBounds = true
        //sendBut.layer.borderColor = UIColor.whiteColor().CGColor
        sendBut.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        sendBut.addTarget(self, action: "sendTalk", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(sendBut)
        self.addSubview(page)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func loadEmoji(inout keyback:UIScrollView){
        let allEmoji = Emoji.allEmoji()
        keyback.contentSize = CGSize(width: keyback.frame.width*3, height: keyback.frame.height)
        keyback.pagingEnabled = true
        keyback.showsHorizontalScrollIndicator = false
        keyback.showsVerticalScrollIndicator = false
        let onewidth = (keyback.frame.width - 24)/8
        for i in 0...2{
            let ii = CGFloat(i)
            for j in 0...7{
                let jj = CGFloat(j)
                let emojiback = UIButton(frame: CGRect(x: 10 + onewidth*jj + keyback.frame.width*ii, y: 24, width: onewidth, height: 25))
                emojiback.setTitle(String(allEmoji[i*23 + j]), forState: UIControlState.Normal)
                emojiback.addTarget(self, action: "addEmoji:", forControlEvents: UIControlEvents.TouchUpInside)
                keyback.addSubview(emojiback)
            }
            for j in 0...7{
                let jj = CGFloat(j)
                let emojiback = UIButton(frame: CGRect(x: 10 + onewidth*jj + keyback.frame.width*ii, y: 70, width: onewidth, height: 25))
                emojiback.setTitle(String(allEmoji[i*23 + j + 8]), forState: UIControlState.Normal)
                emojiback.addTarget(self, action: "addEmoji:", forControlEvents: UIControlEvents.TouchUpInside)
                keyback.addSubview(emojiback)
            }
            for j in 0...6{
                let jj = CGFloat(j)
                let emojiback = UIButton(frame: CGRect(x: 10 + onewidth*jj + keyback.frame.width*ii, y: 120, width: onewidth, height: 25))
                emojiback.setTitle(String(allEmoji[i*23 + j + 16]), forState: UIControlState.Normal)
                emojiback.addTarget(self, action: "addEmoji:", forControlEvents: UIControlEvents.TouchUpInside)
                keyback.addSubview(emojiback)
            }
            let deleBut = UIButton(frame: CGRect(x: 14 + onewidth*7 + keyback.frame.width*ii, y: 117, width: onewidth-8, height: 30))
            deleBut.setImage(UIImage(named: "delete"), forState: UIControlState.Normal)
            deleBut.addTarget(self, action: "deleleText", forControlEvents: UIControlEvents.TouchUpInside)
            keyback.addSubview(deleBut)
            
        }
    }
    func sendTalk(){
        print(EmojiInputview.text)
        NSNotificationCenter.defaultCenter().postNotificationName("comment", object: nil)
    }
    
    func addEmoji(sender:UIButton){
        placeHolder.text = ""
        EmojiInputview.text = EmojiInputview.text + sender.titleLabel!.text!
    }
    func deleleText(){
        NSNotificationCenter.defaultCenter().postNotificationName("deleleCommentText", object: nil)
        EmojiInputview.deleteBackward()
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //让底部的小圆点动态跟随图片的滚动而变化
        let point = scrollView.contentOffset.x / self.frame.width
        page.currentPage = Int(point)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
