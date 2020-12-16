//
//  NSMutableString+HYJADCrash.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "NSMutableString+HYJADCrash.h"
#import "NSObject+HYJADCrashSwizzleHook.h"
#import "HYJADCrashCollectManager.h"


@implementation NSMutableString (HYJADCrash)

/**
 注册NSMutableString的防Crash方法
 */
+ (void)hyjadc_registerMutableStringPreventCrash
{
    [self hyjadc_swizzle];
}

#pragma mark - swizzle
+ (void)hyjadc_swizzle
{
    /* Class Method */
    [self swizzleNSMutableString];
    
    /* Instance Method */
    //NSPlaceholderString
    [self swizzleNSPlaceholderString];
    //__NSCFConstantString
    [self swizzleNSCFConstantString];
    
}

+ (void)swizzleNSMutableString
{
    swizzleMethod(self.class, YES, @selector(stringWithString:), @selector(hyjadc_swizzleStringWithString:));
}

+ (void)swizzleNSPlaceholderString
{
    swizzleMethod(NSClassFromString(@"NSPlaceholderString"), NO, @selector(initWithString:), @selector(hyjadc_swizzleInitWithString:));
}

+ (void)swizzleNSCFConstantString
{
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(substringFromIndex:), @selector(hyjadc_swizzleSubstringFromIndex:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(substringToIndex:), @selector(hyjadc_swizzleSubstringToIndex:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(substringWithRange:), @selector(hyjadc_swizzleSubstringWithRange:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(rangeOfString:options:range:locale:), @selector(hyjadc_swizzleRangeOfString:options:range:locale:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(rangeOfString:), @selector(hyjadc_swizzleRangeOfString:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(stringByReplacingCharactersInRange:withString:), @selector(hyjadc_swizzleStringByReplacingCharactersInRange:withString:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(stringByReplacingOccurrencesOfString:withString:), @selector(hyjadc_swizzleStringByReplacingOccurrencesOfString:withString:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(stringByReplacingOccurrencesOfString:withString:options:range:), @selector(hyjadc_swizzleStringByReplacingOccurrencesOfString:withString:options:range:));
}

#pragma mark - Class Method
+ (instancetype)hyjadc_swizzleStringWithString:(NSString *)string
{
    if (string) {
        return [self hyjadc_swizzleStringWithString:string];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSMutableString stringWithString string cannot nil"];
        return nil;
    }
}


#pragma mark - Instance Method
- (instancetype)hyjadc_swizzleInitWithString:(NSString *)aString
{
    if (aString != nil && aString != NULL) {
        return [self hyjadc_swizzleInitWithString:aString];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString initWithString cannot nil string"];
        return nil;
    }
}
- (void)hyjadc_swizzleAppendString:(NSString *)aString
{
    if (aString) {
        [self hyjadc_swizzleAppendString:aString];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSMutableString appendString string cannot nil"];
    }
}

- (NSRange)hyjadc_swizzleRangeOfString:(NSString *)searchString
{
    if (searchString) {
        return [self hyjadc_swizzleRangeOfString:searchString];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSMutableString rangeOfString string cannot nil"];
        return NSMakeRange(NSNotFound, 0);
    }
}


- (NSRange)hyjadc_swizzleRangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(NSLocale *)locale
{
    if (searchString) {
        if ((rangeOfReceiverToSearch.length+rangeOfReceiverToSearch.location) <= self.length) {
            return [self hyjadc_swizzleRangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
        }else
        {
            [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSMutableString NSString rangeOfString:options:options:locale:  Range %@  bounds [0...%zi]",NSStringFromRange(rangeOfReceiverToSearch),self.length-1]];
            return NSMakeRange(NSNotFound, 0);
        }
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSMutableString rangeOfString:options:options:locale: searchString cannot nil"];
        return NSMakeRange(NSNotFound, 0);
    }
}

- (void)hyjadc_swizzleDeleteCharactersInRange:(NSRange)range
{
    if ((range.length+range.location) <= self.length) {
        [self deleteCharactersInRange:range];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSMutableString deleteCharactersInRange Range %@ bounds [0 .. %zi]",NSStringFromRange(range),self.length-1]];
    }
}

- (NSString *)hyjadc_swizzleSubstringFromIndex:(NSUInteger)from
{
    if (from <= self.length) {
        return [self hyjadc_swizzleSubstringFromIndex:from];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSMutableString substringFromIndex Index %zi  bounds [0...%zi]",from,self.length-1]];
        return nil;
    }
}

- (NSString *)hyjadc_swizzleSubstringToIndex:(NSUInteger)to
{
    if (to <= self.length) {
        return [self hyjadc_swizzleSubstringToIndex:to];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSMutableString substringToIndex Index %zi  bounds [0...%zi]",to,self.length-1]];
        return [self hyjadc_swizzleSubstringToIndex:self.length];
    }
}

- (NSString *)hyjadc_swizzleSubstringWithRange:(NSRange)range
{
    if ((range.length+range.location) <= self.length) {
        return [self hyjadc_swizzleSubstringWithRange:range];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSMutableString substringWithRange Range %@  bounds [0 .. %zi]",NSStringFromRange(range),self.length-1]];
        if (range.location <= (self.length-1)) {
            return [self hyjadc_swizzleSubstringWithRange:NSMakeRange(range.location, self.length-1)];
        }else
        {
            return self;
        }
    }
}

- (void)hyjadc_swizzleInsertString:(NSString *)aString atIndex:(NSUInteger)loc
{
    if (aString) {
        if (loc <= self.length) {
            [self hyjadc_swizzleInsertString:aString atIndex:loc];
        }else
        {
            [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSMutableString insertString:atIndex Index %zi  bounds [0 .. %zi]",loc,self.length-1]];
        }
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSMutableString insertString:atIndex string cannot nil"];
    }
}

- (NSString *)hyjadc_swizzleStringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement
{
    if (replacement) {
        if ((range.length+range.location) <= self.length) {
            return [self hyjadc_swizzleStringByReplacingCharactersInRange:range withString:replacement];
        }else
        {
            if (range.location < (self.length-1)) {
                return [self hyjadc_swizzleStringByReplacingCharactersInRange:NSMakeRange(range.location, self.length-range.location) withString:replacement];
            }else
            {
                [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSString stringByReplacingCharactersInRange:withString: Range %@  bounds [0 .. %zi]",NSStringFromRange(range),self.length-1]];
                return nil;
            }
        }
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString stringByReplacingCharactersInRange:withString: string cannot nil"];
        return self;
    }
}

-  (NSString *)hyjadc_swizzleStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement
{
    if (target) {
        if (replacement) {
            return [self hyjadc_swizzleStringByReplacingOccurrencesOfString:target withString:replacement];
        }else
        {
            [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString stringByReplacingOccurrencesOfString:withString: string(replacement) cannot nil"];
            return self;
        }
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString stringByReplacingOccurrencesOfString:withString: string(target) cannot nil"];
        return self;
    }
}

- (NSString *)hyjadc_swizzleStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
{
    if (target) {
        if (replacement) {
            if ((searchRange.length+searchRange.location) <= self.length) {
                return [self hyjadc_swizzleStringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
            }else
            {
                if (searchRange.location < (self.length-1)) {
                    return [self hyjadc_swizzleStringByReplacingOccurrencesOfString:target withString:replacement options:options range:NSMakeRange(searchRange.location, self.length-searchRange.location)];
                }else
                {
                    [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSString stringByReplacingOccurrencesOfString:withString:options:range Range %@  bounds [0 .. %zi]",NSStringFromRange(searchRange),self.length-1]];
                    return self;
                }
            }
        }else
        {
            [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString stringByReplacingOccurrencesOfString:withString:options:range string(replacement) cannot nil"];
            return self;
        }
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString stringByReplacingOccurrencesOfString:withString:options:range string(target) cannot nil"];
        return self;
    }
}

@end
