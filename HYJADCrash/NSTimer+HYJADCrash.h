//
//  NSTimer+HYJADCrash.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (HYJADCrash)

/**
 注册Timer自动销毁
 */
+ (void)hyjadc_registerTimerPreventCrash;

@end

NS_ASSUME_NONNULL_END
