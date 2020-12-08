//
//  HYJADCrashPeople.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/1.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HYJADCrashTest;

@interface HYJADCrashPeople : NSObject

// 等级
@property (nonatomic, assign, readonly) NSInteger grade;

// 等级
@property (nonatomic, strong) HYJADCrashTest *test;

/**
 *@method 随机获得一个人名
 *
 *@return 人名
 */
+ (NSString *)randomPeopleName;

/**
 * @method 随机生成成长
 *
 * @return YES 设置随机成长成功
 */
- (int)randomGrowUp;

/**
 * @method 升级
 *
 * @return YES 升级成功
 */
- (BOOL)upGrade;

@end

NS_ASSUME_NONNULL_END
