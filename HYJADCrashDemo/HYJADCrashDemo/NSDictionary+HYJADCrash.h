//
//  NSDictionary+HYJADCrash.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (HYJADCrash)

/**
 构造只有一个元素的不可变字典的安全方法

 @param object 唯一元素
 @param key 与元素对应的key
 @return 不可变字典
 */
+ (instancetype)dictionaryWithObjectSafe:(id _Nonnull)object forKey:(id<NSCopying>)key;


/**
 根据 key值获取字典中的数据
 
 @param aKey key值
 @param isNullable 是否允许取出来的对象为空  如果填入YES 则根据key值取不出来数据时 会根据传入的class参数 自动生成一个对应空的实例化对象  NO 则在取不出数据时 直接返回nil
 @param className 判断 根据key值所取出来的对象类名是否正确 如果错误则会根据class 自动生成一个对应空的实例化对象 返回  如果不传则不判断
 @return 取出的数据
 */
- (nullable id)objectForKeySafe:(NSString *__nonnull)aKey isNullable:(BOOL)isNullable withObjectClassName:(NSString *__nullable)className;

@end

NS_ASSUME_NONNULL_END
