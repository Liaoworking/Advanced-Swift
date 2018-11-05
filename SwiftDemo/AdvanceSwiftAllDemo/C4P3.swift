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
        
        
        
        
    }
    
}
