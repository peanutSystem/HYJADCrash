//
//  NSObject+HYJADCrashSwizzleHook.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "NSObject+HYJADCrashSwizzleHook.h"
#import <objc/runtime.h>

/**
 动态交换两个方法的实现的方法
 
 @param class 需要交换方法的类
 @param isClassMethod YES表示需要交换的方法是类方法，NO表示是对象方法
 @param originSelector 原方法名
 @param swizzleSelector 用以交换的方法名
 */
void swizzleMethod(Class class, BOOL isClassMethod, SEL originSelector, SEL swizzleSelector)
{
    if (!class) {
        return;
    }
    
    /* 获取原类的Method方法 */
    Method originSelectorMethod;
    Method swizzleSelectorMethod;
    /* 获取原对象的元类 */
    Class metaClass;
    /* 根据判断去获取类方法和对象方法 */
    if (isClassMethod) {
        originSelectorMethod = class_getClassMethod(class, originSelector);
        swizzleSelectorMethod = class_getClassMethod(class, swizzleSelector);
        metaClass = objc_getMetaClass(NSStringFromClass(class).UTF8String);
    }else
    {
        originSelectorMethod = class_getInstanceMethod(class, originSelector);
        swizzleSelectorMethod = class_getInstanceMethod(class, swizzleSelector);
        metaClass = class;
    }
    
    
    //在元类中动态添加需要替换的方法swizzleSelectorMethod，并让原方法originSelector的方法实现指针指向替换方法swizzleSelectorMethod
    BOOL isAddMethodResult = class_addMethod(metaClass, originSelector, method_getImplementation(swizzleSelectorMethod), method_getTypeEncoding(swizzleSelectorMethod));
    
    if (isAddMethodResult) {
        //如果添加替换成功,就把替换方法swizzleSelector的实现指针指向原方法
        class_replaceMethod(metaClass, swizzleSelector, method_getImplementation(originSelectorMethod), method_getTypeEncoding(originSelectorMethod));
    }else
    {
        //如果添加替换失败,就先把原originSelector方法实现指针替换成swizzleSelectorMethod。然后在把swizzleSelector方法的实现指针替换成originSelectorMethod.
        class_replaceMethod(metaClass, swizzleSelector, class_replaceMethod(metaClass, originSelector, method_getImplementation(swizzleSelectorMethod), method_getTypeEncoding(swizzleSelectorMethod)), method_getTypeEncoding(originSelectorMethod));
        
    }
}



@implementation NSObject (HYJADCrashSwizzleHook)

/**
 动态交换当前类的 两个方法的实现
 
 @param isClassMethod YES表示需要交换的方法是类方法，NO表示是对象方法
 @param originSelector 原方法名
 @param swizzleSelector 用以交换的方法名
 */
+ (void)hyj_swizzleSelfMethodWithIsClassMethod:(BOOL)isClassMethod  originSelector:(SEL)originSelector swizzleSelector:(SEL)swizzleSelector
{
    swizzleMethod(self.class, isClassMethod, originSelector, swizzleSelector);
}

@end
