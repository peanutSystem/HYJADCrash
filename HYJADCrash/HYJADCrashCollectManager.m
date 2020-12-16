//
//  HYJADCrashCollectManager.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashCollectManager.h"

#import <mach-o/dyld.h>
#import <objc/runtime.h>
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


#import "NSObject+HYJADCrashPrevent.h"
#import "NSObject+HYJADCrashSwizzleHook.h"
#import "NSTimer+HYJADCrash.h"
#import "NSString+HYJADCrash.h"
#import "NSMutableString+HYJADCrash.h"

#import "HYJADCrashReachability.h"
#import "HYJADCrashPhone.h"


#define HYJADCrash_IOS_CELLULAR    @"pdp_ip0"
#define HYJADCrash_IOS_WIFI        @"en0"
#define HYJADCrash_IOS_VPN         @"utun0"
#define HYJADCrash_IP_ADDR_IPv4    @"ipv4"
#define HYJADCrash_IP_ADDR_IPv6    @"ipv6"

//异常捕获的接收方法
void HYJADCrashExceptionHandle(NSException *exception);
void HYJADCrashSignalExceptionHandler(int signal);

#pragma mark - 附加方法
/**
 获取加载地址
 从堆栈信息中，无法获取到加载地址，并且加载地址每次启动APP，都有所不同。所以先找到基地址，然后减去加载地址值，才是符号地址
 符号地址(symbol addr) = 堆栈地址(stack addr) - 加载地址(load addr)
 
 @return 加载地址
 */
uintptr_t get_load_address(void) {
    /*
     struct mach_header_64 {
     uint32_t    magic;           //魔数，用于快速确认该文件用于64位还是32位
     cpu_type_t  cputype;         //CPU类型，比如 arm
     cpu_subtype_t   cpusubtype;  //对应的具体类型，比如arm64、armv7
     uint32_t    filetype;        //文件类型，比如可执行文件、库文件、Dsym文件，demo中是2 MH_EXECUTE，代表可执行文件
     uint32_t    ncmds;           //加载命令条数
     uint32_t    sizeofcmds;      //所有加载命令的大小
     uint32_t    flags;           //标志位
     uint32_t    reserved;        //保留字段
     
     mach_header的32位和64位架构的头文件，没有太大的区别，只是64位多了一个保留字段罢了
     };*/
    const struct mach_header *exe_header = NULL;
    
    /*
     遍历所有模块的基地址
     _dyld_image_count:获取模块数量
     _dyld_get_image_header:根据传参获取指定位置的指针，返回一个指向由IMAGE索引图像的Mach标题的指针。如果IMAGE索引不在范围内，返回空值
     MH_EXECUTE:可执行文件
     */
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE) {
            exe_header = header;
            break;
        }
    }
    //返回加载地址
    return (uintptr_t)exe_header;
}

/**
 获得基地址
 
 @return 基地址
 */
uintptr_t get_slide_address(void) {
    uintptr_t vmaddr_slide = 0;
    
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE) {
            //_dyld_get_image_vmaddr_slide:根据传参获取模块中指定位置的基地址
            vmaddr_slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    //返回基地址
    return (uintptr_t)vmaddr_slide;
}



@interface HYJADCrashCollectManager()
{
    
}

/* 网络监听对象 */
@property (nonatomic, strong) HYJADCrashPhone *phone;

@end


@implementation HYJADCrashCollectManager

+ (instancetype)shared
{
    static HYJADCrashCollectManager *object;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [HYJADCrashCollectManager new];
        
    });
    return object;
}

#pragma mark - Register
/**
 注册所有的防Crash方法
 */
- (void)registerADCrash
{
    //注册类的替换
    [self registerClassSwizzle];
    //注册异常捕获
    [self registerlHYJADCrashHandler];
    //初始化phone
    [self initPhone];
}

- (void)registerClassSwizzle
{
    [NSString hyjadc_registerNSStringPreventCrash];
    [NSMutableString hyjadc_registerMutableStringPreventCrash];
    [NSObject hyjadc_registerUnrecognizedSelector];
    [NSTimer hyjadc_registerTimerPreventCrash];
}

- (void)initPhone
{
    self.phone = [[HYJADCrashPhone alloc] init];
}


- (void)commitCrashLog:(NSString *)log
{
    /* 获取崩溃前界面 */
//    UIGraphicsBeginImageContext([UIApplication sharedApplication].keyWindow.frame.size);
//    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    //写入相册
//    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    /* 获取崩溃前界面 */
    
    
    
    //获取堆栈信息
    NSArray* callStack = [NSThread callStackSymbols];
    NSString* callStackString = [[NSString alloc] initWithFormat:@"%@",callStack];
    //加载地址
    uintptr_t loadAddress =  get_load_address();
    //基地址
    uintptr_t slideAddress =  get_slide_address();
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(observerCrashLog:)]) {
        NSString* exceptionResult = [[NSString alloc] initWithFormat:@"%@\n加载地址:%ld\n基地址:%ld\n%@\n%@",[self.phone getPhoneInfoString],loadAddress,slideAddress,log,callStackString];
        //NSLog(@"崩溃日志:\n%@",exceptionResult);
        [self.delegate observerCrashLog:exceptionResult];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(observerCrashLogDictionary:)]) {
        NSMutableDictionary *dic = [self.phone getPhoneInfo];
        [dic setValue:[[NSString alloc] initWithFormat:@"%ld",loadAddress] forKey:@"loadAddress"];
        [dic setValue:[[NSString alloc] initWithFormat:@"%ld",slideAddress] forKey:@"slideAddress"];
        [dic setValue:log forKey:@"crashLog"];
        [dic setValue:callStackString forKey:@"callStackString"];
        [self.delegate observerCrashLogDictionary:dic];
    }
}


#pragma mark - 异常注册

/**
 注册异常捕获接口
 */
- (void)registerlHYJADCrashHandler
{
    NSSetUncaughtExceptionHandler(&HYJADCrashExceptionHandle);
    
    signal(SIGHUP, HYJADCrashSignalExceptionHandler);
    signal(SIGINT, HYJADCrashSignalExceptionHandler);
    signal(SIGQUIT, HYJADCrashSignalExceptionHandler);
    signal(SIGABRT, HYJADCrashSignalExceptionHandler);
    signal(SIGILL, HYJADCrashSignalExceptionHandler);
    signal(SIGSEGV, HYJADCrashSignalExceptionHandler);
    signal(SIGFPE, HYJADCrashSignalExceptionHandler);
    signal(SIGBUS, HYJADCrashSignalExceptionHandler);
    signal(SIGPIPE, HYJADCrashSignalExceptionHandler);
}






#pragma mark - Lazy Load
- (NSMutableArray *)netWorkStateArray
{
    if (!_netWorkStateArray) {
        _netWorkStateArray = [NSMutableArray new];
    }
    return _netWorkStateArray;
}

@end
#pragma mark - 系统Creash收集
void HYJADCrashExceptionHandle(NSException *exception)
{
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    
    NSString *exceptionInfo = [[NSString alloc] initWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    [[HYJADCrashCollectManager shared] commitCrashLog:exceptionInfo];
    
}
#pragma mark - signal收集
void HYJADCrashSignalExceptionHandler(int signal)
{
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendString:@"Stack:\n"];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i <frames; ++i) {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    [[HYJADCrashCollectManager shared] commitCrashLog:mstr];
}
