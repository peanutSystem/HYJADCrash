//
//  NSArray+HYJADCrash.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "NSArray+HYJADCrash.h"
#import "HYJADCrashCollectManager.h"

@implementation NSArray (HYJADCrash)

+ (instancetype)arrayWithObjectSafe:(id _Nonnull)anObject
{
    if (anObject) {
        return [self arrayWithObject:anObject];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSArray arrayWithObjectSafe attempt to  nil object from objects[0]"];
        return nil;
    }
}

+ (instancetype)arrayWithObjectsSafe:(id  _Nonnull const [])objects count:(NSUInteger)cnt
{
    if (objects) {
        NSInteger index = 0;
        id objs[cnt];
        BOOL objecNotNil = NO;
        for (NSInteger i = 0; i < cnt ; i++) {
            if (objects[i]) {
                objs[index++] = objects[i];
                objecNotNil = YES;
            }
        }
        if (objecNotNil) {
            return [self arrayWithObjects:objs count:index];
        }else
        {
            [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSArray arrayWithObjectsSafe:count: pointer to objects array is NULL but length is %zi",cnt]];
            return nil;
        }
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSArray arrayWithObjectsSafe:count: pointer to objects array is NULL but length is %zi",cnt]];
        return nil;
    }
    
}


- (id)objectAtIndexSafe:(NSUInteger)index
{
    if (index < self.count) {
        return [self objectAtIndex:index];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSArray objectAtIndexSafe index %zi beyond bounds [0 .. %zi]",index,self.count-1]];
        return nil;
    }
}

- (id)objectAtIndexedSubscriptSafe:(NSUInteger)idx
{
    if (idx < self.count) {
        return [self objectAtIndexedSubscript:idx];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSArray objectAtIndexedSubscriptSafe index %zi beyond bounds [0 .. %zi]",idx,self.count-1]];
        return nil;
    }
}

- (NSArray *)subarrayWithRangesSafe:(NSRange)range
{
    NSInteger len = self.count - range.location - range.length;
    if (range.location < self.count && len > 0) {
        return [self subarrayWithRange:range];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSArray subarrayWithRangesSafe range {%zi, %zi} extends beyond bounds [0 .. %zi]",range.location,range.length,self.count-1]];
        return nil;
    }
}

@end
