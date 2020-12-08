//
//  HYJADCrashCollectManager.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//
//          异常信息收集管理类

#import <Foundation/Foundation.h>

@protocol HYJADCrashCollectManagerDelegate <NSObject>

/**
 * @method 监听接收崩溃日志的字符串信息
 例如:
 手机信息:
 手机屏幕大小:宽:375.000000,高:812.000000
 手机方向:加速计:x-->-0.038086,  y-->-0.907257,  z-->-0.406006
 手机型号:iPhone10,3
 手机名称:何宇佳的 iPhone X
 手机系统版本:12.0
 手机电池状态:充电中，并且电量小于 100%  手机电量:100%
 手机网络状态：4G  网络运营商:中国电信
 手机IP:fe80::912e:72f4:654e:1d1b
 手机内存:3.0 GB  手机可用内存：1.2 GB  手机已使用内存：130.5 MB
 手机总容量:255.9 GB 手机可用容量:208.1 GB
 加载地址:4336664576
 基地址:41697280
 NSMutableArray removeObjectAtIndexSafe range {5, 1} extends beyond bounds [0 .. 2]
 (
 0   HYJCrashDemo                        0x00000001027ce220 -[HYJCrashCollect commitCrashLog:] + 76
 1   HYJCrashDemo                        0x00000001027cba74 -[NSMutableArray(HYJSafeMutableArray) removeObjectAtIndexSafe:] + 292
 2   HYJCrashDemo                        0x00000001027cdcb4 -[NextNViewController button2Action] + 188
 3   UIKitCore


 @param crashLog 信息内容
 */
- (void)observerCrashLog:(NSString *_Nonnull)crashLog;


/**
 * @method 监听接收崩溃日志的字典信息,根据自己需要的内容自己提取信息
 例如:
 {
 callStackString = "(\n\t0   HYJCrashDemo                        0x00000001002d9a20 -[HYJCrashCollect commitCrashLog:] + 80\n\t1   HYJCrashDemo                        0x00000001002d7270 -[NSMutableArray(HYJSafeMutableArray) removeObjectAtIndexSafe:] + 292\n\t2   HYJCrashDemo                        0x00000001002d94b0 -[NextNViewController button2Action] + 188\n\t3   UIKitCore                           0x0000000216270c6c <redacted> + 96\n\t4   UIKitCore                           0x0000000216395b38 <redacted> + 80\n\t5   UIKitCore                           0x0000000216395e58 <redacted> + 440\n\t6   UIKitCore                           0x0000000216394e58 <redacted> + 568\n\t7   UIKitCore                           0x0000000216a0d7d4 <redacted> + 2472\n\t8   UIKitCore                           0x0000000216a0ea38 <redacted> + 3156\n\t9   UIKitCore                           0x000000021628ad50 <redacted> + 340\n\t10  UIKitCore                           0x00000002161c68e0 <redacted> + 1440\n\t11  UIKitCore                           0x00000002161c934c <redacted> + 4740\n\t12  UIKitCore                           0x00000002161c1ee0 <redacted> + 152\n\t13  CoreFoundation                      0x00000001e994a5b8 <redacted> + 24\n\t14  CoreFoundation                      0x00000001e994a538 <redacted> + 88\n\t15  CoreFoundation                      0x00000001e9949e1c <redacted> + 176\n\t16  CoreFoundation                      0x00000001e9944ce8 <redacted> + 1040\n\t17  CoreFoundation                      0x00000001e99445b8 CFRunLoopRunSpecific + 436\n\t18  GraphicsServices                    0x00000001ebbb8584 GSEventRunModal + 100\n\t19  UIKitCore                           0x000000021626f558 UIApplicationMain + 212\n\t20  HYJCrashDemo                        0x00000001002dc610 main + 124\n\t21  libdyld.dylib                       0x00000001e9404b94 <redacted> + 4\n)";
 crashLog = "NSMutableArray removeObjectAtIndexSafe range {5, 1} extends beyond bounds [0 .. 2]";
 iPhoneAvailableDiskSize = "208.1 GB";
 iPhoneAvailableMemorySize = "1.2 GB";
 iPhoneBattery = "100%";
 iPhoneBatteryState = "\U5145\U7535\U4e2d\Uff0c\U5e76\U4e14\U7535\U91cf\U5c0f\U4e8e 100%";
 iPhoneIP = "fe80::912e:72f4:654e:1d1b";
 iPhoneName = "\U4f55\U5b87\U4f73\U7684 iPhone X";
 iPhoneNetWorkCarrierName = "\U4e2d\U56fd\U7535\U4fe1";
 iPhoneNetWorkState = 4G;
 iPhonePhysicalMemory = "3.0 GB";
 iPhoneScreenSize = "\U5bbd:375.000000,\U9ad8:812.000000";
 iPhoneSystemVersion = "12.0";
 iPhoneTotalDiskSize = "255.9 GB";
 iPhoneType = "iPhone10,3";
 iPhoneUsedMemory = "129.3 MB";
 loadAddress = 4297916416;
 slideAddress = 2949120;
 }

 @param crashLogDictionary 崩溃日志
 */
- (void)observerCrashLogDictionary:(NSDictionary *_Nonnull)crashLogDictionary;

@end


NS_ASSUME_NONNULL_BEGIN

@interface HYJADCrashCollectManager : NSObject

/* 网络状态切换记录表 */
@property (nonatomic, strong) NSMutableArray *netWorkStateArray;

/* 代理 */
@property (nonatomic, weak, nullable) id <HYJADCrashCollectManagerDelegate> delegate;

//固定获得单例对象方法
+ (instancetype)shared;

//注册所有的防Crash方法
- (void)registerADCrash;

/**
 提交崩溃日志

 @param log 日志内容
 */
- (void)commitCrashLog:(NSString *)log;

@end

NS_ASSUME_NONNULL_END
