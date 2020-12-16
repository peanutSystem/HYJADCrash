//
//  UIView+HYJADCrash.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "UIView+HYJADCrash.h"
#import "NSObject+HYJADCrashSwizzleHook.h"

@implementation UIView (HYJADCrash)

+ (void)hyj_swizzleUIVewMethod
{
    swizzleMethod([UIView class], NO, @selector(setNeedsLayout), @selector(hyj_setNeedsLayout));
    swizzleMethod([UIView class], NO, @selector(layoutIfNeeded), @selector(hyj_layoutIfNeeded));
    swizzleMethod([UIView class], NO, @selector(layoutSubviews), @selector(hyj_layoutSubviews));
    swizzleMethod([UIView class], NO, @selector(setNeedsUpdateConstraints), @selector(hyj_setNeedsUpdateConstraints));
}



- (void)hyj_setNeedsLayout
{
    if ([NSThread isMainThread]) {
        [self hyj_setNeedsLayout];
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hyj_setNeedsLayout];
        });
    }
}

- (void)hyj_layoutIfNeeded
{
    if ([NSThread isMainThread]) {
        [self hyj_layoutIfNeeded];
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hyj_layoutIfNeeded];
        });
    }
}

- (void)hyj_layoutSubviews
{
    if ([NSThread isMainThread]) {
        [self hyj_layoutSubviews];
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hyj_layoutSubviews];
        });
    }
}

- (void)hyj_setNeedsUpdateConstraints
{
    if ([NSThread isMainThread]) {
        [self hyj_setNeedsUpdateConstraints];
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hyj_setNeedsUpdateConstraints];
        });
    }
}

@end
