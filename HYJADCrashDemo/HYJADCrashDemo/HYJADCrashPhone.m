//
//  HYJADCrashPhone.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashPhone.h"
#import "HYJADCrashReachability.h"
#import "NSMutableArray+HYJADCrash.h"

#include <execinfo.h>
#include <sys/sysctl.h>//获取手机型号
#import <CoreTelephony/CTTelephonyNetworkInfo.h>//获取网络运营商信息
#import <CoreTelephony/CTCarrier.h>//获取网络运营商信息
#import <net/if.h>//获取ip
#import <ifaddrs.h>//获取ip
#import <arpa/inet.h>//获取ip
#include <mach/mach_host.h>//获取可用内存
#include <mach/task.h>//获取已用内存大小
#import <sys/mount.h>//磁盘容量
#import <CoreMotion/CoreMotion.h>

#define HYJADCrash_IOS_CELLULAR    @"pdp_ip0"
#define HYJADCrash_IOS_WIFI        @"en0"
#define HYJADCrash_IOS_VPN         @"utun0"
#define HYJADCrash_IP_ADDR_IPv4    @"ipv4"
#define HYJADCrash_IP_ADDR_IPv6    @"ipv6"


@interface HYJADCrashPhone ()
{
    
}

@end


@implementation HYJADCrashPhone

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMotionManager];
        [self initReachability];
    }
    return self;
}

- (void)initMotionManager
{
    if (!self.motionManager) {
        self.motionManager = [[CMMotionManager alloc] init];
        if (self.motionManager.accelerometerAvailable) {
            //加速计
            [self.motionManager startAccelerometerUpdates];
        }
        if (self.motionManager.gyroAvailable) {
            //陀螺仪
            [self.motionManager startGyroUpdates];
        }
        if (self.motionManager.magnetometerAvailable) {
            //磁场
            [self.motionManager startMagnetometerUpdates];
        }
    }
    
}

- (void)initReachability
{
    if (!self.reachability)
    {
        self.reachability   = [HYJADCrashReachability reachabilityWithHostName:@"www.apple.com"];
        [self.reachability startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkChanged:)
                                                     name:kHYJADCrashReachabilityChangedNotification
                                                   object:nil];
    }
}

#pragma mark - 网络监听的回调
- (void)networkChanged:(NSNotification *)notification
{
    HYJADCrashReachability *reachability = (HYJADCrashReachability *)notification.object;
    [self addNetWorkStatusChangeInfo:[reachability currentNetWorkStatusString]];
}

#pragma mark - ---------------------------------------------  Private Method  ---------------------------------------------
- (void)addNetWorkStatusChangeInfo:(NSString *)status
{
    if (self.netWorkStateInfoArray.count > 50) {//淘汰老数据
        [self.netWorkStateInfoArray removeObjectsInRange:NSMakeRange(0, self.netWorkStateInfoArray.count - 50)];
    }
    [self.netWorkStateInfoArray addObjectSafe:[self createNetWorkInfo:status]];
}

- (NSMutableDictionary *)createNetWorkInfo:(NSString *)status
{
    //时间戳
    NSDate *date = [NSDate date];
    NSTimeInterval timerInterval = [date timeIntervalSince1970];
    long long ts = timerInterval * 1000;
    NSMutableDictionary *netWorkInfo = [NSMutableDictionary new];
    [netWorkInfo setValue:[@(ts) stringValue] forKey:@"ts"];
    [netWorkInfo setValue:status forKey:@"netState"];
    return netWorkInfo;
}

#pragma mark - iPhoneInfo

- (NSString *)getPhoneInfoString
{
    NSString *iPhoneInfo = [[NSString alloc] initWithFormat:@"手机信息:\n手机屏幕大小:%@\n 手机方向:%@\n手机型号:%@\n手机名称:%@\n手机系统版本:%@\n手机电池状态:%@  手机电量:%@\n手机网络状态：%@  网络运营商:%@\n手机IP:%@\n手机内存:%@  手机可用内存：%@  手机已使用内存：%@\n 手机总容量:%@ 手机可用容量:%@"
                            ,[self getPhoneScreenSize]
                            ,[self getDeviceOrientation]
                            ,[self platform]
                            ,[self getPhoneName]
                            ,[self getPhoneSystemVersion]
                            ,[self getiPhoneBatteryState]
                            ,[self getPhoneBattery]
                            ,[self getNetWorkStates]
                            ,[self getCarrierName]
                            ,[self getIPAddress:YES]
                            ,[self fileSizeToString:[NSProcessInfo processInfo].physicalMemory]
                            ,[self fileSizeToString:[self getAvailableMemorySize]]
                            ,[self fileSizeToString:[self getUsedMemory]]
                            ,[self fileSizeToString:[self getTotalDiskSize]]
                            ,[self fileSizeToString:[self getAvailableDiskSize]]];
    return iPhoneInfo;
}

