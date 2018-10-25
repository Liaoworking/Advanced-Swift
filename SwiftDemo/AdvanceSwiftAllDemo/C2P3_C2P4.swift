//
//  C2P3-C2P4.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 10/25/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

class C2P3_C2P4: NSObject {

    
    func baseSetFunc() {
        let numSet:Set = [1,2,3,4,5]
        let otherSet:Set = [2,6]
        
        ///并集
        let unionSet = numSet.union(otherSet)
        print(unionSet) //[5, 6, 2, 3, 1, 4]
        
        ///交集
        let intersectionSet = numSet.intersection(otherSet)
        print(intersectionSet) //[2]

        ///补集
        let subtractingSet = numSet.subtracting(otherSet)
        print(subtractingSet) //[5, 3, 1, 4]
        
    }
    
    
    func creatRange() {
        let singleNum = 0..<10//不包括10
        
        let lowerLetters = Character("a")...Character("z")//包括z

    }
}
