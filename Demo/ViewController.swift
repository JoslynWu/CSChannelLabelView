//
//  ViewController.swift
//  CSChannelLabelView
//
//  Created by Joslyn Wu on 2017/8/10.
//  Copyright © 2017年 joslyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var channelLabelView = CSChannelLabelView()
        channelLabelView.reloadTitles(["a", "b"])
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

