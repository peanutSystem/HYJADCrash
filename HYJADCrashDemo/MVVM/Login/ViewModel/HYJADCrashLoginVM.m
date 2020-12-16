//
//  HYJADCrashLoginVM.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/14.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashLoginVM.h"
#import "HYJADCrashLoginModel.h"
#import "HYJADCrashUserInfo.h"

@implementation HYJADCrashLoginVM

#pragma mark - ---------------------------------------------  Public Method  ---------------------------------------------


/// 登录
- (void)login
{
    NSString *accountText = [self.loginModel.account stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (accountText.length <= 0) {
        
//        if (self.delegate && [self.delegate respondsToSelector:@selector(loginFail:)]) {
//            [self.delegate loginFail:[NSError errorWithDomain:@"LoginErrorDomain" code:1002 userInfo:@{NSLocalizedDescriptionKey:@"账号不能为空", NSLocalizedFailureReasonErrorKey:@"账号不能为空"}]];
//        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(netWorkResponse:type:error:)]) {
            [self.delegate netWorkResponse:nil type:netWorkType_Login error:[NSError errorWithDomain:@"LoginErrorDomain" code:1002 userInfo:@{NSLocalizedDescriptionKey:@"账号不能为空", NSLocalizedFailureReasonErrorKey:@"账号不能为空"}]];
        }
        return;
    }
    
    
    NSString *passwordText = [self.loginModel.password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (passwordText.length <= 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(netWorkResponse:type:error:)]) {
            
            //        if (self.delegate && [self.delegate respondsToSelector:@selector(loginFail:)]) {
            //            [self.delegate loginFail:[NSError errorWithDomain:@"LoginErrorDomain" code:1003 userInfo:@{NSLocalizedDescriptionKey:@"密码不能为空", NSLocalizedFailureReasonErrorKey:@"密码不能为空"}]];
            //        }
            
            [self.delegate netWorkResponse:nil type:netWorkType_Login error:[NSError errorWithDomain:@"LoginErrorDomain" code:1003 userInfo:@{NSLocalizedDescriptionKey:@"密码不能为空", NSLocalizedFailureReasonErrorKey:@"密码不能为空"}]];
        }
        return;
    }
    
    [self simulateLoginBlock:^(BOOL isSccuess) {
        if (isSccuess) {
            
//            if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccess:)]) {
//                [self.delegate loginSuccess:[HYJADCrashUserInfo share]];
//            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(netWorkResponse:type:error:)]) {
                [self.delegate netWorkResponse:[HYJADCrashUserInfo share] type:netWorkType_Login error:nil];
            }
        } else {
            
//            if (self.delegate && [self.delegate respondsToSelector:@selector(loginFail:)]) {
//                [self.delegate loginFail:[NSError errorWithDomain:@"LoginErrorDomain" code:1001 userInfo:@{NSLocalizedDescriptionKey:@"登录失败", NSLocalizedFailureReasonErrorKey:@"登录失败"}]];
//            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(netWorkResponse:type:error:)]) {
                [self.delegate netWorkResponse:nil type:netWorkType_Login error:[NSError errorWithDomain:@"LoginErrorDomain" code:1001 userInfo:@{NSLocalizedDescriptionKey:@"登录失败", NSLocalizedFailureReasonErrorKey:@"登录失败"}]];
            }
        }
    }];
}

- (void)checkLoginStatus
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setLoginButtonUserInteractionEnabledStatus:)]) {
        BOOL result = YES;
        NSString *accountText = [self.loginModel.account stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (accountText.length <= 0) {
            result = NO;
        } else {
            NSString *passwordText = [self.loginModel.password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (passwordText.length <= 0) {
                result = NO;
            }
        }
        
        [self.delegate setLoginButtonUserInteractionEnabledStatus:result];
    }
}

#pragma mark - ---------------------------------------------  Private Method  ---------------------------------------------
- (void)dealloc
{
    NSLog(@"HYJADCrashLoginVM------dealloc");
}

- (void)accountTextFieldChange:(UITextField *)textField
{
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 键盘输入模式
    BOOL hasPosition = NO;
    if ([lang isEqualToString:@"zh-Hans"] || [lang isEqualToString:@"zh-Hant"])
    {
        // 简体中文输入，包括简体拼音，简体五笔，简体手写(zh-Hans)
        // 繁体中文输入，包括繁体拼音，繁体五笔，繁体手写(zh-Hant)
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分（联想部分）
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (position)
        {// 有联想
            hasPosition = YES;
        }
    }
    
    if (!hasPosition) {
        [self setLoginAccount:text];
    }
    
}

- (void)passwordTextFieldChange:(UITextField *)textField
{
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 键盘输入模式
    BOOL hasPosition = NO;
    if ([lang isEqualToString:@"zh-Hans"] || [lang isEqualToString:@"zh-Hant"])
    {
        // 简体中文输入，包括简体拼音，简体五笔，简体手写(zh-Hans)
        // 繁体中文输入，包括繁体拼音，繁体五笔，繁体手写(zh-Hant)
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分（联想部分）
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (position)
        {// 有联想
            hasPosition = YES;
        }
    }
    
    if (!hasPosition) {
        [self setLoginPassword:text];
    }
    
}

- (void)setLoginPassword:(NSString *)password
{
    NSLog(@"新输入的密码:%@",password);
    self.loginModel.password = password;
    [self checkLoginStatus];
}

- (void)setLoginAccount:(NSString *)account
{
    NSLog(@"新输入的账号:%@",account);
    self.loginModel.account = account;
    [self checkLoginStatus];
}


- (void)simulateLoginBlock:(void(^)(BOOL isSccuess))block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        if (block)
        {
            int res = arc4random()%2;
            [HYJADCrashUserInfo share];
            block(res == 1 ? YES : NO);
        }
    });
}

#pragma mark - observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSString *newText = [change valueForKey:@"new"];
    NSString *text = [newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (context == @"password") {
        [self setLoginAccount:text];
    } else if (context == @"account") {
        [self setLoginPassword:text];
    }
}


#pragma mark - LazyLoad
- (HYJADCrashLoginModel *)loginModel
{
    if (!_loginModel) {
        _loginModel = [HYJADCrashLoginModel new];
    }
    return _loginModel;
}

@end
