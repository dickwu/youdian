//
//  localFeed.swift
//  udian
//
//  Created by farmerwu_pc on 15/10/8.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import Foundation
import SQLite


class FeedbaseData {
    
    static let id = Expression<Int64>("id")
    static let feedid = Expression<String?>("feedid")
    static let commentid = Expression<String>("commentid")
    static let choicedid = Expression<String>("choicedid")
    
    
    
    static func saveFeedinfo(feed:String,comment:String){
        do {
            let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let docDir = path[0] as String
            let db = try Connection("\(docDir)/feeddb.sqlite3")
            
            let feeds = Table("feed")
            
            if LocalData.sqLiteVersion == 0 {
            
                try db.run(feeds.create { t in
                    t.column(id, primaryKey: true)
                    t.column(feedid,unique:true)
                    t.column(commentid)
                    t.column(choicedid)
                    })
                LocalData.sqLiteVersion = 1
            }
            var AreNeedCreat = true
            for _ in db.prepare(feeds.filter(feedid == feed)) {
                AreNeedCreat = false
            }
            if AreNeedCreat{
                try db.run(feeds.insert(feedid <- feed,commentid <- comment))
            }else{
                let alice = feeds.filter(feedid == feed)
                let update = alice.update(commentid <- comment)
                try db.run(update)
            }

            for user in db.prepare(feeds.filter(feedid == feed)) {
                print("id: \(user[feedid]), commentFloor: \(user[commentid])")
            }
            
        }catch{
            print("sqllite error")
        }

    }
    static func getsavedCommentid(feed:String)->String{
        var comment = String()
        do {
            let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let docDir = path[0] as String
            let db = try Connection("\(docDir)/feeddb.sqlite3")
            let feeds = Table("feed")
            var AreNeedCreat = true
            for user in db.prepare(feeds.filter(feedid == feed)) {
                //print("id: \(user[feedid]), commentid: \(user[commentid])")
                AreNeedCreat = false
                comment = user[commentid]
            }
            if AreNeedCreat{
                self.saveFeedinfo(feed, comment: "-1")
                comment = "-1"
            }
            
        }catch{
            print("sqllite error")
            
        }
        return comment
        
    }
    
    
    static func getSavedChoiceId(feed:String)->String{
        var comment = String()
        do {
            let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let docDir = path[0] as String
            let db = try Connection("\(docDir)/feeddb.sqlite3")
            let feeds = Table("feed")
            var AreNeedCreat = true
            for user in db.prepare(feeds.filter(feedid == feed)) {
                //print("id: \(user[feedid]), commentid: \(user[commentid])")
                AreNeedCreat = false
                comment = user[choicedid]
            }
            if AreNeedCreat{
                self.saveChoicedId(feed, comment: "0")
                comment = "0"
            }
            
        }catch{
            print("sqllite error")
            
        }
        return comment
        
    }
    
    static func saveChoicedId(feed:String,comment:String){
        do {
            let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let docDir = path[0] as String
            let db = try Connection("\(docDir)/feeddb.sqlite3")
            
            let feeds = Table("feed")
            
            if LocalData.sqLiteVersion == 0 {
                
                try db.run(feeds.create { t in
                    t.column(id, primaryKey: true)
                    t.column(feedid,unique:true)
                    t.column(commentid)
                    t.column(choicedid)
                    })
                LocalData.sqLiteVersion = 1
            }
            var AreNeedCreat = true
            for _ in db.prepare(feeds.filter(feedid == feed)) {
                AreNeedCreat = false
            }
            if AreNeedCreat{
                try db.run(feeds.insert(feedid <- feed,commentid <- "-1", choicedid <- comment))
            }else{
                let alice = feeds.filter(feedid == feed)
                let update = alice.update(choicedid <- comment)
                try db.run(update)
            }
            
            for user in db.prepare(feeds.filter(feedid == feed)) {
                print("id: \(user[feedid]), commentChoicedID: \(user[choicedid])")
            }
            
        }catch{
            print("sqllite error")
        }
        
    }
    
    
    
    
    
    
    
    
}
    
    
    
    
    
    
    
    
    


