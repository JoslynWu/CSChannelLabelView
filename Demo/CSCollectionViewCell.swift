//
//  CSCollectionViewCell.swift
//  CSChannelLabelView
//
//  Created by Joslyn Wu on 2017/8/11.
//  Copyright © 2017年 joslyn. All rights reserved.
//

import UIKit

let CSTableViewCellIdentifier = "CSTableViewCellIdentifier"
let listCount = 30
class CSCollectionViewCell: UICollectionViewCell {

    var labelTitle: String? {
        didSet {
            dataList.removeAll()
            for _ in 0 ..< listCount {
                dataList.append(labelTitle ?? "")
            }
            tableView.reloadData()
        }
    }
    
    var didSelectRowClosure: ((Int, Array<Any>) -> Void)?
    
    
    
    //MARK - -------- private --------
    var dataList = [String]()
    
    let operateTexts = ["------------> 加一栏", "------------> 减一栏", "------------> 随机长度"]
    
    lazy var tableView: UITableView = {
        let tbView: UITableView = UITableView(frame: self.contentView.bounds)
        tbView.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        tbView.delegate = self
        tbView.dataSource = self
        tbView.separatorStyle = .singleLine
        tbView.register(UITableViewCell.self, forCellReuseIdentifier: CSTableViewCellIdentifier)
        return tbView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CSCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CSTableViewCellIdentifier, for: indexPath)
        cell.textLabel?.text = (indexPath.row < operateTexts.count ? operateTexts[indexPath.row]  : "---->\(dataList[indexPath.row])")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let didSelectRowClosure = didSelectRowClosure {
            didSelectRowClosure(indexPath.row, dataList)
        }
    }
    
    
}
