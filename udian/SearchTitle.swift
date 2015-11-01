//
//  SearchTitle.swift
//  Udian
//
//  Created by farmerwu_pc on 15/9/12.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class SearchTitle: UIView {


//    let tip = UILabel(frame: CGRect(x: 34, y: 8, width: 50, height: 20))
//    let typePic = UIImageView(frame: CGRect(x: 16, y: 8, width: 20, height: 20))
    let pic = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
//        let backcolor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1)
        self.backgroundColor = UIColor.whiteColor()
        pic.frame = CGRect(x: 8, y: 8, width: frame.width - 16, height: 20)
//        typePic.backgroundColor = backcolor
//        typePic.layer.cornerRadius = 2
//        tip.backgroundColor = backcolor
//        tip.textColor = UIColor.whiteColor()
//        tip.layer.masksToBounds = true
//        tip.layer.cornerRadius = 2
//        tip.textAlignment = .Center
//        tip.font = UIFont.systemFontOfSize(15)
//        let line = UILabel(frame: CGRect(x: 8, y: 27, width: frame.width - 16, height: 1))
//        line.backgroundColor = backcolor
//        self.addSubview(typePic)
//        self.addSubview(tip)
//        self.addSubview(line)
        self.addSubview(pic)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
