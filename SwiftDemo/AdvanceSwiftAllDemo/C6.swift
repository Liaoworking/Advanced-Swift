//
//  C6.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 12/4/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

class C6: NSObject {

    
    
    func function() {
        loveSomeBodyFunc = loveSomeBody
        loveSomeBodyFunc?("liaoWorking")//I love liaoWorking
        doSomeThing(things: loveSomeBodyFunc)
        loveSomeBodyFunc = lovingYou()
    }
    
    
    func loveSomeBody(name:String) {
        print("I love \(name)")
    }
    ///函数作为参数
    func doSomeThing(things: ((String)-> Void)?) {
        things?("NObody")
    }
    
    var loveSomeBodyFunc:((String) ->Void)?

    ///函数作为返回值
    func lovingYou() -> ((String) ->Void)?{
        return loveSomeBody
    }
}
