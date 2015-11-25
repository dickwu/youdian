//
//  AppDelegate.swift
//  Udian
//
//  Created by farmerwu_pc on 15/6/22.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox

@available(iOS 9.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //iOS8推送（只能本地）
        if LocalData.AreOpenSound {
            let types:UIUserNotificationType = [.Alert, .Badge, .Sound]
            let setting = UIUserNotificationSettings(forTypes: types, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(setting)
        }else{
            let types:UIUserNotificationType = [.Alert, .Badge]
            let setting = UIUserNotificationSettings(forTypes: types, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(setting)
        }
        
        // Override point for customization after application launch.
        let shouldPerformAdditionalDelegateHandling = true
        /*
        // If a shortcut was launched, display its information and take the appropriate action
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            
            launchedShortcutItem = shortcutItem
            
            // This will block "performActionForShortcutItem:completionHandler" from being called.
            shouldPerformAdditionalDelegateHandling = false
        }
        
        // Install initial versions of our two extra dynamic shortcuts.
        if let shortcutItems = application.shortcutItems where shortcutItems.isEmpty {
            // Construct the items.
            //NSDictionary *info1 = @{@"url":@"money"}
            
            let shortcut3 = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.Third.type, localizedTitle: "发布新文章", localizedSubtitle: "随时对身边的事发表态度", icon: UIApplicationShortcutIcon(templateImageName: "钢笔"), userInfo: [
                AppDelegate.applicationShortcutUserInfoIconKey: UIApplicationShortcutIconType.Play.rawValue
                
                ]
            )
            
            let shortcut4 = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.Fourth.type, localizedTitle: "Pause", localizedSubtitle: "Will Pause an item", icon: UIApplicationShortcutIcon(type: .Pause), userInfo: [
                AppDelegate.applicationShortcutUserInfoIconKey: UIApplicationShortcutIconType.Pause.rawValue
                ]
            )
            
            // Update the application providing the initial 'dynamic' shortcut items.
            application.shortcutItems = [shortcut3,shortcut4]
        }

        */
        
        //友盟统计
        MobClick.startWithAppkey("55b8566067e58e5cb000733b")
        
        //设置版本号
        let mainBund = JSON(NSBundle.mainBundle().infoDictionary!)
        MobClick.setAppVersion(mainBund["CFBundleShortVersionString"].stringValue)
        MobClick.setEncryptEnabled(true)//加密日志
        
        //分享
        ShareSDK.registerApp("a1ae4f15d278",
            
            activePlatforms: [SSDKPlatformType.TypeSinaWeibo.rawValue,
                SSDKPlatformType.TypeQQ.rawValue,
                SSDKPlatformType.TypeWechat.rawValue,],
            onImport: {(platform : SSDKPlatformType) -> Void in
                
                switch platform{
                    
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                    
                case SSDKPlatformType.TypeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
            },
            onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                switch platform {
                    
                case SSDKPlatformType.TypeSinaWeibo:
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo.SSDKSetupSinaWeiboByAppKey("3935856201",
                        appSecret : "6a66a38126298fcf91c43e6617eccca1",
                        redirectUri : "http://www.sharesdk.cn",
                        authType : SSDKAuthTypeBoth)
                    break
                    
                case SSDKPlatformType.TypeWechat:
                    //设置微信应用信息
                    appInfo.SSDKSetupWeChatByAppId("wx70f26b94b8544135", appSecret: "26c33aebb311a3e23ddf83fc9404d63e")
                    break
                    
                case SSDKPlatformType.TypeQQ:
                    //设置腾讯QQ应用信息，其中authType设置为只用Web形式授权
                    appInfo.SSDKSetupQQByAppId("1104856656", appKey: "iBRxvRX7AugMUDjb", authType: SSDKAuthTypeBoth)
                    break
                
                default:
                    break
                    
                }
        })
        //百度推送
        BPush.registerChannel(launchOptions, apiKey: "cqzIjOHQlBS8H4NL6ro8Ts40", pushMode: BPushMode.Production, withFirstAction: "", withSecondAction: "", withCategory: "", isDebug: true)
        
        
        return shouldPerformAdditionalDelegateHandling
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //print(deviceToken)
        BPush.registerDeviceToken(deviceToken)
        //print(BPush.getChannelId())
        BPush.bindChannelWithCompleteHandler { (AnyObject, NSError) -> Void in
            
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let JPush = JSON(userInfo)
        print(JPush)
        
        BPush.handleNotification(userInfo)
        
        //定义推送事件一般是@信息 —————— 系统消息也要有不一样的结构,注册一个通用函数以便全局可用
        if application.applicationState == UIApplicationState.Active{
            NSNotificationCenter.defaultCenter().postNotificationName("SystemInfoUpdate", object: nil)
            
        }else{
            let Jdata = JPush["data"]
            LocalData.PushUid = Jdata["uid"].stringValue
            LocalData.PushFeedId = Jdata["feedid"].stringValue
            if Jdata["uid"].stringValue == "0"{
                if Jdata["feedid"].stringValue != "0"{
                    NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "pushView", userInfo: nil, repeats: false)
                }
            }else{
                
                FeedbaseData.saveFeedinfo(Jdata["feedid"].stringValue , comment: Jdata["commentid"].stringValue)
                NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "pushView", userInfo: nil, repeats: false)
            }
        }
    }
    func pushView(){
        NSNotificationCenter.defaultCenter().postNotificationName("PushJump", object: nil)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        let JPush = JSON(userInfo)
        print(JPush)
        BPush.handleNotification(userInfo)
        
        
    }
    /*
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        
        completionHandler(handledShortCutItem)
    }
    
    enum ShortcutIdentifier: String {
        case First
        case Second
        case Third
        case Fourth
        
        // MARK: Initializers
        
        init?(fullType: String) {
            guard let last = fullType.componentsSeparatedByString(".").last else { return nil }
            
            self.init(rawValue: last)
        }
        
        // MARK: Properties
        
        var type: String {
            return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
        }
    }
    
    static let applicationShortcutUserInfoIconKey = "applicationShortcutUserInfoIconKey"

    var launchedShortcutItem: UIApplicationShortcutItem?
    
    @available(iOS 9.0, *)
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        
        // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
        
        guard let shortCutType = shortcutItem.type as String? else { return false }
        
        switch (shortCutType) {
        case ShortcutIdentifier.First.type:
            // Handle shortcut 1 (static).
            handled = true
            break
        case ShortcutIdentifier.Second.type:
            // Handle shortcut 2 (static).
            handled = true
            break
        case ShortcutIdentifier.Third.type:
            // Handle shortcut 3 (dynamic).
            handled = true
            break
        case ShortcutIdentifier.Fourth.type:
            // Handle shortcut 4 (dynamic).
            handled = true
            break
        default:
            break
        }
        
        // Construct an alert using the details of the shortcut used to open the application.
        let alertController = UIAlertController(title: "Shortcut Handled", message: "\"\(shortcutItem.localizedTitle)\"", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        // Display an alert indicating the shortcut selected from the home screen.
        //window!.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        let rootNavigationViewController = window!.rootViewController as? UINavigationController
        let rootViewController = rootNavigationViewController?.viewControllers.first as UIViewController?
        
        rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        return handled
    }
    
    */
    // MARK: Application Life Cycle
    
    func applicationDidBecomeActive(application: UIApplication) {
        
        application.applicationIconBadgeNumber = 0
        print("恢复")
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }



//    func applicationWillTerminate(application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        // Saves changes in the application's managed object context before the application terminates.
//        self.saveContext()
//    }

    // MARK: - Core Data stack

//    lazy var applicationDocumentsDirectory: NSURL = {
//        // The directory the application uses to store the Core Data store file. This code uses a directory named "qiuqian.com.Udian" in the application's documents Application Support directory.
//        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        return urls[urls.count-1]
//    }()
//
//    lazy var managedObjectModel: NSManagedObjectModel = {
//        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
//        let modelURL = NSBundle.mainBundle().URLForResource("udian", withExtension: "momd")!
//        return NSManagedObjectModel(contentsOfURL: modelURL)!
//    }()
//
//    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
//        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
//        // Create the coordinator and store
//        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
//        var failureReason = "There was an error creating or loading the application's saved data."
//        do {
//            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
//        } catch {
//            // Report any error we got.
//            var dict = [String: AnyObject]()
//            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason
//
//            dict[NSUnderlyingErrorKey] = error as NSError
//            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//            // Replace this with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
//            abort()
//        }
//        
//        return coordinator
//    }()
//
//    lazy var managedObjectContext: NSManagedObjectContext = {
//        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
//        let coordinator = self.persistentStoreCoordinator
//        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = coordinator
//        return managedObjectContext
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        if managedObjectContext.hasChanges {
//            do {
//                try managedObjectContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//                abort()
//            }
//        }
//    }

}

