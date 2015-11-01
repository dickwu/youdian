//
//  seachEmpty.swift
//  Udian
//
//  Created by farmerwu_pc on 15/9/12.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class seachEmpty: UIControl {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var searchKeep = UISearchBar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.addTarget(self, action: "clear", forControlEvents: UIControlEvents.TouchDown)
        
        let words = UILabel(frame: CGRect(x: frame.width/2 - 120, y: 60, width: 240, height: 40))
        words.text = "搜索与文章相关的关键词"
        words.font = UIFont.boldSystemFontOfSize(20)
        words.textColor = UIColor.lightGrayColor()
        words.textAlignment = .Center
        let line = UILabel(frame: CGRect(x: frame.width/2 - 120, y: 100, width: 240, height: 1))
        line.backgroundColor = UIColor.lightGrayColor()
        let pic = UIImageView(frame: CGRect(x: frame.width/2 - 20, y: 116, width: 40, height: 40))
        pic.image = UIImage(named: "文章图标")
        let text = UILabel(frame: CGRect(x: frame.width/2 - 20, y: 160, width: 40, height: 20))
        text.textAlignment = .Center
        text.text = "文章"
        text.font = UIFont.systemFontOfSize(13)
        text.textColor = UIColor.lightGrayColor()
        
        self.addSubview(words)
        self.addSubview(line)
        self.addSubview(pic)
        self.addSubview(text)
    }
    func clear(){
        NSNotificationCenter.defaultCenter().postNotificationName("SearchCancle", object: nil)
        searchKeep.resignFirstResponder()
        self.removeFromSuperview()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
