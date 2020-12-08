//
//  HYJADCrashPeople.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/1.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashPeople.h"
#import "HYJADCrashTest.h"

@implementation HYJADCrashPeople


- (BOOL)upGrade
{
    if (_grade < 0) {
        _grade = 0;
    }
    
    _grade += 1;
    
    return YES;
}


@end
