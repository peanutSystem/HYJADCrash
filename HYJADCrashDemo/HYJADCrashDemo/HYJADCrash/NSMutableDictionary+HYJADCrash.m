//
//  NSMutableDictionary+HYJADCrash.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "NSMutableDictionary+HYJADCrash.h"
#import "HYJADCrashCollectManager.h"

@implementation NSMutableDictionary (HYJADCrash)

- (void)setObjectSafe:(id _Nonnull)anObject forKey:(id<NSCopying>)aKey
{
    if (aKey) {
        if (anObject) {
            [self setObject:anObject forKey:aKey];
        }else
        {
            [[HYJADCrashCollectManager shared] commitCrashLog:@"NSMutableDictionary setObjectSafe:forKey: object cannot be nil"];
        }
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSMutableDictionary setObjectSafe:forKey: key cannot be nil"];
    }
}

- (void)setValueSafe:(id _Nonnull)anObject forKey:(NSString *)key
{
    if (key) {
        [self setValue:anObject forKey:key];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSMutableDictionary setObjectSafe:forKey: key cannot be nil"];
    }
}


/**
 根据 key值获取字典中的数据
 
 @param aKey key值
 @param isNullable 是否允许取出来的对象为空  如果填入YES 则根据key值取不出来数据时 会根据传入的class参数 自动生成一个对应空的实例化对象  NO 则在取不出数据时 直接返回nil
 @param className 判断 根据key值所取出来的对象类名是否正确 如果错误则会根据class 自动生成一个对应空的实例化对象 返回  如果不传则不判断
 @return 取出的数据
 */
- (nullable id)objectForKeySafe:(NSString *__nonnull)aKey isNullable:(BOOL)isNullable withObjectClassName:(NSString *__nullable)className;
{
    if (aKey) {
        id object = [self objectForKey:aKey];
        if (className) {
            if ([object isKindOfClass:NSClassFromString(className)]) {
                return object;
            }else
            {
                return [self getObjectForClassName:className isNullable:isNullable];
            }
        }else
        {
            return object;
        }
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSMutableDictionary objectForKeySafe:withTypeClass:isNullable key cannot be nil"];
        return [self getObjectForClassName:className isNullable:isNullable];
    }
}

- (id)getObjectForClassName:(NSString *)className isNullable:(BOOL)isNullable
{
    if(isNullable)
    {
        return nil;
    }else
    {
        if (className) {
            Class cls = NSClassFromString(className);
            if ([cls respondsToSelector:@selector(alloc)]) {
                id objCls = [cls alloc];
                if ([objCls respondsToSelector:@selector(init)]) {
                    id object = [[cls alloc] init];
                    return object;
                }else
                {
                    return @"";
                }
            }else
            {
                return @"";
            }
        }else
        {
            return @"";
        }
    }
}


- (void)removeObjectForKeySafe:(id)aKey
{
    if (aKey) {
        [self removeObjectForKey:aKey];
    }else
    {
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSMutableDictionary removeObjectForKeySafe key cannot be nil"];
    }
}

@end
