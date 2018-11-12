//
//  C4P4.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 11/12/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

class C4P4: NSObject {

    func useOperators() {
        
        let ages = ["liaoWorking":17,"wangzhuxian":16]
        ///有强制解包
        ages.keys.filter { name in ages[name]! < 50 }.sorted()
        ///巧妙的避开了强制解包
        ages.filter { (_, age) in age < 50 }
            .map { (name, _) in name }
            .sorted()
        
        
        
//        ///crash output
//        let s = "foo"
//        let a = Int(s) !! "crash here~"
        
        
    }
    
//    func !! <T>(wrapped:T?, failureText: @autoclosure ()-> String) -> T {
//        <#function body#>
//    }
    
}
