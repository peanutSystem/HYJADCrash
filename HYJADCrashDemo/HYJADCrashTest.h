//
//  HYJADCrashTest.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/1.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HYJADCrashTestTwo;

@interface HYJADCrashTest : NSObject


@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *str;

@property (nonatomic, strong) HYJADCrashTestTwo *two;

- (void)changeAge;

@end

NS_ASSUME_NONNULL_END
