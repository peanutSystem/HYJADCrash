//
//  HYJADCrashDeviceInfo.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/11.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashDeviceInfo.h"

@implementation HYJADCrashDeviceInfo

+(instancetype)share
{
    static HYJADCrashDeviceInfo *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [HYJADCrashDeviceInfo new];
    });
    return obj;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
        self.isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
        self.scale = self.isPhone ? MIN(ScreenW,ScreenH)/375.0f : MIN(ScreenW,ScreenH)/768.0f;
    }
    return self;
}

@end
