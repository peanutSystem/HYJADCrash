//
//  NSMutableString+HYJADCrash.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableString (HYJADCrash)

/**
 注册NSMutableString的防Crash方法
 */
+ (void)hyjadc_registerMutableStringPreventCrash;

@end

NS_ASSUME_NONNULL_END
