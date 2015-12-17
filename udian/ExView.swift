//
//  ExView.swift
//  udian
//
//  Created by Lifefarmer on 15/12/13.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

extension UIView{
    //获取该view的截图
    func ScreenshotFromView()->UIImage{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}