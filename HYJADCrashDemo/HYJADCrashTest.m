//
//  HYJADCrashTest.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/1.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashTest.h"
#import "HYJADCrashTestTwo.h"

@implementation HYJADCrashTest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.two = [HYJADCrashTestTwo new];
    }
    return self;
}

- (void)changeAge
{
    [self.two addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    self.two.age = 123;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.two.age = 321;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.two removeObserver:self forKeyPath:@"age" context:nil];
        self.two.age = 123;
    });
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"observeValueForKeyPath->%@\n->key:%@\n->value:%@\n",NSStringFromClass([object class]),keyPath,change);
}


- (void)dealloc
{
    [self.two removeObserver:self forKeyPath:@"age" context:nil];
    NSLog(@"HYJADCrashTest------dealloc");
}

@end
