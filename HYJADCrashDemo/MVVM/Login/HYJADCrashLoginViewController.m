//
//  HYJADCrashLoginViewController.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/11.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashLoginViewController.h"

#import "HYJADCrashLoginView.h"
#import "HYJADCrashLoginVM.h"

@interface HYJADCrashLoginViewController () <UITextViewDelegate,HYJADCrashLoginDelegate>
{
    
}

/** 登录界面 */
@property (nonatomic, strong) HYJADCrashLoginView *loginView;

/** 登录界面VM */
@property (nonatomic, strong) HYJADCrashLoginVM *loginVM;

@end

@implementation HYJADCrashLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initView];
    });
    
}

- (void)dealloc
{
    NSLog(@"HYJADCrashLoginViewController------dealloc");
}

- (void)initView
{
    
    /** loginView */
    self.loginView = [[HYJADCrashLoginView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.loginView];
    [self.loginView.loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.forgetPasswordButton addTarget:self action:@selector(forgetPasswordButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.loginDelegateButton addTarget:self action:@selector(loginDelegateButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.loginView.loginDelegateTextView.delegate = self;
    
    self.loginVM = [HYJADCrashLoginVM new];
    self.loginVM.delegate = self;
//    [[NSNotificationCenter defaultCenter] addObserver:self.loginVM selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [self.loginView.accountTextField addTarget:self.loginVM action:@selector(accountTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self.loginView.passwordTextField addTarget:self.loginVM action:@selector(passwordTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
}


#pragma mark - HYJADCrashLoginDelegate

/** 设置登录按钮状态的回调 */
- (void)setLoginButtonUserInteractionEnabledStatus:(BOOL)userInteractionEnabled
{
    [self.loginView setLoginButtonUserInteractionEnabled:userInteractionEnabled];
}

/** 登录失败的回调 */
- (void)loginFail:(NSError *)error
{
    NSLog(@"登录失败:%@",error.localizedFailureReason);
}

/** 登录成功的回调 */
- (void)loginSuccess
{
    NSLog(@"登录成功");
}

- (void)netWorkResponse:(id)response type:(netWorkType)type error:(NSError *)error
{
    if (type == netWorkType_Login) {
        if (error) {
            NSLog(@"登录失败:%@",error.localizedFailureReason);
        } else {
            NSLog(@"登录成功");
        }
    }
}

#pragma mark - ---------------------------------------------  Private Method  ---------------------------------------------


#pragma mark - Action
- (void)loginButtonAction
{

    [self.loginVM login];
}

- (void)forgetPasswordButtonAction
{
    NSLog(@"忘记密码?");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginDelegateButtonAction
{
    if (self.loginView.loginDelegateButton.selected) {
        self.loginView.loginDelegateButton.selected = NO;
    } else {
        self.loginView.loginDelegateButton.selected = YES;
    }
    [self.loginVM checkLoginStatus];
}

#pragma mark - UITextViewDelegate
//ios10以上方法
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    if ([URL.absoluteString isEqualToString:@"privacy"])
    {
        NSLog(@"隐私政策");
        return NO;
    } else if ([URL.absoluteString isEqualToString:@"protocol"])
    {
        NSLog(@"用户协议");
        return NO;
    }
    return YES;
}

@end
