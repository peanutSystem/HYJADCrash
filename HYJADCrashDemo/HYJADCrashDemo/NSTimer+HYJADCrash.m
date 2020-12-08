//
//  NSTimer+HYJADCrash.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "NSTimer+HYJADCrash.h"

#import "NSObject+HYJADCrashSwizzleHook.h"
#import "HYJADCrashCollectManager.h"


#pragma mark - ---------------------------------------------  TimerIntermediateProcessingObject  ---------------------------------------------
//中间引用层
@interface HYJADCTimerIntermediateProcessingObject : NSObject
{}

/* 弱引用记录原类 */
@property(nonatomic, weak) id target;
/* 原本Timer所要执行的方法 */
@property(nonatomic,assign) SEL selector;
/* 原本Timer所记录的userInfo信息 */
@property(nonatomic, assign) id userInfo;
/* 新的Timer */
@property(nonatomic, weak)NSTimer *timer;
/* 执行的间隔时间 */
@property(nonatomic, readwrite, assign) NSTimeInterval ti;


@end

@implementation HYJADCTimerIntermediateProcessingObject

- (void)fire
{
    if (self.target) {
        //原实例还存在时直接调用方法，由于调用performSelector方法，编译器无法在编译时检查是否有该selector方法存在。所以会发出警告，加上这三句#pragma clang可以消除警告
        if ([self.target respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.selector];
#pragma clang diagnostic pop
        }
    }else
    {
        //如果原实例已被销毁则销毁Timer
        [self.timer invalidate];
        self.timer = nil;
        //原实例已被销毁却依然调用该fire方法，说明有异常
        [[HYJADCrashCollectManager shared] commitCrashLog:@"NSTimer abnormal, Need invalidate NSTimer"];
    }
}


@end


#pragma mark - ---------------------------------------------  HYJADCrash  ---------------------------------------------

@implementation NSTimer (HYJADCrash)

/**
 注册Timer自动销毁
 */
+ (void)hyjadc_registerTimerPreventCrash
{
    [self hyjadc_swizzleScheduledTimerWithTimeInterval];
}

+ (void)hyjadc_swizzleScheduledTimerWithTimeInterval
{
    swizzleMethod([NSTimer class], YES, @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:), @selector(hyjadc_scheduledTimerWithTimeIntervalSafe:target:selector:userInfo:repeats:));
}

+ (NSTimer *)hyjadc_scheduledTimerWithTimeIntervalSafe:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    //忽略非重复执行的Timer
    if (!yesOrNo) {
        return [self hyjadc_scheduledTimerWithTimeIntervalSafe:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    }
    
    //创建中间处理类去桥接原引用Timer对象 与Timer对象
    HYJADCTimerIntermediateProcessingObject *object = [HYJADCTimerIntermediateProcessingObject new];
    //设置属性，建立原类对象与中间处理类的关联
    object.target = aTarget;
    object.selector = aSelector;
    object.ti = ti;
    object.userInfo = userInfo;
    //创建一个新的Time，建立与中间处理类的关联
    NSTimer *timer = [NSTimer hyjadc_scheduledTimerWithTimeIntervalSafe:ti target:object selector:@selector(fire) userInfo:userInfo repeats:yesOrNo];
    object.timer = timer;
    
    return timer;
}

@end
