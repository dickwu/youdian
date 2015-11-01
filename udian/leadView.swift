//
//  leadView.swift
//  Udian
//
//  Created by farmerwu_pc on 15/9/11.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class leadView: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var lead: UIScrollView!
    @IBOutlet weak var page: UIPageControl!
    
    
    //UIScreen.mainScreen().bounds
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.

        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "loadIamge", userInfo: nil, repeats: false)
    }
    func loadIamge(){
        let nowFrame = lead.frame
        lead.contentSize = CGSize(width: nowFrame.width*4, height: nowFrame.height)
        for i in 0...3{
            let ii = CGFloat(i)
            let loadImage = UIImageView(frame: CGRect(x: ii*nowFrame.width, y: 0, width: nowFrame.width, height: nowFrame.height))
            loadImage.image = UIImage(named: "引导1\(6+i)")
            self.lead.addSubview(loadImage)
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //让底部的小圆点动态跟随图片的滚动而变化
        let point = scrollView.contentOffset.x / lead.frame.width
        page.currentPage = Int(point)
        if scrollView.contentOffset.x > lead.frame.width*3 + 30{
            self.navigationController?.popViewControllerAnimated(false)
            LocalData.leadVersion = 1
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
