//
//  NSMutableArray+HYJADCrash.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "NSMutableArray+HYJADCrash.h"
#import "HYJADCrashCollectManager.h"

@implementation NSMutableArray (HYJADCrash)

- (void)addObjectSafe:(id _Nonnull)anObject
{
    if (anObject) {
        [self addObject:anObject];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSMutableArray addObjectSafe object cannot be nil"];
    }
}

- (id)objectAtIndexSafe:(NSUInteger)index
{
    if (index < self.count) {
        return [self objectAtIndex:index];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSMutableArray objectAtIndexSafe index %zi beyond bounds [0 .. %zi]",index,self.count-1]];
        return nil;
    }
}

- (id)objectAtIndexedSubscriptSafe:(NSUInteger)idx
{
    if (idx < self.count) {
        return [self objectAtIndexedSubscript:idx];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSMutableArray objectAtIndexedSubscriptSafe index %zi beyond bounds [0 .. %zi]",idx,self.count-1]];
        return nil;
    }
}

- (void)insertObjectSafe:(id _Nonnull)anObject atIndex:(NSUInteger)index
{
    if (anObject) {
        if (index <= self.count) {
            [self insertObject:anObject atIndex:index];
        }else
        {
            [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSMutableArray insertObjectSafe index %zi beyond bounds [0 .. %zi]",index,self.count-1]];
        }
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSMutableArray insertObjectSafe object cannot be nil"];
    }
}

- (void)removeObjectAtIndexSafe:(NSUInteger)index
{
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSMutableArray removeObjectAtIndexSafe range {%zi, 1} extends beyond bounds [0 .. %zi]",index,self.count-1]];
    }
}

- (void)replaceObjectAtIndexSafe:(NSUInteger)index withObject:(id _Nonnull)anObject
{
    if (anObject) {
        if (index < self.count) {
            [self replaceObjectAtIndex:index withObject:anObject];
        }else
        {
            [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSMutableArray replaceObjectAtIndexSafe index %zi beyond bounds [0 .. %zi]",index,self.count-1]];
        }
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSMutableArray replaceObjectAtIndexSafe object cannot be nil"];
    }
}

- (void)removeObjectsInRangeSafe:(NSRange)range
{
    NSInteger len = self.count - range.location - range.length;
    if (range.location < self.count && len >= 0) {
        [self removeObjectsInRange:range];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSMutableArray replaceObjectAtIndexSafe range {%zi, %zi} extends beyond bounds [0 .. %zi]",range.location,range.length,self.count-1]];
    }
}

- (NSArray *)subarrayWithRangesSafe:(NSRange)range
{
    NSInteger len = self.count - range.location - range.length;
    if (range.location < self.count && len >= 0) {
        return [self subarrayWithRange:range];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSMutableArray subarrayWithRangesSafe range {%zi, %zi} extends beyond bounds [0 .. %zi]",range.location,range.length,self.count-1]];
        return nil;
    }
}

@end
