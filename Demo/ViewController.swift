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
        labelTitleView.indicatorAnimationType = .rubber
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
        // Dispose of any resources that can be recreated.
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
        contentView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CSViewControllerControllerCellId)
        
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
        } else {
            
        }
    }
    
//    - (void)updateLabelTitleWithIndex:(NSInteger)idx {
//    if (idx > 2) { return; }
//    if (idx == 0) {
//    [self.labelTitles addObject:[NSString stringWithFormat:@"label%02zd",self.labelTitles.count]];
//    } else if (idx == 1) {
//    if (self.labelTitles.count <= 1) { return; }
//    [self.labelTitles removeLastObject];
//    } else {
//    NSMutableArray<NSString *> *mArr = [NSMutableArray arrayWithCapacity:self.labelTitles.count];
//    [self.labelTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//    [mArr addObject:[self randomStringWithMaxCharCount:8]];
//    }];
//    self.labelTitles = mArr;
//    }
//    
//    [self.labelTitleView refreshTitles:self.labelTitles];
//    [self.contentView reloadData];
//    }
//    
//    - (NSString *)randomStringWithMaxCharCount:(unsigned int)n {
//    NSString *chars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSUInteger randomCountN = arc4random_uniform(n) + 1;
//    NSMutableString *mStr = [NSMutableString stringWithCapacity:randomCountN];
//    do {
//    for (NSInteger i = 0; i < randomCountN; i++) {
//    NSUInteger randomIdx = arc4random_uniform((uint32_t)(chars.length));
//    NSString *s = [chars substringWithRange:NSMakeRange(randomIdx, 1)];
//    [mStr appendString:s];
//    }
//    } while (mStr.length <= 0);
//    return mStr.copy;
//    }

}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CSViewControllerControllerCellId, for: indexPath)
        cell.contentView.backgroundColor = UIColor.lightGray;
//        cell.labelTitle = labelTitles[indexPath.item]
//        cell.didSelectRowClosure = { [weak self] (index, data) in
//            self?.updateLabelTitle(with: index)
//        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isLabelTitleDidClick {
            isLabelTitleDidClick = true
        }
        let idx = Int((scrollView.contentOffset.x + UIScreen.main.bounds.width * 0.5) / UIScreen.main.bounds.width)
        labelTitleView.selectChannel(index: idx, animationType: .crawl)
    }
    

}





