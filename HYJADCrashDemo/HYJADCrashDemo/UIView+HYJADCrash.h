//
//  UIView+HYJADCrash.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//
//          HOOK setNeedsLayout,layoutIfNeeded,layoutSubviews,setNeedsUpdateConstraints方法,来检查是否在主线程中执行
//目前暂未使用

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HYJADCrash)

@end

NS_ASSUME_NONNULL_END
