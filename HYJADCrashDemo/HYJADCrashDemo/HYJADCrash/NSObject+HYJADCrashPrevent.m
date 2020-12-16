//
//  NSObject+HYJADCrashPrevent.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "NSObject+HYJADCrashPrevent.h"
#import "NSObject+HYJADCrashSwizzleHook.h"

#import "HYJADCrashCollectManager.h"

#import <objc/runtime.h>


// 判断是否是系统类
static inline BOOL IsSystemClass(Class cls){
    BOOL isSystem = NO;
    NSString *className = NSStringFromClass(cls);
    if ([className hasPrefix:@"NS"] || [className hasPrefix:@"__NS"] || [className hasPrefix:@"OS_xpc"]) {
        isSystem = YES;
        return isSystem;
    }
    NSBundle *mainBundle = [NSBundle bundleForClass:cls];
    if (mainBundle == [NSBundle mainBundle]) {
        isSystem = NO;
    }else{
        isSystem = YES;
    }
    return isSystem;
}


#pragma mark - ---------------------------------------------  IntermediateProcessingObject  ---------------------------------------------
//中间类去相应对应方法
@interface HYJADCIntermediateProcessingObject : NSObject

//用于储存调用该方法的原对象
@property(nonatomic,readwrite,weak)id fromObject;

@end


@implementation HYJADCIntermediateProcessingObject

id hyjadc_unrecognizedSelectorMethod(HYJADCIntermediateProcessingObject* self, SEL _cmd){
    NSString* message = [[[NSString alloc] initWithFormat:@"Unrecognized selector class:%@ and selector:%@",[self.fromObject class],NSStringFromSelector(_cmd)] autorelease];
    //一般把异常信息保存到本地，然后发送到服务端
    [[HYJADCrashCollectManager shared] commitCrashLog:message];
    return nil;
}

- (void)dealloc
{
    [super dealloc];
    NSLog(@"HYJADCIntermediateProcessingObject------dealloc");
}

@end


static char const * KVODictionaryKey = "HYJADCrash_KVODICTIONARYKEY";
@implementation NSObject (HYJPreventCrash)

+ (void)hyjadc_registerUnrecognizedSelector
{
    //消息转发
    [self hyjadc_swizzleForwardingTargetForSelector];
    
    //kvo
    [self hyjadc_swizzleAddObserverForKeyPathOptionsContext];
}

#pragma mark - 消息转发处理
/**
 替换forwardingTargetForSelector方法
 */
+ (void)hyjadc_swizzleForwardingTargetForSelector
{
    //替换原forwardingTargetForSelector方法
    swizzleMethod([self class], NO, @selector(forwardingTargetForSelector:), @selector(hyjadc_forwardingTargetForSelectorInstance:));
    swizzleMethod([self class], YES, @selector(forwardingTargetForSelector:), @selector(hyjadc_forwardingTargetForSelectorClass:));
}


//通过该方法来实现对unrecognized Selector错误的防止crash。
+ (id)hyjadc_forwardingTargetForSelectorClass:(SEL)aSelector
{
    //获取方法签名
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];

    //当没有找到方法签名时,创建一个临时对象去执行空方法，防止crash
    if (!signature) {
        return [self hyjadc_selectorPointIntermediateClassForSelector:aSelector];
    }
    //执行forwardingTargetForSelector，因为已经动态替换了forwardingTargetForSelector与hyj_ForwardingTargetForSelector，所以执行hyj_ForwardingTargetForSelector就是执行forwardingTargetForSelector
    return [self hyjadc_forwardingTargetForSelectorClass:aSelector];
}

//通过该方法来实现对unrecognized Selector错误的防止crash。
- (id)hyjadc_forwardingTargetForSelectorInstance:(SEL)aSelector
{
    //获取方法签名
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];

    //当没有找到方法签名时,创建一个临时对象去执行空方法，防止crash
    if (!signature) {
        return [self hyjadc_selectorPointIntermediateClassForSelector:aSelector];
    }
    //执行forwardingTargetForSelector，因为已经动态替换了forwardingTargetForSelector与hyj_ForwardingTargetForSelector，所以执行hyj_ForwardingTargetForSelector就是执行forwardingTargetForSelector
    return [self hyjadc_forwardingTargetForSelectorInstance:aSelector];
}


