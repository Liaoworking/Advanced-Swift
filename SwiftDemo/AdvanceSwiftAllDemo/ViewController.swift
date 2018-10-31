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
        C3P4Demo()
    }

    func C2P1Demo() {
        C2P1().advacedArrayFunc()
        C2P1().slice()
    }
    
    func C2P2Demo() {
        C2P2().advanceDictFunc()
    }
    
    func C2P3_C2P4Demo() {
        C2P3_C2P4().baseSetFunc()
        C2P3_C2P4().creatRange()
    }
    
    func C3P1Demo() {
        C3P1().aboutSequence()
    }
    
    func C3P4Demo() {
        C3P4().sliceFunc()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

