//
//  webView.swift
//  Udian
//
//  Created by farmerwu_pc on 15/8/17.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit

class webViewer: UIViewController,UIWebViewDelegate {

    var url = ""
    let nowFrame = UIScreen.mainScreen().applicationFrame
    let Buttons = [UIButton(),UIButton(),UIButton(),UIButton()]
    @IBOutlet weak var web: UIWebView!
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        let enurl = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())
        web.loadRequest(NSURLRequest(URL: NSURL(string: enurl!)!))
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        changeType()
    }
    func load(){
        let oneWidth = (nowFrame.width - 8)/4
        let picSource = ["浏览器图标1","浏览器图标2","浏览器图标3（不可触发）","浏览器图标4（不可触发）"]
        for i in 0...3{
            let ii = CGFloat(i)
            Buttons[i].frame = CGRect(x: oneWidth*ii + 28 , y: nowFrame.height - 24, width: 40, height: 40)
            Buttons[i].setBackgroundImage(UIImage(named: picSource[i]), forState: UIControlState.Normal)
            self.view.addSubview(Buttons[i])
        }
        Buttons[0].addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        Buttons[1].addTarget(self, action: "refresh", forControlEvents: UIControlEvents.TouchUpInside)
        Buttons[2].addTarget(self, action: "goback", forControlEvents: UIControlEvents.TouchUpInside)
        Buttons[3].addTarget(self, action: "goForward", forControlEvents: UIControlEvents.TouchUpInside)
    }
    func changeType(){
        if web.canGoBack{
            Buttons[2].enabled = true
            Buttons[2].setBackgroundImage(UIImage(named: "浏览器图标3（可触发）"), forState: UIControlState.Normal)
        }else{
            Buttons[2].enabled = false
            Buttons[2].setBackgroundImage(UIImage(named: "浏览器图标3（不可触发）"), forState: UIControlState.Normal)
        }
        if web.canGoForward{
            Buttons[3].enabled = true
            Buttons[3].setBackgroundImage(UIImage(named: "浏览器图标4（可触发）"), forState: UIControlState.Normal)
        }else{
            Buttons[3].enabled = false
            Buttons[3].setBackgroundImage(UIImage(named: "浏览器图标4（不可触发）"), forState: UIControlState.Normal)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    func refresh(){
        web.reload()
    }
    func goback(){
        web.goBack()
    }
    func goForward(){
        web.goForward()
    }

}
