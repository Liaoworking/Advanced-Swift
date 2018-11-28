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
        
        
        
        
    }
    
}
