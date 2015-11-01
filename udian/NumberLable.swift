//
//  NumberLable.swift
//  Udian
//
//  Created by farmerwu_pc on 8/31/15.
//  Copyright © 2015 qiuqian. All rights reserved.
//

import UIKit

class NumberLable: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame:CGRect){
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = frame.height/2
        self.backgroundColor = UIColor(red: 214/255, green: 46/255, blue: 53/255, alpha: 1)
        self.textColor = UIColor.whiteColor()
        if self.text?.length>2{
            self.text = "..."
        }
        self.font = UIFont.systemFontOfSize(12)
        self.textAlignment = .Center
        
    }
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(rect)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
