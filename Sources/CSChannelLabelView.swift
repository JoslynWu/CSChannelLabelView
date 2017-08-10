//
//  CSChannelLabelView.swift
//  CSChannelLabelView
//
//  Created by Joslyn Wu on 2017/8/10.
//  Copyright © 2017年 joslyn. All rights reserved.
//
// 一个轻量的文字频道View。多个频道可滚动，少量频道可适配间距。
// https://github.com/JoslynWu/CSChannelLabelView
//

import UIKit

enum IndicatorAnimationType: Int {
    case none       // 无动画
    case slide      // 滑行动画
    case crawl      // 爬行动画
    case rubber     // 橡胶动画
}

class CSChannelLabelView: UIView {

    // MARK: - ------------------ public -------------------
    var itemDidClickClosure: ((Int) -> Void)?;
    
    public func reloadTitles(_ titles: Array<String>) {
        
    }
    
    public func selectChannel(index: Int, anmiationType: IndicatorAnimationType = .crawl) {
        
    }
    
}
