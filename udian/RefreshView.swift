//
//  RefreshView.swift
//  udian
//
//  Created by farmerwu_pc on 15/11/8.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

public enum PathElement {
    case MoveToPoint(CGPoint)
    case AddLineToPoint(CGPoint)
    case AddQuadCurveToPoint(CGPoint, CGPoint)
    case AddCurveToPoint(CGPoint, CGPoint, CGPoint)
    case CloseSubpath
    
    init(element: CGPathElement) {
        switch element.type {
        case .MoveToPoint:
            self = .MoveToPoint(element.points[0])
        case .AddLineToPoint:
            self = .AddLineToPoint(element.points[0])
        case .AddQuadCurveToPoint:
            self = .AddQuadCurveToPoint(element.points[0], element.points[1])
        case .AddCurveToPoint:
            self = .AddCurveToPoint(element.points[0], element.points[1], element.points[2])
        case .CloseSubpath:
            self = .CloseSubpath
        }
    }
}

extension UIBezierPath {
    var elements: [PathElement] {
        var pathElements = [PathElement]()
        withUnsafeMutablePointer(&pathElements) { elementsPointer in
            CGPathApply(CGPath, elementsPointer) { (userInfo, nextElementPointer) in
                let nextElement = PathElement(element: nextElementPointer.memory)
                let elementsPointer = UnsafeMutablePointer<[PathElement]>(userInfo)
                elementsPointer.memory.append(nextElement)
            }
        }
        return pathElements
    }
}

class RefreshView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    let show = UILabel()
    var position:CGFloat{
        get{
            return self.PositionSave
        }
        set(keep){
            self.PositionSave = keep
            show.text = "\(keep)"
            show.frame = CGRect(x: self.frame.width/2 - 50, y: 170, width: 100, height: 30)
            self.setNeedsDisplay()
        }
    }
    func path2Path() -> UIBezierPath{
        let path2Path = UIBezierPath()
        let BezierPosition:[CGFloat] = [100.0,30.0,60.0,60.0]
        let APoint = CGPointMake(BezierPosition[0] + BezierPosition[2]/2, BezierPosition[1])
        let BPoint = CGPointMake(BezierPosition[0] + BezierPosition[2], BezierPosition[1] + BezierPosition[3]/2)
        let CPoint = CGPointMake(BezierPosition[0] + BezierPosition[2]/2, BezierPosition[1] + BezierPosition[3])
        let DPoint = CGPointMake(BezierPosition[0] , BezierPosition[1] + BezierPosition[3]/2)
        
        
        let outsideRect = CGRectMake(10, 30, 50, 50)
        let origin_x = 10
        let origin_y = 30
        let offset = outsideRect.size.width / 3.6
        let progress:CGFloat = 0.5
        let movedDistance = (outsideRect.size.width * 1 / 6) * fabs(progress-0.5)*2
        let rectCenter = CGPointMake(outsideRect.origin.x + outsideRect.size.width/2 , outsideRect.origin.y + outsideRect.size.height/2)
        
//        let pointA = CGPointMake(rectCenter.x ,outsideRect.origin.y + movedDistance)
//        let pointB = CGPointMake(movePoint == POINT_D ? rectCenter.x + self.outsideRect.size.width/2 : rectCenter.x + self.outsideRect.size.width/2 + movedDistance*2 ,rectCenter.y)
//        let pointC = CGPointMake(rectCenter.x ,rectCenter.y + self.outsideRect.size.height/2 - movedDistance)
//        let pointD = CGPointMake(self.movePoint == POINT_D ? self.outsideRect.origin.x - movedDistance*2 : self.outsideRect.origin.x, rectCenter.y)
//         
//         
//        let c1 = CGPointMake(pointA.x + offset, pointA.y);
//        let c2 = CGPointMake(pointB.x, self.movePoint == POINT_D ? pointB.y - offset : pointB.y - offset + movedDistance)
//         
//        let c3 = CGPointMake(pointB.x, self.movePoint == POINT_D ? pointB.y + offset : pointB.y + offset - movedDistance)
//        let c4 = CGPointMake(pointC.x + offset, pointC.y);
//         
//        let c5 = CGPointMake(pointC.x - offset, pointC.y);
//        let c6 = CGPointMake(pointD.x, self.movePoint == POINT_D ? pointD.y + offset - movedDistance : pointD.y + offset)
//         
//        let c7 = CGPointMake(pointD.x, self.movePoint == POINT_D ? pointD.y - offset + movedDistance : pointD.y - offset)
//        let c8 = CGPointMake(pointA.x - offset, pointA.y)
        path2Path.moveToPoint(APoint)
        
        path2Path.addCurveToPoint(APoint, controlPoint1:BPoint, controlPoint2:CPoint)
        
        return path2Path;
    }
    
    
    var PositionSave = CGFloat()
    
    override func drawRect(rect: CGRect) {
//        let path2 = CAShapeLayer()
//        path2.frame       = CGRectMake(29.34, 24.04, 33.6, 27.96)
//        path2.fillColor   = nil
//        path2.strokeColor = UIColor.blackColor().CGColor
//        path2.path        = path2Path().CGPath;
//        self.layer.addSublayer(path2)
        let path = UIBezierPath()
//        path.moveToPoint(CGPoint(x: 0, y: 0))
//        path.addLineToPoint(CGPoint(x: 100, y: 0))
//        path.addLineToPoint(CGPoint(x: 50, y: 100))
//        path.closePath()
        let offset = 100 / 3.6
        
        
        path.moveToPoint(CGPoint(x: 100, y: 0))
        path.addCurveToPoint(CGPoint(x: 150, y: 50), controlPoint1: CGPoint(x: 100 + offset, y: 0), controlPoint2: CGPoint(x: 150, y: 50 - offset))
        path.addCurveToPoint(CGPoint(x: 100, y: 100), controlPoint1: CGPoint(x: 150, y: 50 + offset), controlPoint2: CGPoint(x: 100 + offset, y: 100))
        
        
        path.closePath()
        
//        path.moveToPoint(CGPoint(x: 100, y: 0))
//        path.addCurveToPoint(CGPoint(x: 200, y: 0),
//            controlPoint1: CGPoint(x: 125, y: 100),
//            controlPoint2: CGPoint(x: 175, y: -100))
//        path.closePath()
        let path2 = CAShapeLayer()
        path2.path = path.CGPath
        self.layer.addSublayer(path2)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        show.textColor = UIColor.blackColor()
        self.addSubview(show)
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
