//
//  CSCollectionViewCell.swift
//  CSChannelLabelView
//
//  Created by Joslyn Wu on 2017/8/11.
//  Copyright © 2017年 joslyn. All rights reserved.
//

import UIKit

class CSCollectionViewCell: UICollectionViewCell {
    
    var labelTitle: String?
    
    var didSelectRowClosure: ((Int, Array<Any>) -> Void)?
    
    
}
