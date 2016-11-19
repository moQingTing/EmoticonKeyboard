//
//  EmoticonPackage.swift
//  EmoticonKeyBoard
//
//  Created by 莫清霆 on 2016/11/19.
//  Copyright © 2016年 莫清霆. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    var emoticons : [Emoticon] = [Emoticon]()
    
    
    init(id :String) {
        //最近组
        if id == ""{
            return
        }
        
        //根据id 拼接info.plist的路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        print("表情包全路径：\(plistPath)")
        
        //根据plist文件的路径读取数据[[String:String]]
        let array = NSArray(contentsOfFile: plistPath)! as! [[String : String]]
        
        //遍历数组
        for var dict in array {
            if let png = dict["png"] {
                dict["png"] = id + "/" + png
                print("表情：\(dict)")
            }
            
            self.emoticons.append(Emoticon(dict: dict))
        }
    }
}
