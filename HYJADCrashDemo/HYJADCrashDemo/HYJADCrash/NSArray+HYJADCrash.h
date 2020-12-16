//
//  NSArray+HYJADCrash.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (HYJADCrash)

/**
 初始化一个元素的不可变数组的安全方法

 @param anObject 数组的元素
 @return 不可变数组
 */
+ (instancetype)arrayWithObjectSafe:(id _Nonnull)anObject;


/**
 用指定元素个数,初始化一个不可变数组的安全方法

 @param objects 元素
 @param cnt 元素个数
 @return 不可变数组
 */
+ (instancetype)arrayWithObjectsSafe:(id  _Nonnull const [])objects count:(NSUInteger)cnt;

/**
 根据下坐标获取对应元素的安全方法
 
 @param index 需要获取元素的下坐标
 @return 获取的元素
 */
- (id)objectAtIndexSafe:(NSUInteger)index;

/**
 根据下坐标获取对应元素的安全方法
 
 @param idx 需要获取元素的下坐标
 @return 获取的元素
 */
- (id)objectAtIndexedSubscriptSafe:(NSUInteger)idx;


/**
 获取指定Range下的数组前几个元素
 
 @param range 需要获取的元素最末尾元素下坐标以及长度
 @return 数组
 */
- (NSArray *)subarrayWithRangesSafe:(NSRange)range;


@end

NS_ASSUME_NONNULL_END
