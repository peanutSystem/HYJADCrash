//
//  NSObject+HYJADCrashCancelDelayed.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/8.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYJADCrashDelayedBlockHandle)(BOOL cancel);

@interface NSObject ()



static void hyjadcrash_cancel_delayed_block(HYJADCrashDelayedBlockHandle delayedHandle);

//可取消执行的延迟任务
static HYJADCrashDelayedBlockHandle hyjadcrash_perform_block_after_delay(CGFloat seconds, dispatch_block_t block);

@end

static void hyjadcrash_cancel_delayed_block(HYJADCrashDelayedBlockHandle delayedHandle) {
    if (nil == delayedHandle) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        delayedHandle(YES);
    });
}

//可取消执行的延迟任务
static HYJADCrashDelayedBlockHandle hyjadcrash_perform_block_after_delay(CGFloat seconds, dispatch_block_t block) {
    
    if (block == nil) {
        return nil;
    }
    
    __block dispatch_block_t blockToExecute = [block copy];//放入堆
    __block HYJADCrashDelayedBlockHandle delayHandleCopy = nil;//放入堆
    
    HYJADCrashDelayedBlockHandle delayHandle = ^(BOOL cancel) {
        if (!cancel && blockToExecute) {
            blockToExecute();
        }
        
#if !__has_feature(objc_arc)//MRC模式下 需要手动释放 block对象
        [blockToExecute release];
        [delayHandleCopy release];
#endif
        
        blockToExecute = nil;
        delayHandleCopy = nil;
    };
    
    delayHandleCopy = [delayHandle copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (nil != delayHandleCopy) {
            delayHandleCopy(NO);
        }
    });
    
    return delayHandleCopy;
}

NS_ASSUME_NONNULL_END
