//
//  HYJADCrashUserInfo.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/14.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYJADCrashUserInfo : NSObject

/** token */
@property (nonatomic, copy) NSString *token;

/** 昵称 */
@property (nonatomic, copy) NSString *nick;

/** 用户头像 */
@property (nonatomic, copy) NSString *userHeadUrl;

/** 账号截止日期 */
@property (nonatomic, assign) int expiryDate;

/** 账号状态 */
@property (nonatomic, assign) int status;


+ (instancetype)share;

@end

NS_ASSUME_NONNULL_END
