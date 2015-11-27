//
//  secret.swift
//  AllGO
//
//  Created by farmerwu_pc on 15/5/22.
//  Copyright (c) 2015年 qiuqian. All rights reserved.
//

import Foundation
import CryptoSwift
class secret {
    //md5已经集成在CryptoSwift中
    //AES加密
    static func AesEncrypt( key:String, data:String)->String{
        let jia = try! AES(key: key, iv: "", blockMode: CipherBlockMode.ECB)
        let mydata = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let byte = mydata?.arrayOfBytes()
        let jiares = try! jia.encrypt(byte!, padding: PKCS7())
        let resdata = NSData(bytes: jiares, length: jiares.count)
        let jiastrres = resdata.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
        return jiastrres
    }
    //AES解密
    static func AesDecrypt( key:String, data:String)->String{
        let jie = try! AES(key: key, iv: "", blockMode: CipherBlockMode.ECB)
        let nsdata = NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions(rawValue: 0))
        let byte = nsdata?.arrayOfBytes()
        let jieRes = try! jie.decrypt(byte!, padding: PKCS7())
        let resdata = NSData(bytes: jieRes, length: jieRes.count)
        let jiestrres = resdata.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
        let dedata = NSData(base64EncodedString: jiestrres, options: NSDataBase64DecodingOptions(rawValue: 0))
        let base64Decoded = NSString(data: dedata!, encoding: NSUTF8StringEncoding) as! String
        return base64Decoded
    }
    
}