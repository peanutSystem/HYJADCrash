//
//  HYJADCrashUserInfo.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/14.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashUserInfo.h"

@implementation HYJADCrashUserInfo

+ (instancetype)share
{
    static HYJADCrashUserInfo *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [HYJADCrashUserInfo new];
    });
    return obj;
}

@end
