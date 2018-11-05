//
//  C4P2.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 11/5/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

class C4P2: NSObject {
    func optionFunc() {
    
        ///返回值为Optional的实质
        let strArray = ["one","two","three"]
        switch strArray.index(of: "four") {
        case .none:
            print("返回值为空") //返回值为空
        case .some(let idx):
            print(idx)
            print("有值")
        }
        
        
    }
    
    
    
    
}
