//
//  ViewController.swift
//  AdvanceSwiftAllDemo
//
//  Created by Guanghui Liao on 10/23/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        C5P1Demo()
    }
    
    /// Array
    func C2P1Demo() {
        C2P1().advacedArrayFunc()
        C2P1().slice()
    }
    
    /// Dictionary
    func C2P2Demo() {
        C2P2().advanceDictFunc()
    }
    
    /// Set Range
    func C2P3_C2P4Demo() {
        C2P3_C2P4().baseSetFunc()
        C2P3_C2P4().creatRange()
    }
    
    
    /// Sequence
    func C3P1Demo() {
        C3P1().aboutSequence()
    }
    
    /// Slice
    func C3P4Demo() {
        C3P4().sliceFunc()
    }
    
    /// 可选值
    func C4P2Demo() {
        C4P2().optionFunc()
    }
    
    /// 可选值的一些用法
    func C4P3Demo() {
        C4P3().somethingAboutOptional()
    }
    
    func C4P4Demo() {
        C4P4().useOperators()
    }
    
    func C5P1Demo() {
        C5P1().valueType()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

