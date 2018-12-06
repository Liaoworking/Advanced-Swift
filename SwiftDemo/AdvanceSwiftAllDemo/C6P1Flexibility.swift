//
//  C6P1Flexibility.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 12/6/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

class C6P1Flexibility: NSObject {

    func flexibilityDemo() {
        
        var mArray = [3, 1, 2]
        mArray.sort() ///1 2 3
        mArray.sort(by: >)  ///3 2 1
        
        print(mArray)
        
        
        let animal = ["fish", "dog", "elephant"]
        ///反向比较字符串的大小  我们可以嵌套任意的比较函数  让排序功能更强大！
        let okAnimal = animal.sorted { (lhs, rhs) -> Bool in
            let l = lhs.reversed()
            let r = rhs.reversed()
                ///按顺序比较两个字符串的大小   abc > abb
            return l.lexicographicallyPrecedes(r)
        }
        print(okAnimal)
        
    }
    
}
