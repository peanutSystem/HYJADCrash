//
//  NSObject+HYJADCrashSwizzleHook.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 动态交换两个方法的实现的方法
 
 @param className 需要交换方法的类
 @param isClassMethod YES表示需要交换的方法是类方法，NO表示是对象方法
 @param originSelector 原方法名
 @param swizzleSelector 用以交换的方法名
 */
void swizzleMethod(Class className, BOOL isClassMethod, SEL originSelector, SEL swizzleSelector);

@interface NSObject (HYJADCrashSwizzleHook)

/**
 动态交换当前类的 两个方法的实现
 
 @param isClassMethod YES表示需要交换的方法是类方法，NO表示是对象方法
 @param originSelector 原方法名
 @param swizzleSelector 用以交换的方法名
 */
+ (void)hyj_swizzleSelfMethodWithIsClassMethod:(BOOL)isClassMethod  originSelector:(SEL)originSelector swizzleSelector:(SEL)swizzleSelector;

@end

NS_ASSUME_NONNULL_END
