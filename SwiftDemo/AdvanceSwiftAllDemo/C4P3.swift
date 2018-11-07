//
//  C4P3.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 11/5/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

class C4P3: NSObject {

    func somethingAboutOptional() {
        
        ///if var 的改变不影响原值
        let dict:[String:String]?
        dict = ["key1":"value1"]
        if var varDict = dict {
            varDict["key1"] = "value2"
        }
        print(dict) //Optional(["key1": "value1"])

        
        ///while let
//        while let line = printLine() {
//            print(line)
//        }
        
        
        let testOptionalChainingObj = testOptionalChaining()
        testOptionalChainingObj.voidCallback = {
            print("Hi~ I am callback~")
        }
        testOptionalChainingObj.testCall()

        20.half?.half?.half?.half
        
        
        var number: Int?
        number = nil
        String(number ?? 5)
    }
    
}


/// 测试可选链
class testOptionalChaining: NSObject {
    
    var voidCallback:(()-> Void)?
    
    func testCall() {
        voidCallback?()
        //不推荐的写法(直到写笔记的时候才发现自己之前这样写都写复杂了，一点swift的优点都没体现出来😂)
        if voidCallback != nil {
            voidCallback!()
        }
        
    }
    
    
}


extension Int {
    
    var half: Int? {
        guard self > 1 else {return nil}
        return self/2
    }
    
}
