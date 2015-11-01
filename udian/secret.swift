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
    static func AesEncrypt( key:String, data:String)->String?{
        let keydata = key.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)?.arrayOfBytes()
        //let jia = AES(key: key, iv: "13916728775", blockMode: CipherBlockMode.ECB)
        let jia = AES(key: keydata!, blockMode: CipherBlockMode.ECB)
        //let jia = CryptoSwift.AES(key: key.md5()!.uppercaseString, iv: "13916728775", blockMode: CryptoSwift.CipherBlockMode.ECB)
        let mydata = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let byte = mydata?.arrayOfBytes()
        //let jiares =  jia?.encrypt(byte!, padding: CryptoSwift.PKCS7())
        let jiares = try! jia?.encrypt(byte!, padding: PKCS7())
        let resdata = NSData(bytes: jiares!, length: jiares!.count)
        let jiastrres = resdata.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
        return jiastrres
    }
    
    static func AesDeEncrypt(key:String,data:String)->String?{
        let keydata = key.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)?.arrayOfBytes()
        let jie = AES(key: keydata!, blockMode: CipherBlockMode.ECB)
        let mydata = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let byte = mydata?.arrayOfBytes()
        let jieRes =  try! jie?.decrypt(byte!, padding: PKCS7())
        let resdata = NSData(bytes: jieRes!, length: jieRes!.count)
        let jiastrres = resdata.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
        return jiastrres
    }
    
}