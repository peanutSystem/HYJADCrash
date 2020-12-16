//
//  HYJADCrashReachability.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashReachability.h"

#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreFoundation/CoreFoundation.h>


#pragma mark IPv6 Support
//Reachability fully support IPv6.  For full details, see ReadMe.md.


NSString *kHYJADCrashReachabilityChangedNotification = @"kNetworkHYJADCrashReachabilityChangedNotification";


#pragma mark - Supporting functions

#define kShouldPrintReachabilityFlags 1
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] doubleValue]
static void PrintReachabilityFlags(SCNetworkReachabilityFlags flags, const char* comment)
{
#if kShouldPrintReachabilityFlags

//    NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
//          (flags & kSCNetworkReachabilityFlagsIsWWAN)                ? 'W' : '-',
//          (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
//
//          (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
//          (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
//          (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
//          (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
//          (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
//          (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
//          (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-',
//          comment
//          );
#endif
}


static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target, flags)
    NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
    NSCAssert([(__bridge NSObject*) info isKindOfClass: [HYJADCrashReachability class]], @"info was wrong class in ReachabilityCallback");

    HYJADCrashReachability* noteObject = (__bridge HYJADCrashReachability *)info;
    // Post a notification to notify the client that the network reachability changed.
    [[NSNotificationCenter defaultCenter] postNotificationName: kHYJADCrashReachabilityChangedNotification object: noteObject];
}


#pragma mark - Reachability implementation

@implementation HYJADCrashReachability
{
    SCNetworkReachabilityRef _reachabilityRef;
}

+ (instancetype)reachabilityWithHostName:(NSString *)hostName
{
    HYJADCrashReachability* returnValue = NULL;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
    if (reachability != NULL)
    {
        returnValue= [[self alloc] init];
        if (returnValue != NULL)
        {
            returnValue->_reachabilityRef = reachability;
        }
        else {
            CFRelease(reachability);
        }
    }
    return returnValue;
}


+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, hostAddress);

    HYJADCrashReachability* returnValue = NULL;

    if (reachability != NULL)
    {
        returnValue = [[self alloc] init];
        if (returnValue != NULL)
        {
            returnValue->_reachabilityRef = reachability;
        }
        else {
            CFRelease(reachability);
        }
    }
    return returnValue;
}


+ (instancetype)reachabilityForInternetConnection
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    return [self reachabilityWithAddress: (const struct sockaddr *) &zeroAddress];
}

#pragma mark reachabilityForLocalWiFi
//reachabilityForLocalWiFi has been removed from the sample.  See ReadMe.md for more information.
//+ (instancetype)reachabilityForLocalWiFi



#pragma mark - Start and stop notifier

- (BOOL)startNotifier
{
    BOOL returnValue = NO;
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};

    if (SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context))
    {
        if (SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
        {
            returnValue = YES;
        }
    }
    
    return returnValue;
}


- (void)stopNotifier
{
    if (_reachabilityRef != NULL)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}


- (void)dealloc
{
    [self stopNotifier];
    if (_reachabilityRef != NULL)
    {
        CFRelease(_reachabilityRef);
    }
}


#pragma mark - Network Flag Handling

- (HYJADCrashNetworkStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    PrintReachabilityFlags(flags, "networkStatusForFlags");
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        // The target host is not reachable.
        return HYJADCrashNotReachable;
    }

    HYJADCrashNetworkStatus returnValue = HYJADCrashNotReachable;

    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        /*
         If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
         */
        returnValue = HYJADCrashReachableViaWiFi;
    }

    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        /*
         ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
         */

        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            /*
             ... and no [user] intervention is needed...
             */
            returnValue = HYJADCrashReachableViaWiFi;
        }
    }

    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        /*
         ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
         */
        returnValue = HYJADCrashReachableViaWWAN;
        
        if (IOS_VERSION >= 7.0) {
            CTTelephonyNetworkInfo *phonyNetwork = [[CTTelephonyNetworkInfo alloc] init];
            //目前还没有单独的5G判断标识
            NSString *currentStr = phonyNetwork.currentRadioAccessTechnology;
            if (currentStr) {
                if ([currentStr isEqualToString:CTRadioAccessTechnologyLTE]) {
                    returnValue = HYJADCrashkRaeachableVia4G;
                }else if ([currentStr isEqualToString:CTRadioAccessTechnologyGPRS]|| [currentStr isEqualToString:CTRadioAccessTechnologyEdge]){
                    returnValue = HYJADCrashkReachableVia2G;
                }else{
                    returnValue = HYJADCrashkReachableVia3G;
                }
            }
        }
        if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection) {
            if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired) {
                returnValue = HYJADCrashkReachableVia2G;
            }
            returnValue = HYJADCrashkReachableVia3G;
        }
        
    }
    
    return returnValue;
}


- (BOOL)connectionRequired
{
    NSAssert(_reachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
    SCNetworkReachabilityFlags flags;

    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
    {
        return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
    }

    return NO;
}


- (HYJADCrashNetworkStatus)currentReachabilityStatus
{
    NSAssert(_reachabilityRef != NULL, @"currentNetworkStatus called with NULL SCNetworkReachabilityRef");
    HYJADCrashNetworkStatus returnValue = HYJADCrashNotReachable;
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
    {
        returnValue = [self networkStatusForFlags:flags];
    }
    
    return returnValue;
}

//获取当前网络状态
- (NSString *)currentNetWorkStatusString
{
    NSString *status = @"unknown";
    switch ([self currentReachabilityStatus]) {
            
        case HYJADCrashReachableViaWiFi:
            status = @"wifi";
            break;
        case HYJADCrashkRaeachableVia4G:
            status = @"4G";
            break;
        case HYJADCrashkReachableVia2G:
            status = @"2G";
            break;
        case HYJADCrashkReachableVia3G:
            status = @"3G";
            break;
        case HYJADCrashNotReachable:
            status = @"notReachable";
            break;
        default:
            status = @"unknown";
            break;
            
    }
    return status;
}



@end
