//
//  C3P2.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 10/29/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

/// 集合类型:Collection
class C3P2: NSObject {

    func collectionFunc() {
        
    }
    
}


/// 自己写一个最简单的将元素入队和出队的类型
protocol Queue{
    ///self中所持有的元素类型
    associatedtype Element
    ///把newElement 加入队列
    mutating func enqueue(_ newElement: Element)
    ///从self出队一个元素
    mutating func dequeue() -> Element?
}


///FIFO( First Input First Output)
struct FIFOQueue:Queue {
    
    fileprivate var left: [Int] = []
    fileprivate var right: [Int] = []
    
    ///把元素添加到队尾
    /// 复杂度O(1)
    mutating func enqueue(_ newElement: Int) {
        right.append(newElement)
    }
    
    
    /// 从队列首部移除一个元素
    /// 队列为nil时候返回空
    /// - 复杂度： 平摊 O(1)
    mutating func dequeue() -> Int? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}


extension FIFOQueue:Collection {
    ///告诉开始和结束的idx
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return left.count + right.count}
    
    ///返回指定位置的下一个位置
    public func index(after i: Int) -> Int {
        precondition( i < endIndex)
        return i + 1
    }
    
    public subscript(position: Int) -> Int {
        precondition((0..<endIndex).contains(position),"Index out of bounds")
        if position < left.endIndex{
            return left[left.count - position - 1]
        }else{
            return right[position - left.count]
        }
    }
}

//extension FIFOQueue:ExpressibleByArrayLiteral{
//    init(arrayLiteral elements: Int...) {
//        self.init(left: elements.reversed(), right: [])
//    }
//}
