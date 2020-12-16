# HYJADCrash
Automatic Defense Crash 自动防止Crash工具 2020年


# Installation with CocoaPods
To integrate HYJADCrash into your Xcode project using CocoaPods, specify it in your Podfile:
```
pod 'HYJADCrash', '~> 0.0.2'
```

# Usage

register HYJADCrash（注册HJYADCrash）
```
[[HYJADCrashCollectManager shared] registerADCrash];
```
set HYJADCrash delegate ,Listen to crash log (设置代理,并通过代理事件监听崩溃日志)
```
[HYJADCrashCollectManager shared].delegate = self;

//String type log (字符串类型的日志)
- (void)observerCrashLog:(NSString *_Nonnull)crashLog
{
    NSLog(@"crashLog:%@ \n\n",crashLog);
}

//Dictionary type log（字典类型的日志）
- (void)observerCrashLogDictionary:(NSDictionary *_Nonnull)crashLogDictionary
{
    NSLog(@"crashLogDictionary:%@ \n\n",crashLogDictionary);
}
```
