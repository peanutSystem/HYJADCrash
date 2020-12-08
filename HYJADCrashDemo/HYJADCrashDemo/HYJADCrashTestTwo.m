//
//  HYJADCrashTestTwo.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/1.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashTestTwo.h"

@implementation HYJADCrashTestTwo


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"颜色改变了");
}

@end
