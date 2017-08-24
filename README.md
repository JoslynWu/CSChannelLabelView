# CSChannelLabelView
一个轻量的文字频道View。多个频道可滚动，少量频道可适配间距。

本版本为[Swift版](https://github.com/JoslynWu/CSChannelLabelView)。

## Objective-C版入口：[CSChannelLabelView-OC](https://github.com/JoslynWu/CSChannelLabelView-OC.git)

## 效果图
![](/Effect/CSChannelLabelView.gif)

## 怎么接入

直接将Sources文件夹拖入工程中。


## 怎么用

- 建议属性设置完后，再调用刷新方法。

```
public func refreshTitles(_ titles: Array<String>)
```

- 下面方法一般在代码调用时调用，例如滚动UICollectionView时需要title同时滚动

```
public func selectChannel(index: Int, animationType: IndicatorAnimationType = default)
```

- 选择指示器支持多种动画类型

```
enum IndicatorAnimationType {
    case none               // 无动画
    case slide              // 滑行动画
    case crawl              // 爬行动画
    case rubber             // 橡胶动画
    case jump               // 跳跳动画
    case drop               // 掉落动画
}
```