//
//  C2P1.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 10/23/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit
///内建集合类型--数组
class C2P1: NSObject {

    var demoArray = ["🌰","🍎","🍐","🍇","🥚","🌽","🌺","I"]
    
    
    /// 集合的一些高级用法
    func advacedArrayFunc() {
        ///enumerated() 用法
        for (idx, obj) in demoArray.enumerated() {
            print(idx) // 元素所在的idx
            print(obj) //元素
        }
        
        
        ///寻找指定元素的位置 index
        if let idx = demoArray.index(where: { (obj) -> Bool in
            if obj == "I"{
                return true
            }
            return false
        }) {
            print(idx)//7
        }
        
        
        ///所有元素进行变形 map
        demoArray = demoArray.map { (obj) -> String in
            return "hi~\(obj)"
        }
        for obj in demoArray {
            print(obj)// hi~🌰
        }
        
        
        ///筛选出符合要求的元素集合 filter
         demoArray = demoArray.filter { (obj) -> Bool in
            if obj == "🌰" || obj == "🍎" || obj == "I"{
                return true
            }else{
                return false
            }
        }
        print(demoArray)//["🌰", "🍎", "I"]
        
        
        ///reduce 基础思想是将一个序列转换为一个不同类型的数据，期间通过一个累加器（Accumulator）来持续记录递增状态。
        ///TODO!这个函数的精髓我还不知道怎么清晰描述。欢迎参透的同学pr一下😆。
        //[1,2,3].reduce(into: <#T##Result#>, <#T##updateAccumulatingResult: (inout Result, Int) throws -> ()##(inout Result, Int) throws -> ()#>)
        
        /// 两个数组变形合并  flatMap
        let fruit = ["🍎","🍐","🍌"]
        let animal = ["🐷"]
        
        let result = fruit.flatMap { (f) -> [String] in
            let newArray = animal.map({ (a) -> String in
                return (a+"eat"+f)
            })
            return newArray
        }
        print(result) //["🐷eat🍎", "🐷eat🍐", "🐷eat🍌"]
    }
    
    
    
    ///切片
    func slice() {
        let fruit = ["🍎","🍐","🍌"]
        let slice = fruit[1..<fruit.endIndex]
        print(slice)//["🍐", "🍌"]
        print("\(type(of: slice))")//ArraySlice<String>

    }
    
}
