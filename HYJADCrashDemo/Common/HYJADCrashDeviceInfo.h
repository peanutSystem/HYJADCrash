//
//  HYJADCrashDeviceInfo.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/11.
//  Copyright © 2020 何宇佳. All rights reserved.
//
//              当前设备的信息

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYJADCrashDeviceInfo : NSObject

//屏幕比例
@property (nonatomic, assign) CGFloat scale;

//是否是手机
@property (nonatomic, assign) BOOL isPhone;

//是否是Pad
@property (nonatomic, assign) BOOL isPad;


/// 单例对象
+(instancetype)share;

@end

NS_ASSUME_NONNULL_END
