//
//  HYJADCrashLoginVM.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/14.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HYJADCrashLoginModel;

typedef NS_ENUM(NSInteger, netWorkType)
{
    netWorkType_Login = 1,
};

@protocol HYJADCrashLoginDelegate <NSObject>

/** 设置登录按钮状态的回调 */
- (void)setLoginButtonUserInteractionEnabledStatus:(BOOL)userInteractionEnabled;

/** 登录失败的回调 */
- (void)loginFail:(NSError *)fail;

/** 登录成功的回调 */
- (void)loginSuccess:(id __nullable)response;

/** 网络请求的回调 */
- (void)netWorkResponse:(id __nullable)response type:(netWorkType)type error:(NSError * __nullable)error;

@end

@interface HYJADCrashLoginVM : NSObject

/** 登录数据 */
@property (nonatomic, strong) HYJADCrashLoginModel *loginModel;

/** 代理 */
@property (nonatomic, weak) id<HYJADCrashLoginDelegate> delegate;

/// 检查登录状态
- (void)checkLoginStatus;

/// 登录
- (void)login;

//防止添加通知警告
- (void)accountTextFieldChange:(UITextField *)textField;
- (void)passwordTextFieldChange:(UITextField *)textField;

@end

NS_ASSUME_NONNULL_END
