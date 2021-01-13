//
//  HYJADCrashTapGestureRecognizer.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/20.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYJADCrashTapGestureRecognizer : UITapGestureRecognizer

/** 持有类名称 */
@property (nonatomic, copy) NSString *superClassName;

@end

NS_ASSUME_NONNULL_END
