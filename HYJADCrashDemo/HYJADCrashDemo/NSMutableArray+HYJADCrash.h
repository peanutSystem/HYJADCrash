//
//  NSMutableArray+HYJADCrash.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (HYJADCrash)

/**
 向数组中添加一元素的安全方法

 @param anObject 需要添加的元素
 */
- (void)addObjectSafe:(id _Nonnull)anObject;


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
 在指定下坐标插入一个元素的安全方法

 @param anObject 需要插入的元素
 @param index 插入的下坐标
 */
- (void)insertObjectSafe:(id _Nonnull)anObject atIndex:(NSUInteger)index;



/**
 移除指定下坐标元素的安全方法

 @param index 需要移除元素的下坐标
 */
- (void)removeObjectAtIndexSafe:(NSUInteger)index;



/**
 替换指定下坐标元素的安全方法

 @param index 被替换的元素的下坐标
 @param anObject 用作替换的元素
 */
- (void)replaceObjectAtIndexSafe:(NSUInteger)index withObject:(id _Nonnull)anObject;




/**
 在数组中根据Range移除元素

 @param range 需要移除元素的首位下坐标以及长度
 */
- (void)removeObjectsInRangeSafe:(NSRange)range;



/**
 获取指定Range下的数组前几个元素

 @param range 需要获取的元素最末尾元素下坐标以及长度
 @return 数组
 */
- (NSArray *)subarrayWithRangesSafe:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
