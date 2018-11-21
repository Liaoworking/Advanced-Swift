//
//  C5P3Struct.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 11/21/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

class C5P3Struct: NSObject {

    var xPoint = Point(x: 8, y: 0){
        didSet{
            print("哇哦~我被调用了")
        }
    }
    
    
    func structIntroduction() {
        let p = Point(x: 1, y: 1)
        Point.origin
        xPoint.x = 10
       let y = Point(x: 10, y: 1) + Point(x: 1, y: 10)
        print(y)
    }
    
}


struct Point {
    var x:Int
    var y:Int
    
    static func +(lhs: Point, rhs: Point)-> Point{
        return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    func triple(x:Int){
//        x = x * 3 //error x is let
    }

    func triple( x:inout Int) {
        x = x * 3 // ojbk
    }
    
    
}


extension Point {
    static let origin = Point(x:0, y:0)
}

extension Point {
    mutating func translateY(by offset: Int) {
        y = y + offset
    }
}