//创建中间响应类
- (id)hyjadc_createIntermediateClassForSelector:(SEL)aSelector
{
    //创建一个IntermediateProcessingObject对象，用作临时处理该方法。
    //该类处于MRC模式下，所以需要注意对象的释放需要自己控制
    id intermediateClass = [[HYJADCIntermediateProcessingObject new] autorelease];
    //把出错的对象赋值给中间处理类，用来记录错误
    [intermediateClass setFromObject:self];
    
    return intermediateClass;
}

- (id)hyjadc_selectorPointIntermediateClassForSelector:(SEL)aSelector
{
    id intermediateClass = [self hyjadc_createIntermediateClassForSelector:aSelector];
    
    [self hyjadc_dynamicAddMethodWithObject:intermediateClass forSelector:aSelector];
    
    return intermediateClass;
}

- (id)hyjadc_dynamicAddMethodWithObject:(id)object forSelector:(SEL)aSelector
{
    //动态添加将原本需要执行的aSelector方法，的实现指针指向unrecognizedSelectorMethod方法。
    //从而避免crash
    class_addMethod([object class], aSelector, (IMP)hyjadc_unrecognizedSelectorMethod, "v@:");
    
    return object;
}


#pragma mark - KVC处理 (目前还未测试完成，卡在了数组赋值和数组套数组的情景)

- (void)setValueSafe:(id)value forKey:(NSString *)key
{
    if ([self validateValue:value forKey:key])
    {
        if ([self validateSetKey:key])
        {
            [self setValue:value forKey:key];
        }
    }
}

- (void)setValueSafe:(id)value forKeyPath:(NSString *)keyPath
{
    @autoreleasepool {
        if ([self validateValue:value forKey:keyPath])
        {
            BOOL isHandle = NO;
            
            NSArray *keyPathArray = [[keyPath componentsSeparatedByString:@"."] autorelease];
            
            if (keyPathArray.count == 1)
            {
                isHandle = YES;
                [self setValueSafe:value forKey:keyPath];
            } else
            {
                id object = [self validateKeyPathWithKeyPathArray:keyPathArray];
                if (object) {
                    isHandle = YES;
                    [object setValueSafe:value forKey:[keyPathArray lastObject]];
                }
            }

            if (!isHandle) {
                NSString *message = [[[NSString alloc] initWithFormat:@"[setValueSafe:keyPath]-[setValue:forUndefinedKey:]: this class is not key value coding-compliant for the keyPath %@.",keyPath] autorelease];
                [[HYJADCrashCollectManager shared] commitCrashLog:message];
            }
        }
    }
}

- (id)hyj_valueForUndefinedKey:(NSString *)key
{//
    NSString *message = [[[NSString alloc] initWithFormat:@"[valueForKey:]: this class is not key value coding-compliant for the key %@.",key] autorelease];
    [[HYJADCrashCollectManager shared] commitCrashLog:message];
    return nil;
}