- (NSMutableDictionary *)getPhoneInfo
{
    NSMutableDictionary *iPhoneInfoDic = [NSMutableDictionary new];
    [iPhoneInfoDic setValue:[self getPhoneScreenSize] forKey:@"iPhoneScreenSize"];//屏幕大小
    [iPhoneInfoDic setValue:[self platform] forKey:@"iPhoneType"];//手机型号
    [iPhoneInfoDic setValue:[self getPhoneName] forKey:@"iPhoneName"];//手机名称
    [iPhoneInfoDic setValue:[self getPhoneSystemVersion] forKey:@"iPhoneSystemVersion"];//系统版本
    [iPhoneInfoDic setValue:[self getiPhoneBatteryState] forKey:@"iPhoneBatteryState"];//电池状态
    [iPhoneInfoDic setValue:[self getPhoneBattery] forKey:@"iPhoneBattery"];//电池电量
    [iPhoneInfoDic setValue:[self getNetWorkStates] forKey:@"iPhoneNetWorkState"];//网络状态
    [iPhoneInfoDic setValue:[self getCarrierName] forKey:@"iPhoneNetWorkCarrierName"];//网络运营商
    [iPhoneInfoDic setValue:[self getIPAddress:YES] forKey:@"iPhoneIP"];//IP
    [iPhoneInfoDic setValue:[self fileSizeToString:[NSProcessInfo processInfo].physicalMemory] forKey:@"iPhonePhysicalMemory"];//手机内存
    [iPhoneInfoDic setValue:[self fileSizeToString:[self getAvailableMemorySize]] forKey:@"iPhoneAvailableMemorySize"];//手机可用内存
    [iPhoneInfoDic setValue:[self fileSizeToString:[self getUsedMemory]] forKey:@"iPhoneUsedMemory"];//手机已用内存
    [iPhoneInfoDic setValue:[self fileSizeToString:[self getTotalDiskSize]] forKey:@"iPhoneTotalDiskSize"];//手机容量
    [iPhoneInfoDic setValue:[self fileSizeToString:[self getAvailableDiskSize]] forKey:@"iPhoneAvailableDiskSize"];//手机可用容量
    return iPhoneInfoDic;
}


- (NSString *)getPhoneBattery
{
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel];
    NSString *iPhoneBattery = [[NSString alloc] initWithFormat:@"%0.0f%%",batteryLevel*100];
    return iPhoneBattery;
}

- (NSString *)getPhoneName
{
    NSString *iPhoneName = [[UIDevice currentDevice] name];
    return iPhoneName;
}

- (NSString *)getPhoneSystemVersion
{
    NSString *iPhoneSystemVersion = [[UIDevice currentDevice] systemVersion];
    return iPhoneSystemVersion;
}

- (NSString *)getPhoneScreenSize
{
    CGSize iPhoneSize = [UIScreen mainScreen].bounds.size;
    NSString *iPhoneScreenSize = [[NSString alloc] initWithFormat:@"宽:%f,高:%f",iPhoneSize.width,iPhoneSize.height];
    return iPhoneScreenSize;
}

/**
 获取设备方向

 @return 设备方向字符串
 */
- (NSString *)getDeviceOrientation
{
    
    if (self.motionManager.accelerometerAvailable) {
        //如果可以获取加速计信息
        CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
        //NSLog(@"加速计:\n X-->%f,  Y-->%f,  Z-->%f ",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z);
        return [[NSString alloc] initWithFormat:@"加速计:x-->%f,  y-->%f,  z-->%f ",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z];
    }
    if (self.motionManager.gyroAvailable) {
        //如果可以获取陀螺仪信息
        CMGyroData *gyroData = self.motionManager.gyroData;
        //NSLog(@"陀螺仪:\n X-->%f,  Y-->%f,  Z-->%f ",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z);
        return [[NSString alloc] initWithFormat:@"陀螺仪:x-->%f,  y-->%f,  z-->%f ",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z];
    }
    if (self.motionManager.magnetometerAvailable) {
        //如果可以获取磁场数据
        CMMagnetometerData *magnetometerData = self.motionManager.magnetometerData;
        //NSLog(@"磁场数据:\n X-->%f,  Y-->%f,  Z-->%f ",magnetometerData.magneticField.x,magnetometerData.magneticField.y,magnetometerData.magneticField.z);
//        NSLog(@"---------------------------------------");
        return [[NSString alloc] initWithFormat:@"磁场数据:x-->%f,  y-->%f,  z-->%f ",magnetometerData.magneticField.x,magnetometerData.magneticField.y,magnetometerData.magneticField.z];
    }
    return @"未获取到该设备方向信息";
}

/**
 获取官方给出的设备的型号信息
 
 @return 设备名称
 */
