//
//  HYJADCrashTapGestureRecognizer.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/20.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashTapGestureRecognizer.h"

@implementation HYJADCrashTapGestureRecognizer

#pragma mark - UIResponder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"TapGestureRecognizer,%@,touchesBegan",self.superClassName);
//    [super touchesBegan:touches withEvent:event];
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"TapGestureRecognizer,%@,touchesMoved",self.superClassName);
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"TapGestureRecognizer,%@,touchesEnded",self.superClassName);
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"TapGestureRecognizer,%@,touchesCancelled",self.superClassName);
    [super touchesCancelled:touches withEvent:event];
}

@end