- (id)hyj_valueForKeyPath:(NSString *)keyPath
{//
    @autoreleasepool {
        if (![self validateString:keyPath])
        {
            NSString *message = [[[NSString alloc] initWithFormat:@"[valueForKeyPath:]: keyPath is not null"] autorelease];
            [[HYJADCrashCollectManager shared] commitCrashLog:message];
            return nil;
        }
        
        NSArray *keyPathArray = [[keyPath componentsSeparatedByString:@"."] autorelease];
        
        if (keyPathArray.count == 1)
        {
            return [self valueForKey:keyPath];
        } else
        {
            id object = [self validateKeyPathWithKeyPathArray:keyPathArray];
            
            if (object) {
                return [object valueForKey:[keyPathArray lastObject]];
            }
        }
        NSString *message = [[[NSString alloc] initWithFormat:@"[valueForKeyPath:]: this class is not key value coding-compliant for the keyPath %@.",keyPath] autorelease];
        [[HYJADCrashCollectManager shared] commitCrashLog:message];
        return nil;
    }
}

    
- (id)getValueWithObject:(id)object key:(NSString *)key
{
    @autoreleasepool {
        //Key
        NSString * Key = [key.capitalizedString autorelease];

        //先找相关方法 get<Key>,key
        NSString * getKey = [[NSString stringWithFormat:@"get%@",Key] autorelease];

        if ([object respondsToSelector:NSSelectorFromString(getKey)]
            || [object respondsToSelector:NSSelectorFromString(key)]) {
            return [object valueForKey:key];
        } else if ([[object class] accessInstanceVariablesDirectly]) {
            //再找相关变量
            //获取所有的成员变量
            unsigned int count = 0;
            Ivar * ivars = class_copyIvarList([object class], &count);
            NSMutableArray * arr = [[[NSMutableArray alloc] init] autorelease];
            for (int i = 0; i<count; i++) {
                Ivar var = ivars[i];
                const char * varName = ivar_getName(var);
                NSString *name = [[NSString stringWithUTF8String:varName] autorelease];
                [arr addObject:name];
            }

            //_<key> _is<Key> <key> is<Key>
            for (int i = 0; i < count; i++) {
                NSString *keyName = arr[i];
                if ([keyName isEqualToString:[[NSString stringWithFormat:@"_%@",key] autorelease]]
                    || [keyName isEqualToString:[[NSString stringWithFormat:@"_is%@",Key] autorelease]]
                    || [keyName isEqualToString:[[NSString stringWithFormat:@"%@",key] autorelease]]
                    || [keyName isEqualToString:[[NSString stringWithFormat:@"is%@",Key] autorelease]]) {

                    return object_getIvar(object, ivars[i]);
                }
            }
            free(ivars);
        }
    }
    

    return nil;
}

- (BOOL)validateValue:(id)value forKey:(NSString *)key
{
    @autoreleasepool {
        if (![self validateValue:value])
        {
            if (![self validateString:key])
            {
                NSString *message = [[[NSString alloc] initWithFormat:@"[setValueSafe:forKey]-[setValue:forUndefinedKey:]: key is not null"] autorelease];
                [[HYJADCrashCollectManager shared] commitCrashLog:message];
            } else
            {
                NSString *message = [[[NSString alloc] initWithFormat:@"[setValueSafe:forKey]-[setValue:forUndefinedKey:]: %@ value not null",key] autorelease];
                [[HYJADCrashCollectManager shared] commitCrashLog:message];
            }
            return NO;
        }
        return YES;
    }
}


- (BOOL)validateValue:(id)value
{
    if (!value)
    {
        return NO;
    }
    return YES;
}

- (BOOL)validateSetKey:(NSString *)key
{
    BOOL result = NO;
    
    //Key
    NSString * Key = [key.capitalizedString autorelease];

    //先找相关方法 set<Key>; _set<Key>; setIs<Key>;
    NSString * setKey = [[NSString stringWithFormat:@"set%@:",Key] autorelease];
    NSString * _setKey = [[NSString stringWithFormat:@"_set%@:",Key] autorelease];
    NSString * setIsKey = [[NSString stringWithFormat:@"setIs%@:",Key] autorelease];
    
    if ([self respondsToSelector:NSSelectorFromString(setKey)]
        || [self respondsToSelector:NSSelectorFromString(_setKey)]
        || [self respondsToSelector:NSSelectorFromString(setIsKey)])
    {
        result = YES;
    }else if ([self.class accessInstanceVariablesDirectly])
    {
        //再找相关变量
        //获取所有的成员变量
        unsigned int count = 0;
        Ivar * ivars = class_copyIvarList([self class], &count);
        NSMutableArray * arr = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 0; i < count; i++)
        {
            Ivar var = ivars[i];
            const char * varName = ivar_getName(var);
            NSString *name = [[NSString stringWithUTF8String:varName] autorelease];
            [arr addObject:name];
        }

        //_<key> _is<Key> <key> is<Key>
        for (int i = 0; i < count; i++) {
            NSString *keyName = arr[i];
            if ([keyName isEqualToString:[[NSString stringWithFormat:@"_%@",key] autorelease]]
                || [keyName isEqualToString:[[NSString stringWithFormat:@"_is%@",Key] autorelease]]
                || [keyName isEqualToString:[[NSString stringWithFormat:@"%@",key] autorelease]]
                || [keyName isEqualToString:[[NSString stringWithFormat:@"is%@",Key] autorelease]])
            {
                result = YES;
                break;
            }
        }
        free(ivars);
    }
    
    if (!result) {
        NSString* message = [[[NSString alloc] initWithFormat:@"[setValueSafe:forKey]-[setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key %@.",key] autorelease];
        [[HYJADCrashCollectManager shared] commitCrashLog:message];
    }
    
    return result;
}

