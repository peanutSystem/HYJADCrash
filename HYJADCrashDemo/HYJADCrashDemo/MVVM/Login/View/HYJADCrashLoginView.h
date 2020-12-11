//
//  HYJADCrashLoginView.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/11.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYJADCrashLoginView : UIView

/** 图标 */
@property (nonatomic, strong) UIImageView *logoImageView;

/** 账号 输入框 */
@property (nonatomic, strong) UITextField *accountTextField;

/** 账号输入框分界线 */
@property (nonatomic, strong) UIView *accountLineView;

/** 密码 输入框 */
@property (nonatomic, strong) UITextField *passwordTextField;

/** 密码明暗文 按钮 */
@property (nonatomic, strong) UIButton *passwordSecureButton;

/** 密码输入框分界线 */
@property (nonatomic, strong) UIView *passwordLineView;

/** 忘记密码 按钮 */
@property (nonatomic, strong) UIButton *forgetPasswordButton;

/** 登录按钮 */
@property (nonatomic, strong) UIButton *loginButton;

/** 协议勾选 按钮 */
@property (nonatomic, strong) UIButton *loginDelegateButton;

/** 协议勾选 文本 */
@property (nonatomic, strong) UITextView *loginDelegateTextView;


@end

NS_ASSUME_NONNULL_END
