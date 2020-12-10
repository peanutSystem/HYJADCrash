//
//  NSObject+HYJADCrashPrevent.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HYJADCrashPrevent)

/** kvo键值观察者储存对象 */
@property (nonatomic, retain) NSMutableDictionary<NSString *, NSHashTable<NSObject *> *> *hyjadcKvoDictionary;


/**
 注册unrecognized selector的crash防止
 */
+ (void)hyjadc_registerUnrecognizedSelector;

#pragma mark - KVC

//- (void)setValueSafe:(id)value forKey:(NSString *)key;

//- (void)setValueSafe:(id)value forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
