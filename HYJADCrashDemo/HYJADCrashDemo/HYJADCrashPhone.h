//
//  HYJADCrashPhone.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//
//          手机信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CMMotionManager,HYJADCrashReachability;

@interface HYJADCrashPhone : NSObject

/* 加速计、陀螺仪、磁场管理者 */
@property (nonatomic, strong) CMMotionManager *motionManager;

/* 网络监听对象 */
@property (nonatomic, strong) HYJADCrashReachability *reachability;

/* 网络状态切换记录表 */
@property (nonatomic, strong) NSMutableArray *netWorkStateInfoArray;



#pragma mark - ---------------------------------------------  Public Method  ---------------------------------------------

/**
 *@method 获取手机全面信息
 *
 *@return 手机信息字符串
 */
- (NSString *)getPhoneInfoString;

/**
 * @method 获取手机全面信息
 *
 * @return 字典
 *  iPhoneScreenSize：屏幕大小
    iPhoneType：手机型号
    iPhoneName：手机名称
    iPhoneSystemVersion：系统版本
    iPhoneBatteryState：//电池状态
    iPhoneBattery：电池电量
    iPhoneNetWorkState：网络状态
    iPhoneNetWorkCarrierName：网络运营商
    iPhoneIP：IP
    iPhonePhysicalMemory：手机内存
    iPhoneAvailableMemorySize：手机可用内存
    iPhoneUsedMemory：手机已用内存
    iPhoneTotalDiskSize：手机容量
    iPhoneAvailableDiskSize：手机可用容量
 *
 */
- (NSMutableDictionary *)getPhoneInfo;

//获取手机电池电量
- (NSString *)getPhoneBattery;

//获取设备名称
- (NSString *)getPhoneName;

//获取手机系统版本号
- (NSString *)getPhoneSystemVersion;

//获取屏幕size
- (NSString *)getPhoneScreenSize;

/**
 获取设备方向

 @return 设备方向字符串
 */
- (NSString *)getDeviceOrientation;

/**
 获取官方给出的设备的型号信息
 
 @return 设备名称
 */
- (NSString *)platform;

/**
 获取手机电池状态

 @return 电池状态字符串
 */
- (NSString *)getiPhoneBatteryState;

/**
 !@biref  获取当前设备网络状态
 @return  NSString类型的状态值（无网络,2G,3G,4G,WIFT）
 */
- (NSString *)getNetWorkStates;

/**
 !@biref  获取网络运营商
 @return NSString类型的运营商信息
 */
- (NSString *)getCarrierName;

/**
 !@biref  获取IP地址，YES表示获取IPv4,NO表示获取IPv6
 @return  NSString类型的ip地址
 */
- (NSString *)getIPAddress:(BOOL)preferIPv4;


/// 获取手机IP地址
- (NSDictionary *)getIPAddresses;

/**
 获取当前可用内存

 @return 当前可用内存大小
 */
- (long long)getAvailableMemorySize;

/**
 获取已使用内存大小

 @return 已使用内存大小
 */
- (double)getUsedMemory;

/**
 获取磁盘容量

 @return 磁盘容量
 */
- (long long)getTotalDiskSize;

/**
 获取可用磁盘容量

 @return 可用磁盘容量
 */
- (long long)getAvailableDiskSize;

/**
 容量大小转换

 @param fileSize 需要转换的大小
 @returnf容量大小字符串
 */
- (NSString *)fileSizeToString:(unsigned long long)fileSize;


@end

NS_ASSUME_NONNULL_END
