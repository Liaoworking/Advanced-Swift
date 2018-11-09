//
//  C4P3.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 11/5/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

class C4P3: NSObject {

    func somethingAboutOptional() {
        
        ///if var 的改变不影响原值
        let dict:[String:String]?
        dict = ["key1":"value1"]
        if var varDict = dict {
            varDict["key1"] = "value2"
        }
        print(dict) //Optional(["key1": "value1"])

        
        ///while let
//        while let line = printLine() {
//            print(line)
//        }
        
        
        let testOptionalChainingObj = testOptionalChaining()
        testOptionalChainingObj.voidCallback = {
            print("Hi~ I am callback~")
        }
        testOptionalChainingObj.testCall()

        20.half?.half?.half?.half
        
        
        var number: Int?
        number = nil
        String(number ?? 5)
        
        
        
        ///flatMap在可选值中的用法，感觉这个用法很有用啊
        let urlString = "http://www.objc.io/logo.png"
        let view = URL(string: urlString)
            .flatMap { (url) -> Data? in
            try? Data(contentsOf: url)
            }
            .flatMap { (data) -> UIImage? in
                UIImage(data: data)
            }
            .map { (image) -> UIImageView in
                UIImageView(image: image)
        }
        
        
        let view2 = URL(string: urlString)
            .flatMap {
                try? Data(contentsOf: $0)
            }
            .flatMap {
                UIImage(data: $0)
            }
            .map {
                UIImageView(image: $0)
        }
        
        if let view2 = view2 {
            UIView().addSubview(view2)
        }
        
        
        
        
        ///flatMap 过滤nil
        let numbers = ["1","2","3","4","liaoworking"]
        
        var sum = 0
        for case let i? in numbers.map({
            Int($0)
        }) {
            sum += i// Int($0)为nil就不走这里了
        }
        //        sum的值为10
        
        ///当我们用?? 把nil替换成0
        numbers.map { Int($0) }.reduce(0) { $0 + ($1 ?? 0)} //10
        
        ///在标准库中flatMap的作用可能正是你想要
        numbers.flatMap { Int($0) }.reduce(0, +) // 10
        

        
        /// switch case
        for i in numbers {
            switch Int(i) {
            case 0:
                print("0")
            case nil:
                print("can't convert to int")
            default:
                print("一个大数")
            }
        }
    }

    
}


/// 测试可选链
class testOptionalChaining: NSObject {
    
    var voidCallback:(()-> Void)?
    
    func testCall() {
        voidCallback?()
        //不推荐的写法(直到写笔记的时候才发现自己之前这样写都写复杂了，一点swift的优点都没体现出来😂)
        if voidCallback != nil {
            voidCallback!()
        }
        
    }
    
    
}


extension Int {
    
    var half: Int? {
        guard self > 1 else {return nil}
        return self/2
    }
    
}
