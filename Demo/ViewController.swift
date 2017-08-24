//
//  ViewController.swift
//  CSChannelLabelView
//
//  Created by Joslyn Wu on 2017/8/10.
//  Copyright © 2017年 joslyn. All rights reserved.
//

import UIKit

let CSViewControllerControllerCellId = "CSViewControllerControllerCellId"
let channelTitleH = 39.0

class ViewController: UIViewController {
    
    
    
    
    // -------------------- CSLabelTitleView --------------------
    
    private func addLabelTitleView() {
        labelTitleView = CSChannelLabelView(frame: CGRect(x: 0, y: 64, width: Double(UIScreen.main.bounds.width), height: channelTitleH))
        view.addSubview(labelTitleView)
        labelTitleView.leadingMargin = 15
        labelTitleView.middleMargin = 35
        labelTitleView.indicatorAnimationType = .drop
        labelTitleView.refreshTitles(labelTitles)
    }
    
    // -------------------- CSLabelTitleView --------------------
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    var labelTitleView: CSChannelLabelView!
    var contentView: UICollectionView!
    var labelTitles: Array<String> = ["label00", "label01", "label02", "label03"]
    var isLabelTitleDidClick:Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CSLabelTitleView";
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI() {
        addLabelTitleView()
    
        let contentView_top = channelTitleH + 64
        let rect = CGRect(x: 0, y: contentView_top, width: Double(UIScreen.main.bounds.width), height: Double(UIScreen.main.bounds.height) - contentView_top)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = rect.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.scrollDirection = .horizontal
        contentView = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        view.addSubview(contentView)
        contentView.dataSource = self
        contentView.delegate = self
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        contentView.isPagingEnabled = true
        contentView.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: CSViewControllerControllerCellId)
        
        labelTitleView.itemDidClickClosure = { [weak self] (index) in
            self?.isLabelTitleDidClick = true
            let idxPath = IndexPath(item: index, section: 0)
            self?.contentView.scrollToItem(at: idxPath as IndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    func updateLabelTitle(with index: Int) {
        guard index <= 2 else {
            return
        }
        if index == 0 {
            labelTitles.append(String(format: "label%02d", labelTitles.count))
        } else if index == 1{
            guard self.labelTitles.count > 1 else {
                return
            }
            self.labelTitles.removeLast()
        } else {
            var tempArr = [String]()
            for _ in labelTitles {
                tempArr.append(randomString(maxCount: 8))
            }
            labelTitles = tempArr
        }
        labelTitleView.refreshTitles(labelTitles)
        contentView.reloadData()
    }
    
    func randomString(maxCount n: UInt32) -> String {
        let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let randomCountN = arc4random_uniform(n) + 1
        var tempStr = ""
        repeat {
            for _ in 0 ..< randomCountN {
                let randomIdx = arc4random_uniform(UInt32(chars.characters.count))
                let s = (chars as NSString).substring(with: NSMakeRange(Int(randomIdx), 1))
                tempStr.append(s)
            }
        } while tempStr.characters.count <= 0
        
        return tempStr
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CSViewControllerControllerCellId, for: indexPath) as! CSCollectionViewCell
        cell.contentView.backgroundColor = UIColor.lightGray;
        cell.labelTitle = labelTitles[indexPath.item]
        cell.didSelectRowClosure = { [weak self] (index, data) in
            self?.updateLabelTitle(with: index)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isLabelTitleDidClick {
            isLabelTitleDidClick = false;
            return;
        }
        let idx = Int((scrollView.contentOffset.x + UIScreen.main.bounds.width * 0.5) / UIScreen.main.bounds.width)
        labelTitleView.selectChannel(index: idx, animationType: .crawl)
    }
    

}





