//
//  HYJADCrashLoginView.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/11.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashLoginView.h"

@interface HYJADCrashLoginView ()
{
    
}

@end

@implementation HYJADCrashLoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    /** logoImageView */
    self.logoImageView = [UIImageView new];
    [self addSubview:self.logoImageView];
    self.logoImageView.bounds = CGRectMake(0, 0, 150*Scale, 42*Scale);
    self.logoImageView.center = CGPointMake(self.center.x, 89*Scale);
    self.logoImageView.image = [UIImage imageNamed:@"logo"];
    
    /** accountTextField */
    self.accountTextField = [UITextField new];
    [self addSubview:self.accountTextField];
    self.accountTextField.bounds = CGRectMake(0, 0, ScreenW-76*Scale, 26*Scale);
    self.accountTextField.center = CGPointMake(self.center.x, self.logoImageView.center.y+69*Scale);
    self.accountTextField.textColor = RGBA(50, 50, 51, 1);
    NSAttributedString *accountAttributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号或账号" attributes:@{NSFontAttributeName:Font16,NSForegroundColorAttributeName:RGBA(138, 138, 138, 1)}];
    self.accountTextField.attributedPlaceholder = accountAttributedPlaceholder;
    self.accountTextField.font = Font16;
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *accountLeftView = [UIImageView new];
    accountLeftView.frame = CGRectMake(0, 0, 20*Scale, 20*Scale);
    accountLeftView.image = [UIImage imageNamed:@"account_icon"];
    self.accountTextField.leftView = accountLeftView;
    self.accountTextField.keyboardType = UIKeyboardTypeDefault;
    
    /** accountLineView */
    self.accountLineView = [UIView new];
    [self addSubview:self.accountLineView];
    self.accountLineView.frame = CGRectMake(CGRectGetMinX(self.accountTextField.frame), CGRectGetMaxY(self.accountTextField.frame)+5*Scale, ScreenW-76*Scale, 1);
    self.accountLineView.backgroundColor = RGBA(230, 230, 230, 1);
    
    /** passwordTextField */
    self.passwordTextField = [UITextField new];
    [self addSubview:self.passwordTextField];
    self.passwordTextField.bounds = CGRectMake(0, 0, ScreenW-76*Scale, 26*Scale);
    self.passwordTextField.center = CGPointMake(self.center.x, CGRectGetMaxY(self.accountLineView.frame)+37*Scale);
    self.passwordTextField.textColor = RGBA(50, 50, 51, 1);
    NSAttributedString *passswordAttributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSFontAttributeName:Font16,NSForegroundColorAttributeName:RGBA(138, 138, 138, 1)}];
    self.passwordTextField.attributedPlaceholder = passswordAttributedPlaceholder;
    self.passwordTextField.font = Font16;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *passwordLeftView = [UIImageView new];
    passwordLeftView.frame = CGRectMake(0, 0, 20*Scale, 20*Scale);
    passwordLeftView.image = [UIImage imageNamed:@"password_icon"];
    self.passwordTextField.leftView = passwordLeftView;
    
    /** passwordSecureButton */
    self.passwordSecureButton = [UIButton new];
    [self addSubview:self.passwordSecureButton];
    self.passwordSecureButton.frame = CGRectMake(0, 0, 20*Scale, 20*Scale);
    [self.passwordSecureButton setImage:[UIImage imageNamed:@"secure_icon"] forState:UIControlStateNormal];
    [self.passwordSecureButton setImage:[UIImage imageNamed:@"unsecure_icon"] forState:UIControlStateSelected];
    [self.passwordSecureButton addTarget:self action:@selector(passwordSecureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.rightView = self.passwordSecureButton;
    self.passwordTextField.keyboardType = UIKeyboardTypeDefault;
    self.passwordTextField.secureTextEntry = YES;
    
    /** passwordLineView */
    self.passwordLineView = [UIView new];
    [self addSubview:self.passwordLineView];
    self.passwordLineView.frame = CGRectMake(CGRectGetMinX(self.passwordTextField.frame), CGRectGetMaxY(self.passwordTextField.frame)+5*Scale, ScreenW-76*Scale, 1);
    self.passwordLineView.backgroundColor = RGBA(230, 230, 230, 1);
    
    /** forgetPasswordButton */
    self.forgetPasswordButton = [UIButton new];
    [self addSubview:self.forgetPasswordButton];
    self.forgetPasswordButton.frame = CGRectMake(CGRectGetMaxX(self.passwordLineView.frame)-84*Scale, CGRectGetMaxY(self.passwordLineView.frame)+10*Scale, 84*Scale, 20*Scale);
    [self.forgetPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    self.forgetPasswordButton.titleLabel.font = Font14;
    [self.forgetPasswordButton setTitleColor:RGBA(80, 130, 230, 1) forState:UIControlStateNormal];

    
    /** loginButton */
    self.loginButton = [UIButton new];
    [self addSubview:self.loginButton];
    self.loginButton.bounds = CGRectMake(0, 0, ScreenW-76*Scale, 44*Scale);
    self.loginButton.center = CGPointMake(self.center.x, CGRectGetMaxY(self.forgetPasswordButton.frame)+62*Scale);
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.backgroundColor = RGBA(204, 204, 204, 1);
    self.loginButton.layer.cornerRadius = 8*Scale;
    self.loginButton.userInteractionEnabled = NO;
    
    NSString *delegateText = @"同意 学考乐用户协议 和 隐私政策";
    CGRect delegateTextRect = [delegateText boundingRectWithSize:CGSizeMake(ScreenW, ScreenH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Font12} context:nil];
    CGSize delegateTextSize = CGSizeMake(ceilf(delegateTextRect.size.width), ceilf(delegateTextRect.size.height));
    CGFloat loginDelegateButtonX = (ScreenW - 36*Scale - delegateTextSize.width)/2;
    
    /** loginDelegateButton */
    self.loginDelegateButton = [UIButton new];
    [self addSubview:self.loginDelegateButton];
    self.loginDelegateButton.frame = CGRectMake(loginDelegateButtonX, CGRectGetMaxY(self.loginButton.frame)+40*Scale, 16*Scale, 16*Scale);
    [self.loginDelegateButton setImage:[UIImage imageNamed:@"delegate_c_icon"] forState:UIControlStateNormal];
    [self.loginDelegateButton setImage:[UIImage imageNamed:@"delegate_u_icon"] forState:UIControlStateSelected];
    
    /** loginDelegateTextView */
    self.loginDelegateTextView = [UITextView new];
    [self addSubview:self.loginDelegateTextView];
    self.loginDelegateTextView.frame = CGRectMake(loginDelegateButtonX+24*Scale, self.loginDelegateButton.frame.origin.y, delegateTextSize.width+12*Scale, 20*Scale);
    self.loginDelegateTextView.userInteractionEnabled = YES;
    self.loginDelegateTextView.editable = NO;
    self.loginDelegateTextView.scrollEnabled = NO;
    self.loginDelegateTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.loginDelegateTextView.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *delegateAttributedString = [[NSMutableAttributedString alloc] initWithString:delegateText attributes:@{NSFontAttributeName:Font12,NSForegroundColorAttributeName:RGBA(138, 138, 153, 1)}];
    NSRange poRange = [delegateText rangeOfString:@"学考乐用户协议"];
    NSRange zcRange = [delegateText rangeOfString:@"隐私政策"];
    [delegateAttributedString addAttributes:@{NSForegroundColorAttributeName:RGBA(80, 130, 230, 1),NSLinkAttributeName:@"protocol"} range:poRange];
    [delegateAttributedString addAttributes:@{NSForegroundColorAttributeName:RGBA(80, 130, 230, 1),NSLinkAttributeName:@"privacy"} range:zcRange];
    self.loginDelegateTextView.attributedText = delegateAttributedString;
    
}

#pragma mark - Action
- (void)passwordSecureButtonAction
{
    if (self.passwordSecureButton.selected) {
        self.passwordSecureButton.selected = NO;
        self.passwordTextField.secureTextEntry = YES;
    } else {
        self.passwordSecureButton.selected = YES;
        self.passwordTextField.secureTextEntry = NO;
    }
}


@end
