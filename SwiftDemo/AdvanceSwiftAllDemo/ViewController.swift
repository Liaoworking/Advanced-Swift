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
        testDemo()
    }

    func testDemo() {
        C2P1().advacedArrayFunc()
        C2P1().slice()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

