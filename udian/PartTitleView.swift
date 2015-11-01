//
//  PartTitleView.swift
//  Udian
//
//  Created by farmerwu_pc on 15/9/22.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class PartTitleView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    let textMain = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        textMain.frame = CGRect(x: 0, y: 22, width: frame.width, height: 30)
        textMain.textColor = UIColor(red: 152/255, green: 152/255, blue: 152/255, alpha: 1)
        textMain.font = UIFont.systemFontOfSize(14)
        textMain.textAlignment = .Center
        self.addSubview(textMain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
