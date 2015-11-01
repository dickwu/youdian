//
//  md5.swift
//  AllGO
//
//  Created by farmerwu_pc on 15/6/25.
//  Copyright © 2015年 qiuqian. All rights reserved.
//

import Foundation

extension String {
    var md5 : String{
        
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
        
        CC_MD5(str!, strLen, result);
        
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.destroy();
        //let res:String = hash as String
        
        return hash as String
    }
}
