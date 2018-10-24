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
        C2P2Demo()
    }

    func C2P1Demo() {
        C2P1().advacedArrayFunc()
        C2P1().slice()
    }
    
    func C2P2Demo() {
        C2P2().advanceDictFunc()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

