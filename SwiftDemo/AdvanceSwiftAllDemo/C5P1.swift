//
//  C5P1.swift
//  AdvanceSwiftAllDemo
//
//  Created by liaoworking on 2018/11/17.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

class C5P1: NSObject {

    func valueType() {
        
        let mArray:NSMutableArray = [1,2,3,4,5,6,7,8]
        for _ in mArray {///边遍历边操作数组是危险的 这里会崩溃
            mArray.removeAllObjects()
            print("上")
        }
        
        
        let array:[Int] = [1,2,3,4,5,6,7,8]
        for _ in array {
            mArray.removeAllObjects()
        }
        print(mArray.count)
    }
    
}
