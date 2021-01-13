//
//  CView.m
//  Demo
//
//  Created by 何宇佳 on 2020/12/20.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "CView.h"
#import "HYJADCrashTapGestureRecognizer.h"

@implementation CView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor blueColor];
    HYJADCrashTapGestureRecognizer *tap =[[HYJADCrashTapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.superClassName = [[NSString alloc] initWithFormat:@"%s",object_getClassName(self)];
    [self addGestureRecognizer:tap];
}

#pragma mark - Action
- (void)tap
{
    NSLog(@"%s,%s",object_getClassName(self), __func__);
}

#pragma mark - UIView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
    return [super hitTest:point withEvent:event];
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
    return [super pointInside:point withEvent:event];
}

#pragma mark - UIResponder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s,%s",object_getClassName(self), __func__);
//    [super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"%s,%s",object_getClassName(self), __func__);
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s,%s",object_getClassName(self), __func__);
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s,%s",object_getClassName(self), __func__);
    [super touchesCancelled:touches withEvent:event];
}

@end
