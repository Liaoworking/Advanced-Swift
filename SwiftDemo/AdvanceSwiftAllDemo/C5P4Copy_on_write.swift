//
//  C5P4Copy_on_write.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 11/28/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

class C5P4Copy_on_write: NSObject {

    func CopyOnWriteDemo() {
        
        var x = [1,2,4]
        var y = x
        x.append(5) //1,2,4,5
        y.removeLast() //1,2
        
        var a = Box(NSMutableData())
        isKnownUniquelyReferenced(&a)//true
        
        var b = a
        isKnownUniquelyReferenced(&a)//false
        isKnownUniquelyReferenced(&b)//false

        
        let someBytes = MyData(NSData(base64Encoded: "wAEP/w==", options: [])!)
        var empty = MyData(NSData())
        var emptyCopy = empty
        for _ in 0..<5 {
            empty.append(someBytes)
            
        }
         //empty <c0010fff c0010fff c0010fff c0010fff c0010fff>
         //emptyCopy <>
        
        
    }
    
}



final class Box<A> {
    var unbox:A
    init(_ value:A) {
        self.unbox = value
    }
}

struct MyData {
    fileprivate var _data: Box<NSMutableData>
    var _dataForWriting: NSMutableData {
        mutating get {
            if !isKnownUniquelyReferenced(&_data) {//检查对_data的引用是否是唯一性
                _data = Box(_data.unbox.mutableCopy() as! NSMutableData)
                print("Making a copy")
            }
            return _data.unbox
        }
    }
    init(_ data: NSData) {
        self._data = Box(data.mutableCopy() as! NSMutableData)
    }
}

extension MyData {
    mutating func append(_ other: MyData) {
        _dataForWriting.append(other._data.unbox as Data)
    }
}