- (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

/**
 获取手机电池状态

 @return 电池状态字符串
 */
- (NSString *)getiPhoneBatteryState
{
    UIDeviceBatteryState phoneBatteryState = [[UIDevice currentDevice] batteryState];
    NSString *state;
    switch (phoneBatteryState) {
        case UIDeviceBatteryStateUnknown:
            state = @"未知电池状态";
            break;
        case UIDeviceBatteryStateUnplugged:
            state = @"未充电，使用电池";
            break;
        case UIDeviceBatteryStateCharging:
            state = @"充电中，并且电量小于 100%";
            break;
        case UIDeviceBatteryStateFull:
            state = @"充电中, 电量已达 100%";
            break;
        default:
            state = @"未知电池状态";
            break;
    }
    return state;
}

/**
 !@biref  获取当前设备网络状态
 @return  NSString类型的状态值（无网络,2G,3G,4G,WIFT）
 */
- (NSString *)getNetWorkStates
{
    HYJADCrashReachability *reachability   = [HYJADCrashReachability reachabilityWithHostName:@"www.apple.com"];
    
    HYJADCrashNetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    NSString *net = @"wifi";
    
    switch (internetStatus) {
            
        case HYJADCrashReachableViaWiFi:
            
            net = @"wifi";
            
            break;
            
        case HYJADCrashkRaeachableVia4G:
            
            net = @"4G";
            
            break;
            
        case HYJADCrashkReachableVia2G:
            
            net = @"2G";
            
            break;
            
        case HYJADCrashkReachableVia3G:
            
            net = @"3G";
            
            break;
            
        case HYJADCrashNotReachable:
            
            net = @"notReachable";
            
            break;
        default:
            net = @"unknown";
            break;
            
    }
    
    return net;
}

/**
 !@biref  获取网络运营商
 @return NSString类型的运营商信息
 */
- (NSString *)getCarrierName
{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry=[carrier carrierName];
    return currentCountry;
}

/**
 !@biref  获取IP地址，YES表示获取IPv4,NO表示获取IPv6
 @return  NSString类型的ip地址
 */
- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ HYJADCrash_IOS_VPN @"/" HYJADCrash_IP_ADDR_IPv4, HYJADCrash_IOS_VPN @"/" HYJADCrash_IP_ADDR_IPv6, HYJADCrash_IOS_WIFI @"/" HYJADCrash_IP_ADDR_IPv4, HYJADCrash_IOS_WIFI @"/" HYJADCrash_IP_ADDR_IPv6, HYJADCrash_IOS_CELLULAR @"/" HYJADCrash_IP_ADDR_IPv4, HYJADCrash_IOS_CELLULAR @"/" HYJADCrash_IP_ADDR_IPv6 ] :
    @[ HYJADCrash_IOS_VPN @"/" HYJADCrash_IP_ADDR_IPv6, HYJADCrash_IOS_VPN @"/" HYJADCrash_IP_ADDR_IPv4, HYJADCrash_IOS_WIFI @"/" HYJADCrash_IP_ADDR_IPv6, HYJADCrash_IOS_WIFI @"/" HYJADCrash_IP_ADDR_IPv4, HYJADCrash_IOS_CELLULAR @"/" HYJADCrash_IP_ADDR_IPv6, HYJADCrash_IOS_CELLULAR @"/" HYJADCrash_IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"1.1.1.1";
}


/// 获取手机IP地址
- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = HYJADCrash_IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = HYJADCrash_IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [[NSString alloc] initWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

/**
 获取当前可用内存

 @return 当前可用内存大小
 */
- (long long)getAvailableMemorySize
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
}

/**
 获取已使用内存大小

 @return 已使用内存大小
 */
- (double)getUsedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size;
}

/**
 获取磁盘容量

 @return 磁盘容量
 */
- (long long)getTotalDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return freeSpace;
}

/**
 获取可用磁盘容量

 @return 可用磁盘容量
 */
- (long long)getAvailableDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace;
}

/**
 容量大小转换

 @param fileSize 需要转换的大小
 @returnf容量大小字符串
 */
- (NSString *)fileSizeToString:(unsigned long long)fileSize
{
    //NSInteger KB = 1024;//计算机是按照1024来计算的而一般媒体设备计量是按照1000
    NSInteger KB = 1000;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (fileSize < 10)  {
        return @"0 B";
    }else if (fileSize < KB)    {
        return @"< 1 KB";
    }else if (fileSize < MB)    {
        return [[NSString alloc] initWithFormat:@"%.1f KB",((CGFloat)fileSize)/KB];
    }else if (fileSize < GB)    {
        return [[NSString alloc] initWithFormat:@"%.1f MB",((CGFloat)fileSize)/MB];
    }else   {
        return [[NSString alloc] initWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
    }
}


#pragma mark - LazyLoad
- (NSMutableArray *)netWorkStateInfoArray
{
    if (!_netWorkStateInfoArray) {
        _netWorkStateInfoArray = [NSMutableArray new];
    }
    return _netWorkStateInfoArray;
}


@end
