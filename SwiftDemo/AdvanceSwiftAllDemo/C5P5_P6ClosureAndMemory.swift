//
//  C5P5_P6ClosureAndMemory.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 12/2/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

class C5P5_P6ClosureAndMemory: NSObject {

    func Demo() {
        
    }
}



class View {
    unowned var window: UIView
    init(window: UIView) {
        self.window = window
    }
    
    deinit {
        print("Deinit View")
    }
    
}
