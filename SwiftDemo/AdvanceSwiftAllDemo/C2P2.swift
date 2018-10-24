//
//  C2P2.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 10/24/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

class C2P2: NSObject {

    func advanceDictFunc() {
        
        var dict = ["name":"liaoWorking","age":"17"]
        
        
        /// 得到更新键值对之前的值 updateValue
        let oldValue = dict.updateValue("18", forKey: "age")
        print(oldValue) // Optional("17")
        print(dict["age"]) //Optional("18")

        
        ///字典的合并 merge
        let newDict = ["name":"Jane","age":"19","gender":"M"]
        dict.merge(newDict) { (dictValue, newDictValue) -> String in
            print(dictValue)    // liaoworking 相同key时候的dictValue
            print(newDictValue)     //Jane 相同key时候的newDictValue

            return newDictValue //返回你觉得应该选择的value 我这里默认都是newDictValue
        }
        print(dict)
       
        
        ///字典的map方法
        let mapDict = dict.mapValues { (value) -> String in
            return "new"+value
        }
        print(mapDict)//["name": "newliaoWorking", "age": "new18"]

        
    }
    
    
}
