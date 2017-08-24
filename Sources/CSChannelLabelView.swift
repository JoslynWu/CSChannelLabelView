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

enum IndicatorAnimationType {
    case none               // 无动画
    case slide              // 滑行动画
    case crawl              // 爬行动画
    case rubber             // 橡胶动画
    case jump               // 跳跳动画
    case drop               // 掉落动画
}

class CSChannelLabelView: UIView {
    
    // MARK: - ------------------ public -------------------
    var itemDidClickClosure: ((Int) -> Void)?
    
    public func refreshTitles(_ titles: Array<String>) {
        guard titles.count > 0 else {
            return
        }
        
        clearContainer()
        self.titles = titles
        
        let maxSize = CGSize(width: frame.width, height: frame.height)
        for title in titles {
            let minSize = title.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : titleFont], context: nil).size
            let w = Double(ceil(minSize.width))
            titleWidths.append(w)
            titleHeight = Double(ceil(minSize.height))
            totalWith += w
        }
        
        adjustMargin()
        refreshUI()
    }
    
    public func selectChannel(index: Int, animationType: IndicatorAnimationType = .crawl) {
        if index >= titleWidths.count || index >= labels.count {
            return
        }
        
        refreshIndicator(with: index, animationType: animationType)
        
        let label = labels[index]
        lastSelectLabel?.textColor = titleColor
        label.textColor = selectColor
        lastSelectLabel = label
        selectIndicator.backgroundColor = selectColor
        
        autoScrollWithIndex(index: index)
    }
    
    
    // config
    /// 两个label之前的间距，默认0.0
    var middleMargin = 0.0
    
    /// 第一个label与边缘的距离（头间距），默认0.0。尾间距默认相等
    var leadingMargin = 0.0
    
    /// 头（或尾）间距与中间间距的比例。当用指定间距计算出的总长度减去滚动容器的宽度小于一个leadingMargin时有效，默认为0.618。
    var scaleOfLMMargin = 0.618
    
    /// 选择指示器的调整宽度（相对于文字宽度的单边调整距离）。默认0.0
    var adjustWidth4Indicator = 0.0
    
    var indicatorAnimationType: IndicatorAnimationType = .crawl
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    var titleColor: UIColor = .darkText
    
    var selectColor: UIColor = .blue
    
    /// Label的其他设置
    var otherConfigClosure: ((UILabel) -> Void)?
    
    /// 底部分割线的颜色
    var separatorColor: UIColor = UIColor.cs_colorWithHexString(hex: "#f3f2f3") {
        didSet {
            bottomLine.backgroundColor = separatorColor
        }
    }
    
    /// 底部分割线是否显示
    var showSeparator: Bool = true {
        didSet {
            bottomLine.isHidden = !showSeparator
        }
    }
    
    
    // MARK: - ------------------ private -------------------
    private var titles: Array<String>!
    private var titleWidths = [Double]()
    private var titleHeight = 0.0;
    private var labels: Array<UILabel> = Array()
    private lazy var mainView: UIScrollView = {
        var mainView: UIScrollView = UIScrollView(frame: self.bounds)
        mainView.showsVerticalScrollIndicator = false;
        mainView.showsHorizontalScrollIndicator = false;
        return mainView
    }()
    
    private lazy var bottomLine: UIView = {
        let line_h: CGFloat = 0.5
        var view: UIView = UIView(frame: CGRect(x: 0, y: self.frame.height - line_h, width: self.frame.width, height: line_h))
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    private lazy var selectIndicator = UIView()
    private var lastSelectLabel: UILabel?
    private var totalWith = 0.0
    private var middleMargin_tuning = 0.0
    private var leadingMargin_tuning = 0.0
    private var lastIndex: Int = 0
    
    // MARK: - lifecyle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - action
    private func setupUI() {
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubview(bottomLine)
        addSubview(mainView)
        mainView.addSubview(selectIndicator)
    }
    
    private func refreshUI() {
        
        var label_x = leadingMargin_tuning
        for (idx, width) in titleWidths.enumerated() {
            let label: UILabel = UILabel(frame: CGRect(x: label_x, y: 0, width: width, height: Double(frame.height)))
            label_x += width + middleMargin_tuning
            mainView.addSubview(label)
            labels.append(label)
            label.text = titles[idx]
            configLabel(label)
            label.tag = idx
        }
        
        if let lastLabel = labels.last {
            mainView.contentSize = CGSize(width: Double(lastLabel.frame.maxX) + leadingMargin_tuning, height: 0)
        }
        selectChannel(index: 0, animationType: .none)
        if let itemDidClickClosure = itemDidClickClosure {
            itemDidClickClosure(0)
        }
        mainView.bringSubview(toFront: selectIndicator)
    }
    
    private func clearContainer() {
        for view in mainView.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
        labels.removeAll()
        lastIndex = -1
        totalWith = 0.0
        titleWidths.removeAll()
        titleHeight = 0.0;
    }
    
    private func adjustMargin() {
        leadingMargin_tuning = leadingMargin
        middleMargin_tuning = middleMargin
        let expectWith = totalWith + leadingMargin * 2 + middleMargin * Double((titleWidths.count - 1))
        
        guard (expectWith - Double(mainView.frame.width)) < leadingMargin else {
            return
        }
        
        guard scaleOfLMMargin >= 0 else {
            return
        }
        
        let spaceWith = Double(mainView.frame.width) - totalWith
        middleMargin_tuning = spaceWith / (Double(titleWidths.count - 1) + 2 * scaleOfLMMargin)
        leadingMargin_tuning = scaleOfLMMargin * middleMargin_tuning
    }
    
    private func configLabel(_ label: UILabel) {
        label.textAlignment = .center
        label.textColor = titleColor
        label.font = titleFont
        label.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(channelDidClick(tap:)))
        label.addGestureRecognizer(tap)
        if let otherConfig = otherConfigClosure {
            otherConfig(label)
            titleColor = label.textColor
        }
    }
    
    private func autoScrollWithIndex(index: Int) {
        let label = labels[index]
        let label_center_x = Double(label.frame.midX)
        let distance = label_center_x - Double(frame.midX)
        var scrollDistance = leadingMargin_tuning
        
        guard mainView.contentSize.width > frame.width else {
            return
        }
        
        if distance < 0 {
            scrollDistance = 0.0
        } else {
            for width in titleWidths {
                scrollDistance += width + middleMargin_tuning
                if scrollDistance - distance > 0 {
                    let adjustDistance = width + leadingMargin_tuning
                    scrollDistance -= adjustDistance + leadingMargin_tuning;
                    if (index + 1) < labels.count {
                        let nextLabel = labels[index + 1]
                        if (Double(nextLabel.frame.maxX) - scrollDistance) > Double(frame.width) {
                            scrollDistance += adjustDistance
                        }
                    }
                    if (Double(mainView.contentSize.width) - scrollDistance) < Double(frame.width) {
                        scrollDistance = Double(mainView.contentSize.width - frame.width)
                    }
                    break
                }
            }
        }
        mainView.setContentOffset(CGPoint(x: scrollDistance, y: 0), animated: true)
    }
    
    private func refreshIndicator(with index: Int, animationType: IndicatorAnimationType) {
        let title_w = titleWidths[index]
        let label = labels[index]
        
        let indicator_h = 2.0
        let indicator_w = title_w + adjustWidth4Indicator
        let indicator_y = Double(frame.height) - indicator_h
        let indicator_x = Double(label.frame.midX) - indicator_w * 0.5
        let rect = CGRect(x: indicator_x, y: indicator_y, width: indicator_w, height: indicator_h)
        
        switch animationType {
        case .rubber:
            indicatorRubberAnimation(label: label, targetRect: rect)
        case .jump:
            indicatorJumpAnimation(label: label, targetRect: rect)
        case .crawl:
            backIfclickFromSomeIndex(index: index)
            indicatorCrawlAnimation(label: label, targetRect: rect)
        case .slide:
            backIfclickFromSomeIndex(index: index)
            UIView.animate(withDuration: 0.25, animations: {
                self.selectIndicator.frame = rect
            })
        case .drop:
            indicatorCurtainAnimation(label: label, targetRect: rect)
        default:
            backIfclickFromSomeIndex(index: index)
            self.selectIndicator.frame = rect
        }
    }
    
    private func backIfclickFromSomeIndex(index: Int) {
        guard lastIndex != index else {
            return
        }
        lastIndex = index
    }
    
    // MARK: - listion
    @objc private func channelDidClick(tap: UITapGestureRecognizer) {
        guard let view = tap.view else {
            return
        }
        if let itemDidClickClosure = itemDidClickClosure {
            itemDidClickClosure(view.tag)
        }
        selectChannel(index: view.tag, animationType: indicatorAnimationType)
    }
    
    // MARK: - animation
    private func indicatorRubberAnimation(label: UILabel, targetRect: CGRect) {
        let scale = 1 - 0.618
        selectIndicator.frame = targetRect
        selectIndicator.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
        label.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.selectIndicator.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        
    }
    
    private func indicatorCrawlAnimation(label: UILabel, targetRect: CGRect) {
        let targetRect_x = Double(targetRect.origin.x)
        let targetRect_y = Double(targetRect.origin.y)
        let targetRect_h = Double(targetRect.size.height)
        
        let indicator_x_origin = Double(selectIndicator.frame.minX)
        UIView.animate(withDuration: 0.2, animations: {
            var tempRect = self.selectIndicator.frame
            if Double(label.frame.minX) >= indicator_x_origin {
                let indicator_w_max = Double(label.frame.maxX) + self.adjustWidth4Indicator - indicator_x_origin
                tempRect = CGRect(x: indicator_x_origin, y: targetRect_y, width: indicator_w_max, height: targetRect_h)
            } else {
                let indicator_w_max = Double(self.selectIndicator.frame.maxX - label.frame.minX) + self.adjustWidth4Indicator
                tempRect = CGRect(x: targetRect_x, y: targetRect_y, width: indicator_w_max, height: targetRect_h)
            }
            self.selectIndicator.frame = tempRect
        }, completion: { (finish) in
            if finish {
                UIView.animate(withDuration: 0.2, animations: {
                    self.selectIndicator.frame = targetRect;
                })
            }
        })
    }
    
    private func indicatorJumpAnimation(label: UILabel, targetRect: CGRect) {
        let translation_h = ((Double(label.frame.height) - titleHeight) * 0.5 - Double(targetRect.height)) * 0.618
        selectIndicator.frame = targetRect
        selectIndicator.transform = CGAffineTransform(translationX: 0, y: -(CGFloat)(translation_h))
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            self.selectIndicator.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    private func indicatorCurtainAnimation(label: UILabel, targetRect: CGRect) {
        self.selectIndicator.frame = CGRect(x: targetRect.minX, y: 0, width: targetRect.width, height: targetRect.height)
        UIView.animate(withDuration: 0.25, delay: 0.15, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            self.selectIndicator.frame = targetRect
        }, completion: nil)
    }
    
}

// MARK: - ------------------colorTool-------------------
extension UIColor {
    static func cs_colorWithHexString(hex: String, alpha: CGFloat? = 1.0) -> UIColor {
        let hexStr = hex.replacingOccurrences(of: "#", with: "") as NSString
        
        if hexStr.length != 6 && hexStr.length != 3 {
            return UIColor.white
        }
        
        let digits = hexStr.length / 3
        let maxValue: CGFloat = (digits == 1 ? 15.0 : 255.0)
        
        let rString = hexStr.substring(with: NSMakeRange(0, digits))
        let gString = hexStr.substring(with: NSMakeRange(digits, digits))
        let bString = hexStr.substring(with: NSMakeRange(2 * digits, digits))
        
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0;
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor.init(red: CGFloat(r) / maxValue, green: CGFloat(g) / maxValue, blue: CGFloat(b) / maxValue, alpha: alpha!)
    }
}

