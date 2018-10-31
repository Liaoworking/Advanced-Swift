//
//  C3P4.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 10/31/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit
///slice
class C3P4: NSObject {

    func sliceFunc() {
        
        
        ///下面的操作实际等于 [1,2,3,4,5].dropFirst()
        let list = [1,2,3,4,5]
        let onePastStart = list.index(after: list.startIndex)
        let firstDropped = list[onePastStart..<list.endIndex]
        Array(firstDropped) //[2,3,4,5]     ArraySlice<Int>

        
        MemoryLayout.size(ofValue: [1,2,3,4,5]) //8
        ///切片的大小是列表的大小加上子范围的大小。
        MemoryLayout.size(ofValue: [1,2,3,4,5].dropFirst()) //32
        
        
        let cities = ["shangHai","Beijing","NewYork","Chicago","Tokyo","Hongkong"]
        
        let slice = cities[2...4]
        cities.startIndex   //0
        cities.endIndex     //6
        slice.startIndex    //2
        slice.endIndex      //5
        
    }
    
}