- (id)validateKeyPathWithKeyPathArray:(NSArray *)keyPathArray
{
    BOOL hasObject = YES;
    id object = self;
    for (NSInteger i = 0; i < (keyPathArray.count-1); i++)
    {
        NSString *key = [keyPathArray objectAtIndex:i];
        object = [self validataObject:object key:key];
        if (!object) {
            hasObject = NO;
        }
    }
    
    return object;
}

- (NSMutableArray *)validataObject:(id)object key:(NSString *)key
{
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray *objectArray = (NSArray *)object;
        NSMutableArray *resultArray = [[NSMutableArray new] autorelease];
        for (NSInteger i =0; i < objectArray.count; i++) {
            id obj = [objectArray objectAtIndex:i];
            id resultObj = [self getValueWithObject:obj key:key];
            if (resultObj) {
                [resultArray addObject:resultObj];
            } else {
                [resultArray addObject:[[NSNumber numberWithInt:0] autorelease]];
            }
        }
        return resultArray;
    } else {
        return [self getValueWithObject:object key:key];;
    }
}

- (BOOL)validateString:(NSString *)string
{
    if (string == nil || string == NULL)
    {
        return NO;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    if (![string isKindOfClass:[NSString class]])
    {
        return NO;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        return NO;
    }
    return YES;
}

#pragma mark - KVO

/**
 替换addObserver:forKeyPath:options:context:方法
 */
+ (void)hyjadc_swizzleAddObserverForKeyPathOptionsContext
{
    //替换原addObserver:forKeyPath:options:context:方法
    swizzleMethod([self class], NO, @selector(addObserver:forKeyPath:options:context:), @selector(hyjadc_addObserver:forKeyPath:options:context:));
    //替换原removeObserver:forKeyPath:context:方法
    swizzleMethod([self class], NO, @selector(removeObserver:forKeyPath:context:), @selector(hyjadc_removeObserver:forKeyPath:context:));
}


- (void)hyjadc_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if (IsSystemClass(self.class)) {
        [self hyjadc_addObserver:observer forKeyPath:keyPath options:options context:context];
    } else {
        //检查是否重新了addObserver:forKeyPath:options:context:
        if ([self hyjadc_isCanAddObserver:observer forKeyPath:keyPath options:options context:context])
        {
            NSHashTable<NSObject *> *info = [self.hyjadcKvoDictionary objectForKey:keyPath];
            if (!info)
            {
                info = [[[NSHashTable alloc] initWithOptions:(NSPointerFunctionsWeakMemory) capacity:0] autorelease];
            }
            [info addObject:observer];
            [self.hyjadcKvoDictionary setObject:info forKey:keyPath];
            [self hyjadc_addObserver:observer forKeyPath:keyPath options:options context:context];
        }
    }
    
}

- (void)hyjadc_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if (IsSystemClass(self.class)) {
        [self hyjadc_removeObserver:observer forKeyPath:keyPath];
    } else {
        if ([self hyjadc_removeDictionaryObserver:observer forKeyPath:keyPath]) {
            [self hyjadc_removeObserver:observer forKeyPath:keyPath];
        }
    }
}


