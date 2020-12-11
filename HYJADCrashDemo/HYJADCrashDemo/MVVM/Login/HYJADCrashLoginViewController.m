//
//  HYJADCrashLoginViewController.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/11.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashLoginViewController.h"

#import "HYJADCrashLoginView.h"


@interface HYJADCrashLoginViewController () <UITextViewDelegate>
{
    
}

/** 登录界面 */
@property (nonatomic, strong) HYJADCrashLoginView *loginView;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    /** loginView */
    self.loginView = [[HYJADCrashLoginView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.loginView];
    [self.loginView.loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.forgetPasswordButton addTarget:self action:@selector(forgetPasswordButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.loginDelegateButton addTarget:self action:@selector(loginDelegateButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.loginView.loginDelegateTextView.delegate = self;
}


#pragma mark - ---------------------------------------------  Private Method  ---------------------------------------------
- (void)checkLoginButtonStatus
{
    NSString *accountText = [self.loginView.accountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordText = [self.loginView.accountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (accountText.length > 0 && passwordText.length > 0 && self.loginView.loginDelegateButton.selected) {
        self.loginView.loginButton.userInteractionEnabled = YES;
        self.loginView.loginButton.backgroundColor = RGBA(80, 130, 230, 1);
    } else {
        self.loginView.loginButton.userInteractionEnabled = NO;
        self.loginView.loginButton.backgroundColor = RGBA(204, 204, 204, 1);
    }
}

- (void)simulateLoginBlock:(void(^)(BOOL isSccuess))block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        if (block)
        {
            int res = arc4random()%2;
            block(res == 1 ? YES : NO);
        }
    });
}


#pragma mark - UITextFieldDelegate
- (void)textFieldChange:(NSNotification *)notification
{
    UITextField *textField  = (UITextField *)notification.object;
    
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
        [self checkLoginButtonStatus];
    }
    
}
#pragma mark - Action
- (void)loginButtonAction
{

    [self simulateLoginBlock:^(BOOL isSccuess) {
        
    }];
}

- (void)forgetPasswordButtonAction
{
    NSLog(@"忘记密码?");
}

- (void)loginDelegateButtonAction
{
    if (self.loginView.loginDelegateButton.selected) {
        self.loginView.loginDelegateButton.selected = NO;
    } else {
        self.loginView.loginDelegateButton.selected = YES;
    }
    [self checkLoginButtonStatus];
}

#pragma mark - UITextViewDelegate
//ios10以上方法
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    if ([URL.absoluteString isEqualToString:@"privacy"]) {
        NSLog(@"隐私政策");
        return NO;
    }else if ([URL.absoluteString isEqualToString:@"protocol"])
    {
        NSLog(@"用户协议");
        return NO;
    }
    return YES;
}

@end
