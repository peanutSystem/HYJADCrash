//
//  HYJADCrashReachability.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>


typedef enum : NSInteger {
    HYJADCrashNotReachable = 0,
    HYJADCrashReachableViaWiFi,
    HYJADCrashReachableViaWWAN,
    HYJADCrashkRaeachableVia4G,
    HYJADCrashkReachableVia2G,
    HYJADCrashkReachableVia3G
} HYJADCrashNetworkStatus;

#pragma mark IPv6 Support
//Reachability fully support IPv6.  For full details, see ReadMe.md.


extern NSString *kHYJADCrashReachabilityChangedNotification;

NS_ASSUME_NONNULL_BEGIN

@interface HYJADCrashReachability : NSObject


/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;


#pragma mark reachabilityForLocalWiFi
//reachabilityForLocalWiFi has been removed from the sample.  See ReadMe.md for more information.
//+ (instancetype)reachabilityForLocalWiFi;

/*!
 * Start listening for reachability notifications on the current run loop.
 */
- (BOOL)startNotifier;
- (void)stopNotifier;

- (HYJADCrashNetworkStatus)currentReachabilityStatus;

//获取当前网络状态
- (NSString *)currentNetWorkStatusString;

/*!
 * WWAN may be available, but not active until a connection has been established. WiFi may require a connection for VPN on Demand.
 */
- (BOOL)connectionRequired;

@end

NS_ASSUME_NONNULL_END
