//
//  aboutUdian.swift
//  Udian
//
//  Created by farmerwu_pc on 15/9/11.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class aboutUdian: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    let nowFrame = UIScreen.mainScreen().applicationFrame
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
        // Do any additional setup after loading the view.
        //去中间间隔线
        self.table.separatorStyle = UITableViewCellSeparatorStyle.None
        //self.table.pagingEnabled = true
        //去空行
        let tblView =  UIView(frame: CGRectZero)
        self.table.backgroundColor = UIColor.whiteColor()
        self.table.tableFooterView = tblView
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return nil
        }else{
            return "   "
        }
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 0
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //print(scrollView.contentOffset.y)
        //scrollView.contentOffset.y = -20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = table.dequeueReusableCellWithIdentifier("one")!
        let image = cell.viewWithTag(10) as! UIImageView
        //image.image = UIImage(named: "引导\(indexPath.section + 1)")
        image.image = UIImage(named: "引导11")
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return nowFrame.width/1242*2208
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
