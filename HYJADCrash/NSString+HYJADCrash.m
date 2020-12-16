//
//  NSString+HYJADCrash.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "NSString+HYJADCrash.h"
#import "NSObject+HYJADCrashSwizzleHook.h"
#import "HYJADCrashCollectManager.h"

@implementation NSString (HYJADCrash)

#pragma mark - Register

/**
 注册NSString的防Crash方法
 */
+ (void)hyjadc_registerNSStringPreventCrash
{
    [self hyjadc_swizzle];
}

#pragma mark - swizzle
+ (void)hyjadc_swizzle
{
    /* Class Method */
    [self hyjadc_swizzleNSString];
    
    /* Instance Method */
    //NSPlaceholderString
    [self hyjadc_swizzleNSPlaceholderString];
    //__NSCFConstantString
    [self hyjadc_swizzleNSCFConstantString];
    
}

+ (void)hyjadc_swizzleNSString
{
    swizzleMethod(self.class, YES, @selector(stringWithUTF8String:), @selector(hyjadc_swizzleStringWithUTF8String:));
    swizzleMethod(self.class, YES, @selector(stringWithCString:encoding:), @selector(hyjadc_swizzleStringWithCString:encoding:));
}


+ (void)hyjadc_swizzleNSPlaceholderString
{
    swizzleMethod(NSClassFromString(@"NSPlaceholderString"), NO, @selector(initWithString:), @selector(hyjadc_swizzleInitWithString:));
    swizzleMethod(NSClassFromString(@"NSPlaceholderString"), NO, @selector(initWithCString:encoding:), @selector(hyjadc_swizzleInitWithCString:encoding:));
}

+ (void)hyjadc_swizzleNSCFConstantString
{
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(substringFromIndex:), @selector(hyjadc_swizzleSubstringFromIndex:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(substringToIndex:), @selector(hyjadc_swizzleSubstringToIndex:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(substringWithRange:), @selector(hyjadc_swizzleSubstringWithRange:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(rangeOfString:options:range:locale:), @selector(hyjadc_swizzleRangeOfString:options:range:locale:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(rangeOfString:), @selector(hyjadc_swizzleRangeOfString:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(componentsSeparatedByString:), @selector(hyjadc_swizzleComponentsSeparatedByString:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(stringByAppendingString:), @selector(hyjadc_swizzleStringByAppendingString:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(hasPrefix:), @selector(hyjadc_swizzleHasPrefix:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(hasSuffix:), @selector(hyjadc_swizzleHasSuffix:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(stringByReplacingCharactersInRange:withString:), @selector(hyjadc_swizzleStringByReplacingCharactersInRange:withString:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(stringByReplacingOccurrencesOfString:withString:), @selector(hyjadc_swizzleStringByReplacingOccurrencesOfString:withString:));
    swizzleMethod(NSClassFromString(@"__NSCFConstantString"), NO, @selector(stringByReplacingOccurrencesOfString:withString:options:range:), @selector(hyjadc_swizzleStringByReplacingOccurrencesOfString:withString:options:range:));
}


#pragma mark - Class Method

+ (instancetype)hyjadc_swizzleStringWithUTF8String:(const char *)nullTerminatedCString
{
    if (nullTerminatedCString != NULL) {
        return [self hyjadc_swizzleStringWithUTF8String:nullTerminatedCString];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString stringWithUTF8String cannot NULL char"];
        return nil;
    }
}

+ (instancetype)hyjadc_swizzleStringWithCString:(const char *)cString encoding:(NSStringEncoding)enc
{
    if (cString != NULL) {
        return [self hyjadc_swizzleStringWithCString:cString encoding:enc];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString stringWithCString:encoding: cannot NULL char"];
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

- (instancetype)hyjadc_swizzleInitWithCString:(const char *)nullTerminatedCString encoding:(NSStringEncoding)encoding
{
    if (nullTerminatedCString != NULL) {
        return [self hyjadc_swizzleInitWithCString:nullTerminatedCString encoding:encoding];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString initWithCString cannot nil char"];
        return nil;
    }
}

- (NSString *)hyjadc_swizzleSubstringFromIndex:(NSUInteger)from
{
    if (from <= self.length) {
        return [self hyjadc_swizzleSubstringFromIndex:from];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSString substringFromIndex Index %zi  bounds [0...%zi]",from,self.length-1]];
        return nil;
    }
}

- (NSString *)hyjadc_swizzleSubstringToIndex:(NSUInteger)to
{
    if (to <= self.length) {
        return [self hyjadc_swizzleSubstringToIndex:to];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSString substringToIndex Index %zi  bounds [0...%zi]",to,self.length-1]];
        return [self hyjadc_swizzleSubstringToIndex:self.length];
    }
}

- (NSString *)hyjadc_swizzleSubstringWithRange:(NSRange)range
{
    if ((range.length+range.location) <= self.length) {
        return [self hyjadc_swizzleSubstringWithRange:range];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSString substringWithRange Range %@  bounds [0...%zi]",NSStringFromRange(range),self.length-1]];
        if (range.location <= (self.length-1)) {
            return [self hyjadc_swizzleSubstringWithRange:NSMakeRange(range.location, self.length-1)];
        }else
        {
            return self;
        }
    }
}

- (NSRange)hyjadc_swizzleRangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(NSLocale *)locale
{
    if (searchString) {
        if ((rangeOfReceiverToSearch.length+rangeOfReceiverToSearch.location) <= self.length) {
            return [self hyjadc_swizzleRangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
        }else
        {
            [[HYJADCrashCollectManager shared] commitCrashLog:[[NSString alloc] initWithFormat:@"NSString NSString rangeOfString:options:options:locale:  Range %@  bounds [0...%zi]",NSStringFromRange(rangeOfReceiverToSearch),self.length-1]];
            return NSMakeRange(NSNotFound, 0);
        }
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString rangeOfString:options:options:locale: searchString cannot nil"];
        return NSMakeRange(NSNotFound, 0);
    }
}

- (NSArray<NSString *> *)hyjadc_swizzleComponentsSeparatedByString:(NSString *)separator
{
    if (separator) {
        return [self hyjadc_swizzleComponentsSeparatedByString:separator];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString componentsSeparatedByString string nil argument"];
        return nil;
    }
}

- (NSString *)hyjadc_swizzleStringByAppendingString:(NSString *)aString
{
    if (aString) {
        return [self hyjadc_swizzleStringByAppendingString:aString];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString stringByAppendingString string nil argument"];
        return self;
    }
}

- (BOOL)hyjadc_swizzleHasPrefix:(NSString *)str
{
    if (str) {
        return [self hyjadc_swizzleHasPrefix:str];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString hasPrefix string nil argument"];
        return NO;
    }
}

- (BOOL)hyjadc_swizzleHasSuffix:(NSString *)str
{
    if (str) {
        return [self hyjadc_swizzleHasSuffix:str];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString hasSuffix string nil argument"];
        return NO;
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

- (NSRange)hyjadc_swizzleRangeOfString:(NSString *)searchString
{
    if (searchString) {
        return [self hyjadc_swizzleRangeOfString:searchString];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSString rangeOfString string cannot nil"];
        return NSMakeRange(NSNotFound, 0);
    }
}

@end