- (void)hyjadc_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    if ([self hyjadc_removeDictionaryObserver:observer forKeyPath:keyPath]) {
        [self hyjadc_removeObserver:observer forKeyPath:keyPath context:context];
    }
}

- (BOOL)hyjadc_removeDictionaryObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if (observer && [self validateString:keyPath]) {
        if (!objc_getAssociatedObject(self, KVODictionaryKey)) {
            return NO;
        }
        NSHashTable<NSObject *> *info = [self.hyjadcKvoDictionary objectForKey:keyPath];
        if (info && info.count > 0)
        {
            if ([info containsObject:observer]) {
                [info removeObject:observer];
                if (info.count == 0) {
                    [self.hyjadcKvoDictionary removeObjectForKey:keyPath];
                }
                return YES;
            }
        }
        NSString *message = [[[NSString alloc] initWithFormat:@"Cannot remove an observer for the key path <- %@ -> from <HYJADCrashTestTwo 0x60000077c0a0> because it is not registered as an observer.",keyPath] autorelease];
        [[HYJADCrashCollectManager shared] commitCrashLog:message];
    } else {
        NSString *message = [[[NSString alloc] initWithFormat:@"remove an nil keyPath or observer"] autorelease];
        [[HYJADCrashCollectManager shared] commitCrashLog:message];
    }
    
    
    return NO;
}


- (BOOL)hyjadc_isCanAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if (observer && [observer respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)])
    {
        SEL addObserver_sel = @selector(observeValueForKeyPath:ofObject:change:context:);
        
        // 获取 NSObject 的observeValueForKeyPath方法
        Method root_forwarding_method = class_getInstanceMethod([NSObject class], addObserver_sel);
        // 获取 当前类 的observeValueForKeyPath方法
        Method current_forwarding_method = class_getInstanceMethod([observer class], addObserver_sel);
        
        // 判断 当前类的observeValueForKeyPath方法的imp 与 NSObject类的observeValueForKeyPath方法的imp是否相同
        BOOL realize = method_getImplementation(current_forwarding_method) == method_getImplementation(root_forwarding_method);
        
        if (!realize)
        {//说明当前类已经重写observeValueForKeyPath
            NSHashTable<NSObject *> *info = [self.hyjadcKvoDictionary objectForKey:keyPath];
            if (!info)
            {
                return YES;
            } else if (info.count > 0)
            {
                if (info.count == 0) {
                    return YES;
                } else {
                    if (![info containsObject:observer]) {
                        return YES;
                    }
                }
            }
            NSString *meesage = [[[NSString alloc] initWithFormat:@"<%@>: addObserver:forKeyPath:options:context: more keyPath",observer.class] autorelease];
            [[HYJADCrashCollectManager shared] commitCrashLog:meesage];
        } else {
            NSString *meesage = [[[NSString alloc] initWithFormat:@"<%@>: An -observeValueForKeyPath:ofObject:change:context: message was received but not handled",observer.class] autorelease];
            [[HYJADCrashCollectManager shared] commitCrashLog:meesage];
        }
        
    } else
    {
        NSString *meesage = [[[NSString alloc] initWithFormat:@"<%@>: An -observeValueForKeyPath:ofObject:change:context: message was received but not handled",observer.class] autorelease];
        [[HYJADCrashCollectManager shared] commitCrashLog:meesage];
    }
    return NO;
}

- (NSMutableDictionary *)hyjadcKvoDictionary
{
    id hyjadcKvoDictionary = objc_getAssociatedObject(self, KVODictionaryKey);
    
    if (!hyjadcKvoDictionary) {
        hyjadcKvoDictionary = [[NSMutableDictionary new] autorelease];
        objc_setAssociatedObject(self, KVODictionaryKey, hyjadcKvoDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return hyjadcKvoDictionary;
}

- (void)sethyjadcKvoDictionary:(NSMutableDictionary *)hyjadcKvoDictionary
{
    objc_setAssociatedObject(self, KVODictionaryKey, hyjadcKvoDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
