//
//  C3P1.swift
//  AdvanceSwiftAllDemo
//
//  Created by liaoworking on 2018/10/27.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

class C3P1: NSObject {

    func aboutSequence() {
        
        ///myfirstSquence 我的第一个自定义集合
        for prefixStr in PrefixSequence(string: "Hi~LiaoWorking!") {
            print(prefixStr)
//            H
//            Hi
//            Hi~
//            Hi~L
//            Hi~Li
//            Hi~Lia
//            Hi~Liao
//            Hi~LiaoW
//            Hi~LiaoWo
//            Hi~LiaoWor
//            Hi~LiaoWork
//            Hi~LiaoWorki
//            Hi~LiaoWorkin
//            Hi~LiaoWorking
//            Hi~LiaoWorking!
        }
        
        /// 常用的两个方法 特别是代替c语言风格for循环，下表步长无线性关系的。
        /// 具体项目中我也没具体遇到过。。so 不写demo了啊~
//        sequence(first: <#T##T#>, next: <#T##(T) -> T?#>)
//        sequence(state: <#T##State#>, next: <#T##(inout State) -> T?#>)
    }
    
    /// 通过引用语义的特性写斐波那契
    func fibsIterator() -> AnyIterator<Any> {
        var startNum = (0, 1)
        return AnyIterator{
            let nextNum = startNum.0
                startNum = (startNum.1 , startNum.0 + startNum.1)
            return nextNum
        }
    }
    
}

///下面的顺序按照书上的顺序来的~

/// 迭代器
struct FibsNumIterator:IteratorProtocol {
    typealias Element = Int
    var startNum = (0, 1)
    mutating func next() -> Int? {
        let nextNum = startNum.0
        startNum = (startNum.1, startNum.0 + startNum.1)
        return nextNum
    }
}


///step1.创建一个迭代器
struct PrefixStrIterator:IteratorProtocol {
    var string: String
    var offset: String.Index
    init(string:String) {
        self.string = string
        offset = string.startIndex
    }
    mutating func next() -> String? {
        guard offset < string.endIndex else { return nil}
        offset = string.index(after: offset)
        return String(string[string.startIndex..<offset])
    }
}

///step2.创建一个属于你的集合
struct PrefixSequence: Sequence {
    var string: String
    
    func makeIterator() -> PrefixStrIterator {
        return PrefixStrIterator(string: string)
    }
}



